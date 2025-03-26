# API Reference

This document provides detailed information about Second Star's API, including commands, generators, and configuration options.

## Commands

### `test:generate`

Generates tests for a specified file.

```bash
php artisan test:generate --file=path/to/file.php [options]
```

#### Arguments

- `--file`: Path to the file to generate tests for (required)

#### Options

- `--unit`: Generate a unit test (default: true)
- `--feature`: Generate a feature test
- `--phpunit`: Use PHPUnit (default: true)
- `--pest`: Use Pest
- `--output`: Directory to output the test to
- `--namespace`: Namespace to use for the test

#### Examples

```bash
# Generate a unit test
php artisan test:generate --file=app/Repositories/UserRepository.php --unit --phpunit

# Generate a feature test
php artisan test:generate --file=app/Services/UserService.php --feature --phpunit
```

## Generators

### RepositoryTestGenerator

Generates tests for repository classes.

```php
use ThinkNeverland\SecondStar\Generators\RepositoryTestGenerator;

$generator = app(RepositoryTestGenerator::class);
$test = $generator->generate(string $file, array $options = []);
```

#### Parameters

- `$file`: Path to the repository file
- `$options`: Array of generation options
  - `unit`: Whether to generate a unit test (default: true)
  - `feature`: Whether to generate a feature test
  - `phpunit`: Whether to use PHPUnit (default: true)
  - `pest`: Whether to use Pest
  - `output`: Output directory
  - `namespace`: Test namespace

#### Returns

- `string`: Generated test content

### ServiceTestGenerator

Generates tests for service classes.

```php
use ThinkNeverland\SecondStar\Generators\ServiceTestGenerator;

$generator = app(ServiceTestGenerator::class);
$test = $generator->generate(string $file, array $options = []);
```

#### Parameters

- `$file`: Path to the service file
- `$options`: Array of generation options
  - `unit`: Whether to generate a unit test (default: true)
  - `feature`: Whether to generate a feature test
  - `phpunit`: Whether to use PHPUnit (default: true)
  - `pest`: Whether to use Pest
  - `output`: Output directory
  - `namespace`: Test namespace

#### Returns

- `string`: Generated test content

## Configuration

### `config/secondstar.php`

The configuration file allows you to customize Second Star's behavior.

```php
return [
    /*
    |--------------------------------------------------------------------------
    | Default Test Framework
    |--------------------------------------------------------------------------
    |
    | This option controls which test framework to use by default.
    | Supported values: "phpunit", "pest"
    |
    */
    'framework' => env('SECONDSTAR_FRAMEWORK', 'phpunit'),

    /*
    |--------------------------------------------------------------------------
    | Default Test Type
    |--------------------------------------------------------------------------
    |
    | This option controls which type of test to generate by default.
    | Supported values: "unit", "feature"
    |
    */
    'type' => env('SECONDSTAR_TYPE', 'unit'),

    /*
    |--------------------------------------------------------------------------
    | Output Directory
    |--------------------------------------------------------------------------
    |
    | This option controls where generated tests will be placed.
    |
    */
    'output' => [
        'path' => env('SECONDSTAR_OUTPUT_PATH', 'tests'),
        'namespace' => env('SECONDSTAR_NAMESPACE', 'Tests'),
    ],

    /*
    |--------------------------------------------------------------------------
    | Mock Generation
    |--------------------------------------------------------------------------
    |
    | This option controls how mocks are generated for dependencies.
    |
    */
    'mocks' => [
        'auto_detect' => true,
        'use_interface' => true,
        'mock_abstract' => true,
    ],

    /*
    |--------------------------------------------------------------------------
    | Test Templates
    |--------------------------------------------------------------------------
    |
    | This option controls which templates to use for test generation.
    |
    */
    'templates' => [
        'path' => env('SECONDSTAR_TEMPLATES_PATH', 'resources/stubs/secondstar'),
    ],
];
```

## Traits

### `PorterConfigurable`

A trait that can be used to configure how a model's data is handled during export/import operations.

```php
use ThinkNeverland\Porter\Traits\PorterConfigurable;

class User extends Model
{
    use PorterConfigurable;

    // Fields to randomize during export/import
    protected $omittedFromPorter = ['email', 'name'];
    
    // Specific row IDs to keep unchanged
    protected $keepForPorter = [1, 2, 3];
    
    // Exclude this model from operations
    protected $ignoreFromPorter = true;
}
```

#### Properties

- `$omittedFromPorter`: Array of field names to randomize
- `$keepForPorter`: Array of row IDs to preserve
- `$ignoreFromPorter`: Boolean to exclude the model

## Events

### `TestGenerated`

Fired when a test is successfully generated.

```php
use ThinkNeverland\SecondStar\Events\TestGenerated;

Event::listen(TestGenerated::class, function ($event) {
    // Handle test generation
});
```

#### Properties

- `$file`: Path to the generated test file
- `$source`: Path to the source file
- `$options`: Generation options used

## Exceptions

### `GeneratorException`

Thrown when there's an error during test generation.

```php
try {
    $generator->generate($file, $options);
} catch (GeneratorException $e) {
    // Handle generation error
}
```

### `ConfigurationException`

Thrown when there's an error in the configuration.

```php
try {
    // Access configuration
} catch (ConfigurationException $e) {
    // Handle configuration error
}
```

## Next Steps

- Learn about [Advanced Features](advanced-features.md)
- Review [Best Practices](best-practices.md)
- Check out [Examples](examples.md)
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/second-star/) for more resources
