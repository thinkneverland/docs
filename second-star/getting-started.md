# Getting Started with Second Star

This guide will help you get started with Second Star, from installation to generating your first test.

## Installation

1. Install the package via Composer:

```bash
composer require thinkneverland/second-star
```

2. Publish the configuration file:

```bash
php artisan vendor:publish --provider="ThinkNeverland\SecondStar\SecondStarServiceProvider" --tag="config"
```

This will create a `config/secondstar.php` file where you can configure the package.

## Basic Usage

### Command Line Interface

The package provides an Artisan command to generate tests:

```bash
php artisan test:generate --file=app/Repositories/UserRepository.php --unit --phpunit
```

#### Available Options

- `--file`: The path to the file to generate tests for (required)
- `--unit`: Generate a unit test (default: true)
- `--feature`: Generate a feature test
- `--phpunit`: Use PHPUnit (default: true)
- `--pest`: Use Pest
- `--output`: The directory to output the test to
- `--namespace`: The namespace to use for the test

#### Examples

```bash
# Generate a unit test for a repository
php artisan test:generate --file=app/Repositories/UserRepository.php --unit --phpunit

# Generate a feature test for a service
php artisan test:generate --file=app/Services/UserService.php --feature --phpunit

# Generate a test with custom output directory
php artisan test:generate --file=app/Repositories/UserRepository.php --unit --phpunit --output=tests/Custom

# Generate a test with custom namespace
php artisan test:generate --file=app/Services/UserService.php --unit --phpunit --namespace=Custom
```

### Programmatic Usage

You can also use the generators programmatically:

```php
use ThinkNeverland\SecondStar\Generators\RepositoryTestGenerator;
use ThinkNeverland\SecondStar\Generators\ServiceTestGenerator;

// Generate a repository test
$repositoryGenerator = app(RepositoryTestGenerator::class);
$repositoryTest = $repositoryGenerator->generate(
    app_path('Repositories/UserRepository.php'),
    ['unit' => true, 'phpunit' => true]
);

// Generate a service test
$serviceGenerator = app(ServiceTestGenerator::class);
$serviceTest = $serviceGenerator->generate(
    app_path('Services/UserService.php'),
    ['unit' => true, 'phpunit' => true]
);
```

## Test Generators

### Repository Test Generator

The Repository Test Generator analyzes your repository classes and generates tests for common repository methods:

- `find()`: Tests finding a single record
- `all()`: Tests retrieving all records
- `create()`: Tests creating new records
- `update()`: Tests updating existing records
- `delete()`: Tests deleting records
- `findBy()`: Tests finding records by criteria
- `findOrFail()`: Tests finding or failing
- `firstOrCreate()`: Tests first or create functionality

It also detects dependencies in the constructor and sets up mocks for them in the test.

### Service Test Generator

The Service Test Generator analyzes your service classes and generates tests for all public methods. It:

- Detects method parameters and return types
- Sets up appropriate mocks for dependencies
- Generates test cases for success and failure scenarios
- Handles complex method signatures
- Supports method chaining

## Customization

### Custom Test Stubs

You can customize the test stubs by publishing them:

```bash
php artisan vendor:publish --provider="ThinkNeverland\SecondStar\SecondStarServiceProvider" --tag="stubs"
```

This will create stub files in the `resources/stubs/secondstar` directory that you can modify.

### Configuration Options

The `config/secondstar.php` file allows you to configure:

- Default test framework (PHPUnit or Pest)
- Default test type (unit or feature)
- Output directory structure
- Namespace conventions
- Mock generation preferences

## Next Steps

- Check out the [API Reference](api-reference.md) for detailed documentation
- Learn about [Advanced Features](advanced-features.md)
- Review [Best Practices](best-practices.md)
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/second-star/) for more resources
