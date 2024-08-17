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
          if method_used?(method)
            un_used_methods << "#{file}: #{method}"
            p un_used_methods
          end
        end
      end

      un_used_methods
    end

    def extract_methods(file)
      content = File.read(file)
      content.scan(/def (\w+)/).flatten
    end

    def method_used?(method)
      puts "Checking if method '#{method}' is used..."
      # Patterns to detect method calls
      method_call_pattern = /#{method}\s*\(/
      # Search directories for relevant file types
      files = Dir.glob("app/**/*.{rb,html,erb,haml,slim,js,jsx,ts,tsx}") + Dir.glob("lib/**/*.{rb}")
      method_defined = false
      method_used = false
      files.each do |file|
        content = File.read(file)
        # Check for method definition
        method_definition_pattern = /def\s+#{method}\b/
        if content =~ method_definition_pattern
          method_defined = true
          puts "Method '#{method}' defined in file: #{file}"
        end
        # Check for method usage
        if content =~ method_call_pattern
          method_used = true
          puts "Method '#{method}' called in file: #{file}"
        end
      end
      method_defined && !method_used
    end

    def report_un_used_methods(unused_methods)
      if unused_methods.empty?
        puts "No un used methods found!"
      else
        puts "Un used Methods found in your model, controller, and helper directories:"
        unused_methods.each { |method| puts method }
      end
    end
  end
end
