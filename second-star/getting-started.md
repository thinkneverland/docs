# Getting Started with Second Star

This guide will help you get up and running with Second Star, showing you how to install the package and generate your first tests.

## Installation

1. Install the package via Composer:

```bash
composer require thinkneverland/second-star --dev
```

2. Publish the configuration file:

```bash
php artisan vendor:publish --provider="ThinkNeverland\SecondStar\SecondStarServiceProvider"
```

## Basic Usage

### Command Line Interface

1. Generate tests for a service:

```bash
php artisan test:generate UserService
```

2. Generate tests for a repository:

```bash
php artisan test:generate UserRepository --type=repository
```

3. Generate Cypress tests:

```bash
php artisan test:cypress-setup
```

4. Generate test coverage report:

```bash
php artisan test:coverage
```

### Configuration

The configuration file `config/second-star.php` allows you to customize:

```php
return [
    'output' => [
        'path' => 'tests',
        'namespace' => 'Tests',
    ],
    'templates' => [
        'path' => 'stubs/tests',
    ],
    'coverage' => [
        'minimum' => 80,
        'format' => 'html',
    ],
    'exclude' => [
        'patterns' => [
            '#/vendor/#',
            '#/node_modules/#',
        ],
    ],
];
```

## Test Generation Examples

### 1. Service Test Generation

When you run:

```bash
php artisan test:generate UserService
```

Second Star will:

1. Analyze the `UserService` class
2. Identify dependencies and methods
3. Generate appropriate test cases
4. Create mocks for dependencies

Generated test will look like:

```php
namespace Tests\Unit\Services;

use Tests\TestCase;
use App\Services\UserService;
use Mockery;

class UserServiceTest extends TestCase
{
    protected UserService $service;
    
    protected function setUp(): void
    {
        parent::setUp();
        $this->service = new UserService();
    }
    
    /** @test */
    public function it_can_create_user()
    {
        // Test implementation
    }
}
```

### 2. Repository Test Generation

```bash
php artisan test:generate UserRepository --type=repository
```

This will generate tests with database interactions and model factories.

### 3. API Test Generation

```bash
php artisan test:generate UserController --type=api
```

Generates feature tests for your API endpoints.

## Cypress Setup

1. Initialize Cypress:

```bash
php artisan test:cypress-setup
```

2. This will:
   - Install Cypress via npm
   - Create base configuration
   - Set up example tests
   - Configure Laravel integration

## Best Practices

1. **Test Organization**
   - Keep tests in appropriate directories
   - Follow naming conventions
   - Group related tests

2. **Test Coverage**
   - Aim for minimum 80% coverage
   - Focus on critical paths
   - Use meaningful assertions

3. **Mocking**
   - Mock external services
   - Use factories for models
   - Avoid over-mocking

4. **Maintenance**
   - Update tests with code changes
   - Remove obsolete tests
   - Keep assertions focused

## Troubleshooting

### Common Issues

1. **Test Generation Fails**
   - Verify class exists and is autoloadable
   - Check namespace configuration
   - Ensure write permissions

2. **Coverage Report Issues**
   - Install Xdebug or PCOV
   - Configure coverage driver
   - Check file permissions

3. **Cypress Setup Problems**
   - Verify Node.js installation
   - Check npm permissions
   - Review Laravel Mix configuration

## Next Steps

- Explore the [API Reference](./api-reference.md)
- Learn about [Advanced Features](./advanced-features.md)
- Read the [Contributing Guide](../CONTRIBUTING.md)
- Join our community on GitHub
