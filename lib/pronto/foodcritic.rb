require 'pronto'
require 'foodcritic'

module Pronto
  class FoodCritic < Runner
    def initialize
      @linter = ::FoodCritic::Linter.new
    end

    def run(patches, _)
      return [] unless patches

      patches.select { |patch| patch.additions > 0 }
             .select { |patch| ruby_file?(patch.new_file_full_path) }
             .map { |patch| inspect(patch) }
             .flatten.compact
    end

    def inspect(patch)
      path = patch.new_file_full_path.to_s
      path_type = if path.include?('cookbook')
                    :cookbook_paths
                  elsif path.include?('role')
                    :role_paths
                  end

      return if path_type.nil?

      review = @linter.check({ path_type => path })
      review.warnings.select { |w| w.match[:filename] == path }.map do |warning|
        patch.added_lines.select { |line| line.new_lineno == warning.match[:line] }
                         .map { |line| new_message(warning, line) }
      end
    end

    def new_message(warning, line)
      path = line.patch.delta.new_file[:path]
      message = "#{warning.rule.code} - #{warning.rule.name}"
      Message.new(path, line, :warning, message)
    end
  end
end
