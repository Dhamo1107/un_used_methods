# frozen_string_literal: true

# The CLI class provides the command-line interface for the UnUsedMethods gem.

# This class is responsible for handling command-line arguments and executing
# the appropriate tasks. It uses the Thor gem to define commands and options
# that users can run from the command line.

require "thor"

module UnUsedMethods
  class CLI < Thor
    desc "find_unused", "Find unused methods in models, controllers and helpers"
    def find_unused
      UnUsedMethods::Analyzer.new.analyze
    end
  end
end
