# Advanced Features

This guide covers advanced features and capabilities of Shadow.

## Custom Resource Transformers

Create custom transformers to format your API responses:

```php
use Thinkneverland\Shadow\Transformers\ResourceTransformer;

class UserTransformer extends ResourceTransformer
{
    public function transform($user)
    {
        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'created_at' => $user->created_at->format('Y-m-d H:i:s'),
            'updated_at' => $user->updated_at->format('Y-m-d H:i:s'),
            'profile' => [
                'avatar' => $user->avatar_url,
                'bio' => $user->bio,
            ],
        ];
    }
}
```

## Custom Validation Rules

Define custom validation rules for your models:

```php
use Thinkneverland\Shadow\Validation\CustomRule;

class User extends Model
{
    use HasShadow;
    
    public static function shadowConfig()
    {
        return [
            'validation' => [
                'create' => [
                    'name' => ['required', 'string', 'max:255'],
                    'email' => ['required', 'email', 'unique:users'],
                    'password' => [
                        'required',
                        'string',
                        'min:8',
                        new CustomRule(function ($value) {
                            return preg_match('/[A-Z]/', $value) && 
                                   preg_match('/[a-z]/', $value) && 
                                   preg_match('/[0-9]/', $value);
                        }, 'Password must contain uppercase, lowercase, and numbers'),
                    ],
                ],
            ],
        ];
    }
}
```

## Advanced Querying

### Complex Filters

```http
GET /shadow-api/model/users?filter[status]=active&filter[role]=admin&filter[created_at][gt]=2024-01-01
```

### Custom Scopes

```php
class User extends Model
{
    use HasShadow;
    
    public static function shadowConfig()
    {
        return [
            'scopes' => [
                'active' => true,
                'verified' => true,
                'with_posts' => function ($query) {
                    return $query->has('posts');
                },
            ],
        ];
    }
}
```

### Eager Loading

```http
GET /shadow-api/model/users?include=posts,comments,profile
```

## Custom Actions

Define custom actions for your models:

```php
class User extends Model
{
    use HasShadow;
    
    public static function shadowConfig()
    {
        return [
            'actions' => [
                'verify_email' => [
                    'method' => 'POST',
                    'route' => '/verify-email',
                    'handler' => function ($user) {
                        $user->markEmailAsVerified();
                        return response()->json([
                            'message' => 'Email verified successfully'
                        ]);
                    },
                ],
                'reset_password' => [
                    'method' => 'POST',
                    'route' => '/reset-password',
                    'handler' => function ($user, $request) {
                        $user->resetPassword($request->password);
                        return response()->json([
                            'message' => 'Password reset successfully'
                        ]);
                    },
                ],
            ],
        ];
    }
}
```

## Custom Middleware

Add custom middleware to your API routes:

```php
// config/shadow.php
return [
    'middleware' => [
        'api',
        'throttle:60,1',
        function ($request, $next) {
            // Custom middleware logic
            return $next($request);
        },
    ],
];
```

## Custom Error Handling

Define custom error handlers:

```php
use Thinkneverland\Shadow\Exceptions\Handler;

class CustomHandler extends Handler
{
    protected function handleValidationException($e)
    {
        return response()->json([
            'success' => false,
            'message' => 'Validation failed',
            'errors' => $e->errors(),
        ], 422);
    }
    
    protected function handleModelNotFoundException($e)
    {
        return response()->json([
            'success' => false,
            'message' => 'Resource not found',
        ], 404);
    }
}
```

## Cache Management

### Custom Cache Keys

```php
class User extends Model
{
    use HasShadow;
    
    public static function shadowConfig()
    {
        return [
            'cache' => [
                'key' => function ($user) {
                    return "user:{$user->id}";
                },
                'ttl' => 3600,
            ],
        ];
    }
}
```

### Cache Tags

```php
// config/shadow.php
return [
    'cache' => [
        'tags' => [
            'enabled' => true,
            'prefix' => 'shadow_',
        ],
    ],
];
```

## Rate Limiting

### Custom Rate Limits

```php
// config/shadow.php
return [
    'rate_limit' => [
        'enabled' => true,
        'max_attempts' => 60,
        'decay_minutes' => 1,
        'by' => 'ip', // or 'user'
    ],
];
```

### Dynamic Rate Limiting

```php
class User extends Model
{
    use HasShadow;
    
    public static function shadowConfig()
    {
        return [
            'rate_limit' => [
                'max_attempts' => function ($user) {
                    return $user->isAdmin() ? 100 : 60;
                },
            ],
        ];
    }
}
```

## Authentication

### Custom Guards

```php
// config/shadow.php
return [
    'auth' => [
        'guard' => 'api',
        'middleware' => ['auth:api'],
    ],
];
```

### API Tokens

```php
class User extends Model
{
    use HasShadow;
    
    public static function shadowConfig()
    {
        return [
            'auth' => [
                'token' => [
                    'enabled' => true,
                    'expires_in' => 3600,
                ],
            ],
        ];
    }
}
```

## Response Formatting

### Custom Response Headers

```php
// config/shadow.php
return [
    'response' => [
        'headers' => [
            'X-API-Version' => '1.0',
            'X-Request-ID' => true,
        ],
    ],
];
```

### Response Compression

```php
// config/shadow.php
return [
    'response' => [
        'compression' => [
            'enabled' => true,
            'min_size' => 1024,
        ],
    ],
];
```

## Next Steps

- Review [Best Practices](best-practices.md)
- Check out [Examples](examples.md)
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/shadow/) for more resources
