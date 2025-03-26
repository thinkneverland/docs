# ⭐ Second Star

Second Star is a powerful Laravel package that helps you generate comprehensive tests for your application's services and repositories. It analyzes your code and automatically generates appropriate test cases, saving you time and ensuring consistent test coverage.

## 🎯 Key Features

### Test Generation

- **Repository Tests**: Automatically generates tests for common repository methods
- **Service Tests**: Creates tests for all public service methods
- **Dependency Detection**: Automatically sets up mocks for constructor dependencies
- **Multiple Formats**: Support for both PHPUnit and Pest test frameworks

### Smart Analysis

- **Method Detection**: Identifies testable methods in your classes
- **Type Inference**: Analyzes method parameters and return types
- **Relationship Handling**: Understands and tests model relationships
- **Mock Generation**: Creates appropriate mocks for dependencies

### Customization

- **Custom Stubs**: Modify test templates to match your coding style
- **Output Control**: Choose where to generate test files
- **Namespace Support**: Customize test namespaces
- **Framework Choice**: Switch between PHPUnit and Pest

## 🔧 System Requirements

- PHP 8.1 or higher
- Laravel 10.0 or higher
- PHPUnit 10.0 or higher (for PHPUnit tests)
- Pest 2.0 or higher (for Pest tests)

## 🚀 Quick Start

1. Install via Composer:

```bash
composer require thinkneverland/second-star
```

2. Publish the configuration:

```bash
php artisan vendor:publish --provider="ThinkNeverland\SecondStar\SecondStarServiceProvider" --tag="config"
```

3. Generate your first test:

```bash
php artisan test:generate --file=app/Repositories/UserRepository.php --unit --phpunit
```

## 📚 Documentation

For detailed documentation, please visit our [GitBook documentation](https://thinkneverland.gitbook.io/second-star/).

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guide](contributing.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

Second Star is open-source software licensed under the MIT license. See the [LICENSE](LICENSE.md) file for more details.
