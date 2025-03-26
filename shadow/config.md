# Configuration Guide

## Overview

Shadow provides extensive configuration options to customize its behavior. This guide covers all available configuration options and best practices for setting them up.

## Basic Configuration

After installing Shadow, publish the configuration file:

```bash
php artisan vendor:publish --provider="ThinkNeverland\\Shadow\\ShadowServiceProvider"
```

This will create `config/shadow.php` with default settings.

## Environment Variables

Recommended `.env` configuration:

```env
# Core Settings
SHADOW_DEBUG=false
SHADOW_API_PREFIX=shadow-api
SHADOW_DOCS_AUTH_ENABLED=true

# Cache Settings
SHADOW_CACHE_ENABLED=true
SHADOW_CACHE_TTL=3600
SHADOW_CACHE_PREFIX=shadow

# Security Settings
SHADOW_AUTH_ENABLED=true
SHADOW_RATE_LIMITING_ENABLED=true
```

## Package Configuration

### Core Settings

```php
// config/shadow.php
return [
    // Base path for API routes
    'route_prefix' => env('SHADOW_API_PREFIX', 'shadow-api'),

    // List of models to expose in the API
    'models' => [
        // Specify models to include
        'include' => [
            'App\\Models\\User',
            'App\\Models\\Post'
        ],
        
        // Specify models to exclude
        'exclude' => [
            'App\\Models\\PasswordReset'
        ],
    ],
    
    // Middleware to apply to all API routes
    'middleware' => ['api'],
    
    // Enable/disable API documentation
    'enable_documentation' => env('SHADOW_DOCS_AUTH_ENABLED', true),
    
    // Configure model namespace paths
    'model_namespaces' => [
        'App\\Models',
        // Add additional namespaces here
    ],
];
```

### Cache Configuration

```php
'cache' => [
    // Enable/disable caching
    'enabled' => env('SHADOW_CACHE_ENABLED', true),
    
    // Cache TTL in seconds
    'ttl' => env('SHADOW_CACHE_TTL', 3600),
    
    // Cache prefix for keys
    'prefix' => env('SHADOW_CACHE_PREFIX', 'shadow'),
    
    // Cache tags configuration
    'tags' => [
        'enabled' => true,
        'prefix' => 'shadow',
    ],
    
    // Cache drivers
    'driver' => env('SHADOW_CACHE_DRIVER', 'redis'),
    
    // Cache invalidation strategy
    'invalidation' => [
        'strategy' => 'tags', // Options: tags, key-pattern
        'events' => ['created', 'updated', 'deleted'],
    ],
],
```

### Response Configuration

```php
'response' => [
    // Response format (json, xml)
    'format' => 'json',
    
    // Response keys
    'success_key' => 'success',
    'message_key' => 'message',
    'data_key' => 'data',
    'meta_key' => 'meta',
    'error_key' => 'errors',
    'error_code_key' => 'error_code',
    
    // Include request information in response
    'include_request_info' => env('SHADOW_INCLUDE_REQUEST_INFO', true),
    
    // Pagination settings
    'pagination' => [
        'per_page' => 15,
        'max_per_page' => 100,
    ],
],
```

### Security Configuration

```php
'security' => [
    // Authentication
    'auth_enabled' => env('SHADOW_AUTH_ENABLED', true),
    'auth_middleware' => ['auth:sanctum'],
    
    // Rate Limiting
    'rate_limiting' => [
        'enabled' => env('SHADOW_RATE_LIMITING_ENABLED', true),
        'max_attempts' => 60,
        'decay_minutes' => 1,
    ],
    
    // CORS Configuration
    'cors' => [
        'allowed_origins' => ['*'],
        'allowed_methods' => ['*'],
        'allowed_headers' => ['*'],
        'exposed_headers' => [],
        'max_age' => 0,
        'supports_credentials' => false,
    ],
    
    // API Key Configuration
    'api_key' => [
        'enabled' => false,
        'header_name' => 'X-API-Key',
        'query_param' => 'api_key',
    ],
],
```

### Documentation Configuration

```php
'documentation' => [
    // Enable/disable documentation generation
    'enabled' => env('SHADOW_ENABLE_DOCS', true),
    
    // Documentation formats
    'formats' => [
        'swagger' => true,
        'postman' => true,
        'markdown' => true,
    ],
    
    // Output paths
    'paths' => [
        'swagger' => 'public/api-docs/swagger.json',
        'postman' => 'public/api-docs/postman.json',
        'markdown' => 'resources/docs/api',
    ],
    
    // Documentation UI settings
    'ui' => [
        'enabled' => true,
        'theme' => 'default',
        'path' => 'api/docs',
    ],
],
```

### Debug Configuration

```php
'debug' => [
    // Enable/disable debug mode
    'enabled' => env('SHADOW_DEBUG', false),
    
    // Debug log settings
    'log' => [
        'channel' => 'shadow',
        'level' => 'debug',
    ],
    
    // Query logging
    'query_log' => [
        'enabled' => false,
        'slow_query_threshold' => 1000, // milliseconds
    ],
    
    // Request/Response logging
    'request_log' => [
        'enabled' => true,
        'exclude_paths' => [
            'api/docs/*',
            'api/health',
        ],
    ],
],
```

## Model Configuration

### Basic Model Settings

```php
use ThinkNeverland\Shadow\Traits\HasShadow;

class User extends Model
{
    use HasShadow;

    protected $shadowConfig = [
        // Searchable fields
        'searchable' => ['name', 'email'],
        
        // Filterable fields
        'filterable' => ['status', 'role'],
        
        // Sortable fields
        'sortable' => ['created_at', 'name'],
        
        // Included relationships
        'includes' => ['profile', 'posts'],
        
        // Cache configuration
        'cache' => [
            'enabled' => true,
            'ttl' => 3600,
        ],
        
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
        
        // Documentation
        'documentation' => [
            'description' => 'User management',
            'examples' => [
                'create' => [
                    'name' => 'John Doe',
                    'email' => 'john@example.com',
                ],
            ],
        ],
    ];
}
```

### Advanced Model Settings

```php
protected $shadowConfig = [
    // Field configuration
    'fields' => [
        'name' => [
            'type' => 'string',
            'searchable' => true,
            'filterable' => true,
            'sortable' => true,
            'validation' => 'required|string|max:255',
        ],
        'email' => [
            'type' => 'email',
            'unique' => true,
            'validation' => 'required|email|unique:users',
        ],
    ],
    
    // Relationship configuration
    'relationships' => [
        'posts' => [
            'type' => 'hasMany',
            'searchable' => true,
            'filterable' => true,
            'includes' => ['comments', 'tags'],
        ],
    ],
    
    // Authorization configuration
    'authorization' => [
        'create' => 'create-users',
        'read' => 'view-users',
        'update' => 'edit-users',
        'delete' => 'delete-users',
    ],
    
    // Events configuration
    'events' => [
        'created' => true,
        'updated' => true,
        'deleted' => true,
    ],
];
```

## Best Practices

1. **Environment Variables**
   - Use environment variables for sensitive or environment-specific settings
   - Document all environment variables in your `.env.example`

2. **Cache Configuration**
   - Enable caching in production
   - Use appropriate TTL values based on data volatility
   - Implement proper cache invalidation strategies

3. **Security Settings**
   - Always enable authentication in production
   - Configure CORS settings appropriately
   - Implement rate limiting for public APIs

4. **Model Configuration**
   - Keep model configurations focused and minimal
   - Use field-level configuration for complex requirements
   - Document model configurations thoroughly

5. **Documentation**
   - Enable documentation in development
   - Keep examples up to date
   - Include authentication details in documentation
