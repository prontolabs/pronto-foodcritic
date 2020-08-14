require 'pronto'
require 'foodcritic'

module Pronto
  class FoodCritic < Runner
    def run
      return [] if paths[:cookbook_paths].none? && paths[:role_paths].none?

      @linter = ::FoodCritic::Linter.new
      @linter.check(options).warnings.flat_map do |warning|
        ruby_patches.select { |patch| patch.new_file_full_path.to_s == warning.match[:filename] }
          .flat_map(&:added_lines)
          .select { |line| line.new_lineno == warning.match[:line] }
          .flat_map { |line| new_message(warning, line) }
      end
    end

    def options
      @options ||= begin
        result = {}.merge(paths)
        result[:rule_file] = foodcritic_rule_file if foodcritic_rule_file
        result[:search_gems] = foodcritic_search_gems if foodcritic_search_gems
        result[:include_rules] = Array(foodcritic_include_rules)
        result
      end
    end

    def paths
      @paths ||= begin
        result = { cookbook_paths: [], role_paths: [] }
        ruby_patches.each do |patch|
          path = patch.new_file_full_path.to_s
          next if foodcritic_exclude.any? { |r| File.fnmatch(r, path) }
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
      Message.new(path, line, :warning, message, nil, self.class)
    end

    def pronto_foodcritic_config
      @pronto_foodcritic_config ||= Pronto::ConfigFile.new.to_h['foodcritic'] || {}
    end

    def foodcritic_search_gems
      pronto_foodcritic_config.fetch('search_gems', nil)
    end

    def foodcritic_rule_file
      pronto_foodcritic_config.fetch('rule_file', nil)
    end

    def foodcritic_include_rules
      pronto_foodcritic_config.fetch('include_rules', [])
    end

    def foodcritic_exclude
      Array(pronto_foodcritic_config.fetch('exclude', []))
    end

  end
end
