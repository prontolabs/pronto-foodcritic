require 'pronto'
require 'foodcritic'

module Pronto
  class FoodCritic < Runner
    def run
      return [] if paths[:cookbook_paths].none? && paths[:role_paths].none?

      @linter = ::FoodCritic::Linter.new
      @linter.check(paths).warnings.flat_map do |warning|
        ruby_patches.select { |patch| patch.new_file_full_path.to_s == warning.match[:filename] }
          .flat_map(&:added_lines)
          .select { |line| line.new_lineno == warning.match[:line] }
          .flat_map { |line| new_message(warning, line) }
      end
    end

    def paths
      @paths ||= begin
        result = { cookbook_paths: [], role_paths: [] }
        ruby_patches.each do |patch|
          path = patch.new_file_full_path.to_s
          if path.include?('cookbook')
            result[:cookbook_paths] << path
          elsif path.include?('role')
            result[:role_paths] << path
          end
        end
        result
      end
    end

    def new_message(warning, line)
      path = line.patch.delta.new_file[:path]
      message = "#{warning.rule.code} - #{warning.rule.name}"
      Message.new(path, line, :warning, message)
    end
  end
end
