# 🏴‍☠️ Jolly Packager

Jolly Packager is a Laravel package that helps you create and document Laravel packages with a pirate's flair! It provides powerful tools for generating package structures and comprehensive documentation.

## 🎯 Key Features

### Package Generation

- **Complete Package Structure**: Creates a fully configured Laravel package
- **Composer Integration**: Generates `composer.json` with proper configuration
- **Service Provider**: Creates a service provider with basic setup
- **Git Integration**: Initializes git repository with `.gitignore`
- **Directory Structure**: Creates standard Laravel package directories

### Documentation Generation

- **Comprehensive Docs**: Generates detailed documentation for your codebase
- **Multiple Formats**: Supports various documentation types:
  - Controllers
  - Models
  - Routes
  - Components
- **Custom Templates**: Uses customizable documentation templates
- **Exclusion Patterns**: Allows excluding specific directories and files

## 🔧 System Requirements

- PHP 8.1 or higher
- Laravel 10.0 or higher
- Composer

## 🚀 Quick Start

1. Install via Composer:

```bash
composer require thinkneverland/jollypackager
```

2. Publish the configuration:

```bash
php artisan vendor:publish --tag=config
```

3. Create a new package:

```bash
php artisan jolly:make vendor package
```

4. Generate documentation:

```bash
php artisan jolly:docs app --output=docs
```

## 📚 Documentation

For detailed documentation, please visit our [GitBook documentation](https://thinkneverland.gitbook.io/jolly-packager/).

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guide](contributing.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

Jolly Packager is open-source software licensed under the MIT license. See the [LICENSE](LICENSE.md) file for more details.
