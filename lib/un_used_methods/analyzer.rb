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

      # Check method usage within its own file
      method_called_in_own_file?(definition_file, method_call_patterns)
    end

    def build_method_call_patterns(method)
      [
        /(\.|^|\s)#{method}\s*\(/, # Matches method calls with parameters
        /(\.|^|\s)#{method}\b(?!\()/ # Matches method calls without parameters
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

    def read_file(file)
      content = File.read(file)
      strip_comments(content, file)
    end

    def strip_comments(content, file)
      case File.extname(file)
      when ".rb"
        # Remove Ruby comments
        content.gsub(/#.*$/, "")
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
