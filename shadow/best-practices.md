# Best Practices

This guide outlines best practices for using Shadow effectively in your Laravel applications.

## API Design

### Resource Naming

- Use plural nouns for resource collections
- Use consistent naming conventions
- Keep URLs clean and RESTful

```http
# Good
GET /shadow-api/model/users
GET /shadow-api/model/posts
GET /shadow-api/model/comments

# Bad
GET /shadow-api/model/getUsers
GET /shadow-api/model/user_list
GET /shadow-api/model/user/items
```

### Response Format

- Maintain consistent response structure
- Include relevant metadata
- Use appropriate HTTP status codes

```json
{
    "success": true,
    "message": "Operation successful",
    "data": { ... },
    "meta": {
        "timestamp": "2024-01-01T12:00:00Z",
        "request_id": "550e8400-e29b-41d4-a716-446655440000"
    }
}
```

## Model Configuration

### Basic Setup

- Use the `HasShadow` trait consistently
- Define clear validation rules
- Specify searchable and sortable fields

```php
class User extends Model
{
    use HasShadow;
    
    protected $fillable = ['name', 'email', 'password'];
    
    public static function shadowConfig()
    {
        return [
            'validation' => [
                'create' => [
                    'name' => 'required|string|max:255',
                    'email' => 'required|email|unique:users',
                ],
            ],
            'searchable' => ['name', 'email'],
            'sortable' => ['created_at', 'name'],
        ];
    }
}
```

### Relationship Handling

- Define clear relationship configurations
- Use eager loading appropriately
- Handle nested relationships carefully

```php
class Post extends Model
{
    use HasShadow;
    
    public static function shadowConfig()
    {
        return [
            'relationships' => [
                'include' => ['author', 'comments'],
                'exclude' => ['drafts'],
            ],
        ];
    }
}
```

## Security

### Authentication

- Implement proper authentication
- Use secure token management
- Apply appropriate middleware

```php
// config/shadow.php
return [
    'auth' => [
        'guard' => 'api',
        'middleware' => ['auth:api'],
    ],
];
```

### Authorization

- Define clear access policies
- Implement role-based access control
- Validate user permissions

```php
class User extends Model
{
    use HasShadow;
    
    public static function shadowConfig()
    {
        return [
            'authorization' => [
                'view' => function ($user) {
                    return $user->can('view-users');
                },
                'create' => function ($user) {
                    return $user->can('create-users');
                },
            ],
        ];
    }
}
```

## Performance

### Caching

- Implement appropriate caching strategies
- Use cache tags for granular control
- Set reasonable cache TTLs

```php
class Product extends Model
{
    use HasShadow;
    
    public static function shadowConfig()
    {
        return [
            'cache' => [
                'enabled' => true,
                'ttl' => 3600,
                'tags' => ['products'],
            ],
        ];
    }
}
```

### Query Optimization

- Use eager loading for relationships
- Implement pagination
- Optimize database queries

```http
# Good
GET /shadow-api/model/posts?include=author&page=1&per_page=15

# Bad
GET /shadow-api/model/posts?include=author,comments,likes,shares&page=1&per_page=100
```

## Error Handling

### Validation

- Provide clear validation messages
- Handle validation errors gracefully
- Implement custom validation rules

```php
class User extends Model
{
    use HasShadow;
    
    public static function shadowConfig()
    {
        return [
            'validation' => [
                'create' => [
                    'email' => [
                        'required',
                        'email',
                        'unique:users',
                        function ($attribute, $value, $fail) {
                            if (!filter_var($value, FILTER_VALIDATE_EMAIL)) {
                                $fail('The email must be a valid email address.');
                            }
                        },
                    ],
                ],
            ],
        ];
    }
}
```

### Error Responses

- Use consistent error formats
- Include helpful error messages
- Log errors appropriately

```json
{
    "success": false,
    "message": "Validation failed",
    "errors": {
        "email": [
            "The email must be a valid email address."
        ]
    }
}
```

## Testing

### API Testing

- Write comprehensive tests
- Test edge cases
- Mock external dependencies

```php
class UserApiTest extends TestCase
{
    public function test_can_create_user()
    {
        $response = $this->postJson('/shadow-api/model/users', [
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => 'password123',
        ]);
        
        $response->assertStatus(201)
                ->assertJsonStructure([
                    'success',
                    'message',
                    'data' => [
                        'id',
                        'name',
                        'email',
                    ],
                ]);
    }
}
```

### Performance Testing

- Test under load
- Monitor response times
- Check memory usage

```php
class PerformanceTest extends TestCase
{
    public function test_can_handle_many_requests()
    {
        $this->withoutExceptionHandling();
        
        $response = $this->getJson('/shadow-api/model/users?page=1&per_page=100');
        
        $response->assertStatus(200)
                ->assertJsonStructure([
                    'success',
                    'data',
                    'meta' => [
                        'current_page',
                        'per_page',
                        'total',
                    ],
                ]);
    }
}
```

## Documentation

### API Documentation

- Keep documentation up to date
- Include examples
- Document all endpoints

```php
class User extends Model
{
    use HasShadow;
    
    public static function shadowConfig()
    {
        return [
            'documentation' => [
                'description' => 'User management API',
                'examples' => [
                    'create' => [
                        'name' => 'John Doe',
                        'email' => 'john@example.com',
                        'password' => 'password123',
                    ],
                ],
            ],
        ];
    }
}
```

### Code Documentation

- Document complex logic
- Use clear variable names
- Add helpful comments

```php
/**
 * User model with Shadow API integration
 *
 * This model handles user management with automatic API generation.
 * It includes validation, authorization, and caching configurations.
 */
class User extends Model
{
    use HasShadow;
    
    // ... implementation
}
```

## Next Steps

- Review [Advanced Features](advanced-features.md)
- Check out [Examples](examples.md)
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/shadow/) for more resources
