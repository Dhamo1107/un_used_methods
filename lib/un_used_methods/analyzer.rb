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
          un_used_methods << "#{file}: #{method}" if method_used?(method, file)
        end
      end

      un_used_methods
    end

    def extract_methods(file)
      content = File.read(file)
      content.scan(/def (\w+)/).flatten
    end

    def method_used?(method, definition_file)
      # Patterns to detect method calls with and without parentheses
      method_call_pattern = /(\.|^|\s)#{method}\s*(\(|$)/
      # Search directories for relevant file types
      files = Dir.glob("app/**/*.{rb,html,erb,haml,slim,js,jsx,ts,tsx}") + Dir.glob("lib/**/*.{rb}")
      method_used = false
      files.each do |file|
        content = File.read(file)
        # Check for method usage (skip the method's own definition line)
        if content =~ method_call_pattern && file != definition_file
          method_used = true
          p "Method '#{method}' called in file: #{file}"
          break
        elsif content.scan(method_call_pattern).count > 1 && file == definition_file
          method_used = true
          p "Method '#{method}' called in its own file: #{file}"
          break
        end
      end
      !method_used
    end

    def report_un_used_methods(unused_methods)
      if unused_methods.empty?
        p "No un used methods found!"
      else
        p "Un used Methods found in your model, controller, and helper directories:"
        unused_methods.each { |method| puts method }
      end
    end
  end
end
