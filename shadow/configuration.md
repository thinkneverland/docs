# Configuration Guide

This guide covers all configuration options available in Shadow.

## Basic Configuration

The main configuration file is located at `config/shadow.php`. Here's a complete configuration example:

```php
return [
    /*
    |--------------------------------------------------------------------------
    | Route Prefix
    |--------------------------------------------------------------------------
    |
    | This option controls the base URL path for all Shadow API routes.
    |
    */
    'route_prefix' => env('SHADOW_API_PREFIX', 'shadow-api'),

    /*
    |--------------------------------------------------------------------------
    | Model Configuration
    |--------------------------------------------------------------------------
    |
    | Configure which models should be exposed in the API.
    |
    */
    'models' => [
        // Specify models to include
        'include' => [],
        
        // Specify models to exclude
        'exclude' => [],
    ],
    
    /*
    |--------------------------------------------------------------------------
    | Middleware
    |--------------------------------------------------------------------------
    |
    | Define middleware to be applied to all API routes.
    |
    */
    'middleware' => ['api'],
    
    /*
    |--------------------------------------------------------------------------
    | Documentation
    |--------------------------------------------------------------------------
    |
    | Configure API documentation settings.
    |
    */
    'enable_documentation' => env('SHADOW_DOCS_ENABLED', true),
    
    /*
    |--------------------------------------------------------------------------
    | Model Namespaces
    |--------------------------------------------------------------------------
    |
    | Define the namespaces where Shadow should look for models.
    |
    */
    'model_namespaces' => [
        'App\\Models',
        // Add additional namespaces here
    ],
    
    /*
    |--------------------------------------------------------------------------
    | Cache Settings
    |--------------------------------------------------------------------------
    |
    | Configure caching behavior for API responses.
    |
    */
    'cache' => [
        'enabled' => env('SHADOW_CACHE_ENABLED', true),
        'ttl' => env('SHADOW_CACHE_TTL', 3600), // seconds
    ],
    
    /*
    |--------------------------------------------------------------------------
    | Response Format
    |--------------------------------------------------------------------------
    |
    | Configure how API responses should be formatted.
    |
    */
    'response' => [
        'include_request_info' => env('SHADOW_INCLUDE_REQUEST_INFO', true),
        'format' => env('SHADOW_RESPONSE_FORMAT', 'json'),
    ],
];
```

## Environment Variables

Add these variables to your `.env` file:

```env
# API Configuration
SHADOW_API_PREFIX=shadow-api
SHADOW_DOCS_ENABLED=true
SHADOW_INCLUDE_REQUEST_INFO=true
SHADOW_RESPONSE_FORMAT=json

# Cache Configuration
SHADOW_CACHE_ENABLED=true
SHADOW_CACHE_TTL=3600

# Security
SHADOW_RATE_LIMIT=60
SHADOW_RATE_WINDOW=1
```

## Model Configuration

### Basic Model Setup

Add the `HasShadow` trait to your model:

```php
use Thinkneverland\Shadow\Traits\HasShadow;

class User extends Model
{
    use HasShadow;
    
    protected $fillable = ['name', 'email', 'password'];
}
```

### Advanced Model Configuration

You can customize how your model is exposed in the API:

```php
class User extends Model
{
    use HasShadow;
    
    public static function shadowConfig()
    {
        return [
            // Display column for the model
            'display_column' => 'name',
            
            // Validation rules
            'validation' => [
                'create' => [
                    'name' => 'required|string|max:255',
                    'email' => 'required|email|unique:users',
                ],
                'update' => [
                    'name' => 'sometimes|string|max:255',
                    'email' => 'sometimes|email|unique:users',
                ]
            ],
            
            // Relationship configuration
            'relationships' => [
                'include' => ['posts', 'comments'],
                'exclude' => ['password_resets']
            ],
            
            // Searchable fields
            'searchable' => ['name', 'email'],
            
            // Sortable fields
            'sortable' => ['created_at', 'name'],
            
            // Hidden fields
            'hidden' => ['password', 'remember_token'],
            
            // Custom transformations
            'transform' => [
                'created_at' => 'datetime',
                'updated_at' => 'datetime',
            ],
            
            // Custom scopes
            'scopes' => [
                'active' => true,
                'verified' => true,
            ],
        ];
    }
}
```

## Response Configuration

### Success Response Format

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

### Error Response Format

```json
{
    "success": false,
    "message": "Error message",
    "errors": {
        "field": ["Error details"]
    },
    "meta": {
        "timestamp": "2024-01-01T12:00:00Z",
        "request_id": "550e8400-e29b-41d4-a716-446655440000"
    }
}
```

## Cache Configuration

### Cache Drivers

Shadow supports all Laravel cache drivers:

```php
'cache' => [
    'driver' => env('SHADOW_CACHE_DRIVER', 'file'),
    'ttl' => env('SHADOW_CACHE_TTL', 3600),
    'prefix' => env('SHADOW_CACHE_PREFIX', 'shadow_'),
],
```

### Cache Tags

You can use cache tags for more granular cache control:

```php
'cache' => [
    'tags' => [
        'enabled' => true,
        'prefix' => 'shadow_',
    ],
],
```

## Security Configuration

### Rate Limiting

Configure rate limiting for your API:

```php
'rate_limit' => [
    'enabled' => env('SHADOW_RATE_LIMIT_ENABLED', true),
    'max_attempts' => env('SHADOW_RATE_LIMIT', 60),
    'decay_minutes' => env('SHADOW_RATE_WINDOW', 1),
],
```

### Authentication

Configure authentication settings:

```php
'auth' => [
    'guard' => env('SHADOW_AUTH_GUARD', 'api'),
    'middleware' => ['auth:api'],
],
```

## Next Steps

- Learn about [Advanced Features](advanced-features.md)
- Review [Best Practices](best-practices.md)
- Check out [Examples](examples.md)
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/shadow/) for more resources
