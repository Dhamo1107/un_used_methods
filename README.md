# UnUsedMethods Gem

[![Gem Version](https://badge.fury.io/rb/un_used_methods.svg)](https://badge.fury.io/rb/un_used_methods)
[![Ruby](https://github.com/Dhamo1107/un_used_methods/actions/workflows/main.yml/badge.svg)](https://github.com/Dhamo1107/un_used_methods/actions/workflows/main.yml)

The `un_used_methods` gem is designed to help you identify and clean up unused methods in your Ruby on Rails application. In a large codebase, it can be challenging to track which methods are actively used and which are obsolete. The `un_used_methods` gem scans your application's codebase and identifies methods that are defined but not used anywhere else in your project. This helps you spot and remove unnecessary code, improving maintainability and performance.


## Features

- Scans for method definitions across various directories (models, controllers, helpers, views, and more).
- Checks for method usage in code files and view templates.
- Reports methods that are defined but not used in the project.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'un_used_methods'
```

Then run:

```ruby
bundle install
```

## Usage

To use the gem, run the following command:

```ruby
bundle exec un_used_methods find_unused
```

This command will analyze your codebase and print out any unused methods it finds. The gem scans through Ruby files, HTML/ERB templates, and other relevant file types to ensure comprehensive coverage.

## Example Output

```plaintext
Unused Methods found in your model, controller and helper directories:
app/models/test.rb: another_method
```
Or
```plaintext
No unused methods found!
```

## Configuration

The gem uses default settings to scan common directories and file types. If you need to customize the directories or file types to scan, you can modify the gem's configuration within the codebase.

## Development

To contribute to the development of this gem:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Create a new Pull Request.
6. Write RSpec test cases for the features you added.

## License

This gem is available as open source under the terms of the MIT License.

## Acknowledgements

This gem leverages concepts from static code analysis and method usage detection to enhance code quality.
