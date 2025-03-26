# Second Star API Reference

This document provides detailed information about Second Star's API, including classes, methods, and configuration options.

## Core Classes

### SecondStar Facade

The `SecondStar` facade provides access to the main functionality:

```php
use ThinkNeverland\SecondStar\Facades\SecondStar;

// Generate tests
SecondStar::generate($className, $options);

// Generate coverage
SecondStar::coverage($options);

// Setup Cypress
SecondStar::setupCypress($options);
```

### TestGenerator

The base test generator class that all specific generators extend:

```php
abstract class BaseTestGenerator implements TestGenerator
{
    public function generate(string $className): void;
    public function setOptions(array $options): self;
    public function getStub(): string;
    protected function parseClass(string $className): ReflectionClass;
    protected function getMethods(): array;
    protected function getDependencies(): array;
}
```

## Available Generators

### ServiceTestGenerator

Generates tests for service classes:

```php
use ThinkNeverland\SecondStar\Generators\ServiceTestGenerator;

$generator = new ServiceTestGenerator();
$generator->setOptions([
    'namespace' => 'Tests\\Unit\\Services',
    'suffix' => 'Test',
    'mock_dependencies' => true,
]);
$generator->generate('App\\Services\\UserService');
```

### RepositoryTestGenerator

Generates tests for repository classes:

```php
use ThinkNeverland\SecondStar\Generators\RepositoryTestGenerator;

$generator = new RepositoryTestGenerator();
$generator->setOptions([
    'namespace' => 'Tests\\Unit\\Repositories',
    'use_factories' => true,
]);
$generator->generate('App\\Repositories\\UserRepository');
```

### ApiTestGenerator

Generates API feature tests:

```php
use ThinkNeverland\SecondStar\Generators\ApiTestGenerator;

$generator = new ApiTestGenerator();
$generator->setOptions([
    'namespace' => 'Tests\\Feature\\Api',
    'with_authentication' => true,
]);
$generator->generate('App\\Http\\Controllers\\Api\\UserController');
```

## Commands

### TestGenerateCommand

```bash
php artisan test:generate [className] [options]

Options:
  --type=TYPE           Type of test to generate (service|repository|api)
  --namespace=NAMESPACE Custom namespace for generated test
  --suffix=SUFFIX       Custom suffix for test class name
  --force              Overwrite existing test file
```

### TestCoverageCommand

```bash
php artisan test:coverage [options]

Options:
  --format=FORMAT      Output format (html|clover|text)
  --min=PERCENTAGE    Minimum required coverage percentage
  --output=PATH       Custom output path for coverage report
```

### CypressSetupCommand

```bash
php artisan test:cypress-setup [options]

Options:
  --force             Overwrite existing Cypress setup
  --with-examples     Include example tests
```

## Configuration

### Test Generation

```php
'generators' => [
    'service' => [
        'class' => ServiceTestGenerator::class,
        'namespace' => 'Tests\\Unit\\Services',
        'suffix' => 'Test',
    ],
    'repository' => [
        'class' => RepositoryTestGenerator::class,
        'namespace' => 'Tests\\Unit\\Repositories',
        'suffix' => 'Test',
    ],
    'api' => [
        'class' => ApiTestGenerator::class,
        'namespace' => 'Tests\\Feature\\Api',
        'suffix' => 'Test',
    ],
],
```

### Coverage Configuration

```php
'coverage' => [
    'driver' => 'pcov', // or 'xdebug'
    'minimum' => 80,
    'format' => 'html',
    'output' => 'coverage',
    'exclude' => [
        'paths' => [
            'app/Console/Kernel.php',
            'app/Exceptions/Handler.php',
        ],
    ],
],
```

### Cypress Configuration

```php
'cypress' => [
    'baseUrl' => 'http://localhost:8000',
    'video' => false,
    'screenshots' => true,
    'supportFile' => 'cypress/support/index.js',
    'integrationFolder' => 'cypress/integration',
],
```

## Events

Second Star dispatches events during test generation:

```php
// Before test generation
TestGenerationStarting::class

// After test generation
TestGenerationCompleted::class

// When coverage report is generated
CoverageReportGenerated::class
```

## Extending

### Custom Test Generators

Create a custom generator by implementing the `TestGenerator` interface:

```php
use ThinkNeverland\SecondStar\Contracts\TestGenerator;

class CustomTestGenerator implements TestGenerator
{
    public function generate(string $className): void
    {
        // Implementation
    }
    
    public function setOptions(array $options): self
    {
        // Implementation
    }
}
```

Register your custom generator in the configuration:

```php
'generators' => [
    'custom' => [
        'class' => CustomTestGenerator::class,
        'namespace' => 'Tests\\Custom',
        'suffix' => 'Test',
    ],
],
```

### Custom Stubs

Create custom stub files in `stubs/tests` directory:

```php
// stubs/tests/custom.stub
namespace {{ namespace }};

use Tests\TestCase;
use {{ class }};

class {{ class }}Test extends TestCase
{
    protected {{ class }} $instance;
    
    protected function setUp(): void
    {
        parent::setUp();
        $this->instance = new {{ class }}();
    }
    
    /** @test */
    public function it_works()
    {
        // Your test implementation
    }
}
```

## Error Handling

Second Star throws the following exceptions:

- `ClassNotFoundException`: When the target class cannot be found
- `InvalidGeneratorException`: When an invalid generator type is specified
- `StubNotFoundException`: When a stub file is missing
- `ConfigurationException`: When configuration is invalid
- `CoverageException`: When coverage generation fails

## Best Practices

1. **Generator Options**
   - Always set appropriate namespaces
   - Use meaningful test class names
   - Configure mocking behavior explicitly

2. **Coverage**
   - Set realistic minimum coverage requirements
   - Exclude irrelevant files
   - Use appropriate drivers

3. **Cypress**
   - Configure base URL correctly
   - Set up proper viewport settings
   - Handle authentication properly

4. **Custom Generators**
   - Follow naming conventions
   - Implement proper error handling
   - Document custom options
