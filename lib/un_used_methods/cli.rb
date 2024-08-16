require 'thor'

module UnUsedMethods
  class CLI < Thor
    desc "find_unused", "Find unused methods in models, controllers and helpers"
    def find_unused
      # Core functionality here
      UnUsedMethods::Analyzer.new.analyze
    end
  end
end
