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

      # Analyze Models, Controllers, and Helpers
      ["app/models", "app/controllers", "app/helpers"].each do |directory|
        un_used_methods += find_in_directory(directory)
      end

      un_used_methods
    end

    def find_in_directory(directory)
      un_used_methods = []

      Dir.glob("#{directory}/**/*.rb").each do |file|
        methods = extract_methods(file)
        methods.each do |method|
          un_used_methods << "#{file}: #{method}" unless method_used?(method, file)
        end
      end

      un_used_methods
    end

    def extract_methods(file)
      content = File.read(file)
      content = strip_comments(content, file)
      content.scan(/def (\w+)/).flatten
    end

    def method_used?(method, definition_file)
      method_call_patterns = build_method_call_patterns(method)

      files = Dir.glob("app/**/*.{rb,html,erb,haml,slim,js,jsx,ts,tsx}") + Dir.glob("lib/**/*.{rb}")

      # Check if method is used in any file other than its own definition file
      return true if file_contains_method_call?(files, definition_file, method_call_patterns)

      # Check if the method is used in callbacks like `before_action` or `after_action`
      return true if method_used_in_callback?(method, files)

      # Check method usage within its own file
      method_called_in_own_file?(definition_file, method_call_patterns)
    end

    def build_method_call_patterns(method)
      [
        /(\.|^|\s)#{method}\s*\(/, # Matches method calls with parameters
        /(\.|^|\s)#{method}\b(?!\()/, # Matches method calls without parameters
        /(\.|^|\s):#{method}\b/, # Matches method references as symbols (e.g., :method_name)
        /\b#{method}\b/ # Matches method as a standalone word, e.g., when passed as an argument
      ]
    end

    def file_contains_method_call?(files, definition_file, patterns)
      files.any? do |file|
        next if file == definition_file

        content = read_file(file)
        patterns.any? { |pattern| content.match?(pattern) }
      end
    end

    def method_called_in_own_file?(definition_file, patterns)
      content = read_file(definition_file)
      patterns.any? { |pattern| content.scan(pattern).count > 1 }
    end

    def method_used_in_callback?(method, files)
      # Create a dynamic regex pattern to match any Rails callback with the given method
      callback_pattern = /\b(before|after|around|validate|commit|save|create|update|destroy)\w*\s*:#{method}\b/

      files.any? do |file|
        content = read_file(file)
        content.match?(callback_pattern)
      end
    end

    def read_file(file)
      content = File.read(file)
      strip_comments(content, file)
    end

    def strip_comments(content, file)
      case File.extname(file)
      when ".rb"
        # Remove Ruby comments and strings
        content.gsub(/#.*$/, "").gsub(/"(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*'/, "")
      when ".erb", ".html", ".haml", ".slim"
        # Remove HTML, ERB, HAML, SLIM comments
        content.gsub(/<!--.*?-->/m, "").gsub(/<%#.*?%>/m, "")
      when ".js", ".jsx", ".ts", ".tsx"
        # Remove JavaScript/TypeScript comments
        content.gsub(%r{//.*$}, "").gsub(%r{/\*.*?\*/}m, "")
      else
        content
      end
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
