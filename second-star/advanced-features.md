# Advanced Features

This guide covers advanced features and capabilities of Second Star.

## Custom Test Generators

Create your own test generators by extending the base generator class:

```php
use ThinkNeverland\SecondStar\Generators\BaseTestGenerator;

class CustomTestGenerator extends BaseTestGenerator
{
    protected function getStub(): string
    {
        return 'custom.stub';
    }

    protected function getMethods(): array
    {
        $methods = parent::getMethods();
        // Add custom method handling
        return $methods;
    }

    protected function getDependencies(): array
    {
        $dependencies = parent::getDependencies();
        // Add custom dependency handling
        return $dependencies;
    }
}
```

## Custom Test Templates

Create custom test templates to match your project's style:

```php
// resources/stubs/secondstar/custom.stub
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

## Advanced Mocking

### Custom Mock Classes

Define custom mock classes for specific dependencies:

```php
use ThinkNeverland\SecondStar\Mocks\CustomMock;

class UserRepositoryTest extends TestCase
{
    protected function getMockClass(string $class): string
    {
        if ($class === UserRepository::class) {
            return CustomUserRepositoryMock::class;
        }
        return parent::getMockClass($class);
    }
}
```

### Mock Behavior Configuration

Configure mock behavior in your tests:

```php
use Mockery;

class UserServiceTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        
        $this->mock(UserRepository::class, function ($mock) {
            $mock->shouldReceive('find')
                ->with(1)
                ->andReturn(new User(['id' => 1]));
        });
    }
}
```

## Test Data Generation

### Custom Data Providers

Create custom data providers for your tests:

```php
use ThinkNeverland\SecondStar\DataProviders\CustomDataProvider;

class UserServiceTest extends TestCase
{
    use CustomDataProvider;

    /**
     * @dataProvider userDataProvider
     */
    public function test_create_user($data)
    {
        // Test implementation
    }

    public function userDataProvider()
    {
        return [
            'valid user' => [
                [
                    'name' => 'John Doe',
                    'email' => 'john@example.com',
                ]
            ],
            'invalid user' => [
                [
                    'name' => '',
                    'email' => 'invalid-email',
                ]
            ],
        ];
    }
}
```

### Factory Integration

Use Laravel's model factories in your tests:

```php
use ThinkNeverland\SecondStar\Factories\CustomFactory;

class UserServiceTest extends TestCase
{
    use CustomFactory;

    public function test_create_user()
    {
        $userData = $this->factory(User::class)->make()->toArray();
        
        $user = $this->service->create($userData);
        
        $this->assertInstanceOf(User::class, $user);
        $this->assertEquals($userData['name'], $user->name);
    }
}
```

## Test Organization

### Test Groups

Organize your tests into logical groups:

```php
use ThinkNeverland\SecondStar\Groups\TestGroup;

class UserServiceTest extends TestCase
{
    use TestGroup;

    protected function getGroups(): array
    {
        return [
            'user-management',
            'authentication',
        ];
    }
}
```

### Test Categories

Categorize your tests for better organization:

```php
use ThinkNeverland\SecondStar\Categories\TestCategory;

class UserServiceTest extends TestCase
{
    use TestCategory;

    protected function getCategory(): string
    {
        return 'user-service';
    }
}
```

## Advanced Assertions

### Custom Assertions

Create custom assertions for your tests:

```php
use ThinkNeverland\SecondStar\Assertions\CustomAssertion;

class UserServiceTest extends TestCase
{
    use CustomAssertion;

    public function test_user_has_valid_role()
    {
        $user = $this->service->create([
            'name' => 'John Doe',
            'role' => 'admin',
        ]);

        $this->assertUserHasRole($user, 'admin');
    }
}
```

### Complex Assertions

Use complex assertions for testing relationships:

```php
use ThinkNeverland\SecondStar\Assertions\ComplexAssertion;

class UserServiceTest extends TestCase
{
    use ComplexAssertion;

    public function test_user_has_valid_permissions()
    {
        $user = $this->service->create([
            'name' => 'John Doe',
            'role' => 'admin',
        ]);

        $this->assertUserHasPermissions($user, [
            'create-user',
            'edit-user',
            'delete-user',
        ]);
    }
}
```

## Performance Optimization

### Test Caching

Enable test caching for faster execution:

```php
use ThinkNeverland\SecondStar\Cache\TestCache;

class UserServiceTest extends TestCase
{
    use TestCache;

    protected function setUp(): void
    {
        parent::setUp();
        $this->enableCache();
    }
}
```

### Parallel Testing

Run tests in parallel for better performance:

```php
use ThinkNeverland\SecondStar\Parallel\ParallelTest;

class UserServiceTest extends TestCase
{
    use ParallelTest;

    protected function setUp(): void
    {
        parent::setUp();
        $this->enableParallel();
    }
}
```

## Next Steps

- Review [Best Practices](best-practices.md)
- Check out [Examples](examples.md)
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/second-star/) for more resources

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
