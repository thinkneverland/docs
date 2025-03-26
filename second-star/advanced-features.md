# Advanced Features

This guide covers advanced features and techniques for getting the most out of Second Star.

## Custom Test Templates

### Creating Custom Stubs

1. Create a new stub file in `stubs/tests`:

```php
// stubs/tests/custom-service.stub
namespace {{ namespace }};

use Tests\TestCase;
use {{ class }};
use Illuminate\Foundation\Testing\RefreshDatabase;

class {{ class }}Test extends TestCase
{
    use RefreshDatabase;
    
    protected {{ class }} $service;
    protected $dependencies = [];
    
    protected function setUp(): void
    {
        parent::setUp();
        $this->setupDependencies();
        $this->service = new {{ class }}(...$this->dependencies);
    }
    
    protected function setupDependencies(): void
    {
        {{ dependencies }}
    }
    
    {{ methods }}
}
```

2. Register the custom stub in your configuration:

```php
'stubs' => [
    'custom-service' => base_path('stubs/tests/custom-service.stub'),
],
```

3. Use the custom stub in your generator:

```php
$generator->setOptions([
    'stub' => 'custom-service',
    'namespace' => 'Tests\\Unit\\Services',
]);
```

## Advanced Test Generation

### Intelligent Method Analysis

Second Star analyzes method signatures to generate appropriate test cases:

```php
class UserService
{
    public function create(array $data): User
    {
        // Implementation
    }
}

// Generated test:
/** @test */
public function it_can_create_user()
{
    $data = [
        'name' => 'Test User',
        'email' => 'test@example.com',
    ];
    
    $user = $this->service->create($data);
    
    $this->assertInstanceOf(User::class, $user);
    $this->assertEquals($data['name'], $user->name);
    $this->assertEquals($data['email'], $user->email);
}
```

### Dependency Injection

Second Star automatically detects and mocks dependencies:

```php
class OrderService
{
    public function __construct(
        protected UserRepository $users,
        protected PaymentGateway $payments
    ) {}
}

// Generated test setup:
protected function setupDependencies(): void
{
    $this->users = Mockery::mock(UserRepository::class);
    $this->payments = Mockery::mock(PaymentGateway::class);
    $this->dependencies = [$this->users, $this->payments];
}
```

## Advanced Coverage Features

### Custom Coverage Drivers

Configure custom coverage drivers:

```php
'coverage' => [
    'driver' => [
        'class' => CustomCoverageDriver::class,
        'options' => [
            'include_dead_code' => true,
            'branch_coverage' => true,
        ],
    ],
],
```

### Coverage Reports

Generate multiple report formats:

```bash
php artisan test:coverage --format=html,clover,text
```

### Coverage Annotations

Use annotations to control coverage:

```php
/** @codeCoverageIgnore */
public function legacyMethod()
{
    // This method will be excluded from coverage
}

/** @codeCoverageIgnoreStart */
// This block will be excluded
/** @codeCoverageIgnoreEnd */
```

## Advanced Cypress Integration

### Custom Commands

Create custom Cypress commands:

```javascript
// cypress/support/commands.js
Cypress.Commands.add('login', (email, password) => {
    cy.visit('/login');
    cy.get('#email').type(email);
    cy.get('#password').type(password);
    cy.get('form').submit();
});
```

### API Testing

Test API endpoints with Cypress:

```javascript
describe('API Tests', () => {
    it('can fetch users', () => {
        cy.request('/api/users').then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body).to.have.length.greaterThan(0);
        });
    });
});
```

## Event Handling

### Custom Event Listeners

Register custom event listeners:

```php
Event::listen(TestGenerationStarting::class, function ($event) {
    Log::info("Generating tests for: {$event->className}");
});

Event::listen(TestGenerationCompleted::class, function ($event) {
    Notification::send($admins, new TestsGeneratedNotification($event->testClass));
});
```

### Event Broadcasting

Broadcast test generation events:

```php
class TestGenerationCompleted implements ShouldBroadcast
{
    public function broadcastOn()
    {
        return new PrivateChannel('test-generation');
    }
}
```

## Performance Optimization

### Parallel Test Generation

Generate multiple test files in parallel:

```php
use ThinkNeverland\SecondStar\ParallelTestGenerator;

$generator = new ParallelTestGenerator();
$generator->generate([
    'App\\Services\\UserService',
    'App\\Services\\OrderService',
    'App\\Services\\PaymentService',
]);
```

### Caching

Enable stub caching:

```php
'cache' => [
    'enabled' => true,
    'driver' => 'file',
    'path' => storage_path('framework/cache/stubs'),
],
```

## Security Features

### Sensitive Data Handling

Configure sensitive data patterns:

```php
'security' => [
    'sensitive_patterns' => [
        '/password/i',
        '/secret/i',
        '/key/i',
    ],
],
```

### Test Data Sanitization

Use data sanitization in tests:

```php
/** @test */
public function it_handles_sensitive_data()
{
    $data = $this->getSanitizedTestData();
    $result = $this->service->process($data);
    $this->assertSanitized($result);
}
```

## Debugging Tools

### Debug Mode

Enable debug mode for detailed output:

```bash
php artisan test:generate UserService --debug
```

### Test Generation Logging

Configure detailed logging:

```php
'logging' => [
    'enabled' => true,
    'channel' => 'second-star',
    'level' => 'debug',
],
```

## Integration with CI/CD

### GitHub Actions

Example workflow configuration:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  tests:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2
      
      - name: Generate Tests
        run: php artisan test:generate --all
        
      - name: Run Tests
        run: php artisan test
        
      - name: Upload Coverage
        uses: actions/upload-artifact@v2
        with:
          name: coverage
          path: coverage
```

### Jenkins Pipeline

Example Jenkinsfile:

```groovy
pipeline {
    agent any
    
    stages {
        stage('Generate Tests') {
            steps {
                sh 'php artisan test:generate --all'
            }
        }
        
        stage('Run Tests') {
            steps {
                sh 'php artisan test'
            }
        }
        
        stage('Coverage Report') {
            steps {
                publishHTML(target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: false,
                    keepAll: true,
                    reportDir: 'coverage',
                    reportFiles: 'index.html',
                    reportName: 'Coverage Report'
                ])
            }
        }
    }
}
