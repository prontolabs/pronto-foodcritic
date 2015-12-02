require 'pronto'
require 'foodcritic'

module Pronto
  class FoodCritic < Runner
    def initialize
      @linter = ::FoodCritic::Linter.new
    end

    def run(patches, _)
      return [] unless patches

      ruby_patches = patches.select { |patch| patch.additions > 0 }
        .select { |patch| ruby_file?(patch.new_file_full_path) }

      inspect(ruby_patches)
    end

    def inspect(patches)
      paths = chef_paths(patches)
      return [] if paths[:cookbook_paths].none? && paths[:role_paths].none?

      @linter.check(paths).warnings.flat_map do |warning|
        patches.select { |patch| patch.new_file_full_path.to_s == warning.match[:filename] }
          .flat_map(&:added_lines)
          .select { |line| line.new_lineno == warning.match[:line] }
          .flat_map { |line| new_message(warning, line) }
      end
    end

    def chef_paths(patches)
      paths = { cookbook_paths: [], role_paths: [] }
      patches.each do |patch|
        path = patch.new_file_full_path.to_s
        if path.include?('cookbook')
          paths[:cookbook_paths] << path
        elsif path.include?('role')
          paths[:role_paths] << path
        end
      end
      paths
    end

    def new_message(warning, line)
      path = line.patch.delta.new_file[:path]
      message = "#{warning.rule.code} - #{warning.rule.name}"
      Message.new(path, line, :warning, message)
    end
  end
end
