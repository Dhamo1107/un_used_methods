# frozen_string_literal: true

# This class analyzes code to find unused methods within specific directories
# such as models, controllers, and helpers.

module UnUsedMethods
  # It performs the following tasks:
  # - Searches for method definitions in the specified directories.
  # - Checks if these methods are used elsewhere in the codebase.
  # - Reports methods that are not used.
  class Analyzer
    def analyze
      un_used_methods = find_un_used_methods
      report_un_used_methods(un_used_methods)
    end

    private

    def find_un_used_methods
      un_used_methods = []

      # Analyze Models
      un_used_methods += find_in_directory("app/models")

      # Analyze Controllers
      un_used_methods += find_in_directory("app/controllers")

      # Analyze Helpers
      un_used_methods += find_in_directory("app/helpers")

      un_used_methods
    end

    def find_in_directory(directory)
      un_used_methods = []

      Dir.glob("#{directory}/**/*.rb").each do |file|
        methods = extract_methods(file)
        methods.each do |method|
          un_used_methods << "#{file}: #{method}" unless method_used?(method)
        end
      end

      un_used_methods
    end

    def extract_methods(file)
      methods = []
      content = File.read(file)
      content.scan(/def (\w+)/).flatten.each do |method_name|
        methods << method_name
      end
      methods
    end

    def method_used?(method)
      # Perform a search across the entire app to see if the method is used
      grep_result = `grep -r "#{method}" app/`
      grep_result.split("\n").size > 1 # If found more than one occurrence (definition + usage)
    end

    def report_un_used_methods(unused_methods)
      if unused_methods.empty?
        puts "No un used methods found!"
      else
        puts "Un used Methods found in your model, controller and helper directories:"
        unused_methods.each { |method| puts method }
      end
    end
  end
end
