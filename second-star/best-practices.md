# Best Practices

This guide outlines best practices for using Second Star effectively in your Laravel applications.

## Test Organization

### Directory Structure

Organize your tests following Laravel's conventions:

```
tests/
├── Unit/
│   ├── Repositories/
│   │   └── UserRepositoryTest.php
│   └── Services/
│       └── UserServiceTest.php
└── Feature/
    ├── Api/
    │   └── UserControllerTest.php
    └── Web/
        └── HomeControllerTest.php
```

### Naming Conventions

Follow consistent naming conventions:

- Test classes: `{ClassName}Test`
- Test methods: `test_{action}_{scenario}`
- Data providers: `{scenario}DataProvider`

```php
class UserServiceTest extends TestCase
{
    public function test_create_user_with_valid_data()
    {
        // Test implementation
    }

    public function test_create_user_with_invalid_data()
    {
        // Test implementation
    }

    public function validUserDataProvider()
    {
        return [
            // Test data
        ];
    }
}
```

## Test Generation

### Repository Tests

1. **Test All Methods**
   - Generate tests for all public methods
   - Include edge cases and error scenarios
   - Test both success and failure paths

2. **Mock Dependencies**
   - Mock external services
   - Use repositories for database operations
   - Avoid real database connections in unit tests

3. **Data Handling**
   - Use factories for test data
   - Clean up after tests
   - Use transactions when needed

```php
class UserRepositoryTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->repository = new UserRepository();
    }

    public function test_find_user_by_id()
    {
        $user = User::factory()->create();
        
        $result = $this->repository->find($user->id);
        
        $this->assertInstanceOf(User::class, $result);
        $this->assertEquals($user->id, $result->id);
    }
}
```

### Service Tests

1. **Method Coverage**
   - Test all public methods
   - Include validation tests
   - Test error handling

2. **Dependency Management**
   - Mock all dependencies
   - Use dependency injection
   - Avoid static calls

3. **Business Logic**
   - Test business rules
   - Verify data transformations
   - Check side effects

```php
class UserServiceTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        
        $this->repository = Mockery::mock(UserRepository::class);
        $this->service = new UserService($this->repository);
    }

    public function test_create_user_validates_email()
    {
        $this->expectException(ValidationException::class);
        
        $this->service->create([
            'name' => 'John Doe',
            'email' => 'invalid-email',
        ]);
    }
}
```

## Mocking

### Best Practices

1. **Mock Creation**
   - Create mocks in `setUp()`
   - Use type hints
   - Document mock behavior

2. **Expectations**
   - Set clear expectations
   - Use specific arguments
   - Handle edge cases

3. **Verification**
   - Verify mock calls
   - Check call order
   - Validate arguments

```php
class OrderServiceTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        
        $this->paymentGateway = Mockery::mock(PaymentGateway::class);
        $this->orderRepository = Mockery::mock(OrderRepository::class);
        $this->service = new OrderService($this->paymentGateway, $this->orderRepository);
    }

    public function test_process_order_handles_payment_failure()
    {
        $order = Order::factory()->create();
        
        $this->paymentGateway
            ->shouldReceive('process')
            ->with($order->total)
            ->once()
            ->andThrow(new PaymentException());
            
        $this->expectException(PaymentException::class);
        
        $this->service->processOrder($order);
    }
}
```

## Assertions

### Writing Effective Assertions

1. **Specificity**
   - Use specific assertions
   - Avoid generic checks
   - Test one concept per assertion

2. **Readability**
   - Use descriptive messages
   - Group related assertions
   - Follow AAA pattern (Arrange, Act, Assert)

3. **Coverage**
   - Test edge cases
   - Verify error conditions
   - Check side effects

```php
class ProductServiceTest extends TestCase
{
    public function test_update_product_updates_inventory()
    {
        // Arrange
        $product = Product::factory()->create(['stock' => 10]);
        $updateData = ['stock' => 5];
        
        // Act
        $updatedProduct = $this->service->update($product->id, $updateData);
        
        // Assert
        $this->assertEquals(5, $updatedProduct->stock);
        $this->assertDatabaseHas('inventory_logs', [
            'product_id' => $product->id,
            'action' => 'update',
            'quantity' => 5,
        ]);
    }
}
```

## Performance

### Optimization Tips

1. **Database**
   - Use transactions
   - Clean up after tests
   - Avoid unnecessary queries

2. **Mocking**
   - Mock expensive operations
   - Use lightweight mocks
   - Avoid over-mocking

3. **Setup**
   - Minimize setup code
   - Use shared fixtures
   - Cache test data

```php
class PerformanceTest extends TestCase
{
    use RefreshDatabase;
    
    protected function setUp(): void
    {
        parent::setUp();
        
        // Cache expensive setup
        if (!isset(self::$cachedData)) {
            self::$cachedData = $this->setupTestData();
        }
    }
    
    protected static function setupTestData()
    {
        return [
            'users' => User::factory()->count(100)->create(),
            'products' => Product::factory()->count(50)->create(),
        ];
    }
}
```

## Maintenance

### Keeping Tests Maintainable

1. **Documentation**
   - Document test purpose
   - Explain complex scenarios
   - Keep comments up to date

2. **Refactoring**
   - Remove duplicate code
   - Use helper methods
   - Keep tests focused

3. **Review**
   - Regular code reviews
   - Update outdated tests
   - Remove obsolete tests

```php
class MaintainableTest extends TestCase
{
    /**
     * Test user registration with email verification
     * 
     * This test verifies that:
     * 1. User can register with valid data
     * 2. Verification email is sent
     * 3. User status is set to pending
     */
    public function test_user_registration_requires_verification()
    {
        // Test implementation
    }
    
    /**
     * Helper method to create test user data
     */
    protected function createTestUserData(): array
    {
        return [
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => 'password123',
        ];
    }
}
```

## Next Steps

- Review [Advanced Features](advanced-features.md)
- Check out [Examples](examples.md)
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/second-star/) for more resources
