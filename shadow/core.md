# Core Concepts

## Introduction

Shadow is built on several core concepts that work together to provide automatic API generation and management. Understanding these concepts is crucial for effectively using and extending the package.

## Architecture Overview

```
Shadow
├── Core Services
│   ├── ShadowService (Main orchestrator)
│   ├── ModelRegistry (Model management)
│   ├── CrudOperationsService (CRUD operations)
│   ├── ApiResponseService (Response formatting)
│   └── CacheService (Cache management)
├── HTTP Layer
│   ├── Controllers
│   ├── Middleware
│   └── Resources
└── Model Integration
    ├── HasShadow Trait
    ├── Model Discovery
    └── Configuration
```

## Core Services

### ShadowService

The central service that orchestrates all Shadow operations:

```php
use ThinkNeverland\Shadow\Services\ShadowService;

class UserController extends Controller
{
    protected $shadow;
    
    public function __construct(ShadowService $shadow)
    {
        $this->shadow = $shadow;
    }
    
    public function index()
    {
        return $this->shadow->handleIndex('users');
    }
}
```

Key responsibilities:

- Route handling
- Model operations
- Response formatting
- Cache management
- Error handling

### ModelRegistry

Manages the discovery and registration of Shadow-enabled models:

```php
use ThinkNeverland\Shadow\Services\Registry\ModelRegistry;

// Models are automatically discovered from configured namespaces
protected $modelNamespaces = [
    'App\\Models',
    'App\\Domain\\Models'
];

// Models can be included or excluded via configuration
'models' => [
    'include' => [
        'App\\Models\\User',
        'App\\Models\\Post'
    ],
    'exclude' => [
        'App\\Models\\PasswordReset'
    ]
]
```

### CrudOperationsService

Handles all CRUD operations with consistent behavior:

```php
use ThinkNeverland\Shadow\Services\CrudOperationsService;

// Create operation with foreign key resolution
$crud->create('users', [
    'name' => 'John Doe',
    'department' => 'Engineering' // Automatically resolves to department_id
]);

// Update operation with relationship handling
$crud->update('posts', 1, [
    'title' => 'Updated Title',
    'tags' => ['php', 'laravel'] // Automatically syncs relationships
]);
```

### ApiResponseService

Ensures consistent API response formatting:

```php
use ThinkNeverland\Shadow\Services\ApiResponseService;

// Success response
$response->success($data, 'Operation successful');

// Error response
$response->error('Invalid input', 422, $errors);

// Paginated response
$response->paginate($query, $perPage, $includes);
```

### CacheService

Manages caching strategies and invalidation:

```php
use ThinkNeverland\Shadow\Services\CacheService;

// Automatic caching of queries
$cache->remember($key, function () {
    return $this->executeQuery();
}, $ttl);

// Cache tags for efficient invalidation
$cache->tags(['users', 'api'])->remember(...);
```

## Model Integration

### HasShadow Trait

The core trait that enables Shadow functionality in models:

```php
use ThinkNeverland\Shadow\Traits\HasShadow;

class User extends Model
{
    use HasShadow;
    
    protected $shadowConfig = [
        'searchable' => ['name', 'email'],
        'filterable' => ['status', 'role'],
        'sortable' => ['created_at', 'name'],
        'includes' => ['profile', 'posts'],
        'cache' => true,
        'cache_ttl' => 3600
    ];
}
```

### Model Discovery

Shadow automatically discovers models based on:

1. Configured namespaces
2. Presence of HasShadow trait
3. Include/exclude configuration

```php
// config/shadow.php
return [
    'model_namespaces' => [
        'App\\Models',
        'App\\Domain\\Models'
    ],
    'models' => [
        'include' => [],
        'exclude' => []
    ]
];
```

### Configuration System

Shadow uses a layered configuration system:

1. **Package Configuration** (`config/shadow.php`)
   - Global settings
   - Default behaviors
   - Service configuration

2. **Model Configuration** (`$shadowConfig`)
   - Model-specific settings
   - Field configuration
   - Relationship handling

3. **Runtime Configuration**
   - Query parameters
   - Request options
   - Dynamic settings

## HTTP Layer

### Controllers

Shadow provides base controllers for common operations:

```php
use ThinkNeverland\Shadow\Http\Controllers\ApiController;

class CustomController extends ApiController
{
    public function customEndpoint()
    {
        return $this->shadow
            ->model(User::class)
            ->withCustomLogic()
            ->paginate();
    }
}
```

### Middleware

Built-in middleware for common API needs:

```php
// config/shadow.php
'middleware' => [
    'api',
    'auth:sanctum',
    ThinkNeverland\Shadow\Http\Middleware\HandleApiErrors::class,
    ThinkNeverland\Shadow\Http\Middleware\FormatResponse::class
]
```

### Resources

API resources for data transformation:

```php
use ThinkNeverland\Shadow\Http\Resources\ShadowResource;

class UserResource extends ShadowResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'created_at' => $this->created_at->toIso8601String()
        ];
    }
}
```

## Query Building

Shadow provides a fluent query builder interface:

```php
// Basic query
$users = $shadow->model(User::class)
    ->filter(['status' => 'active'])
    ->sort('-created_at')
    ->paginate();

// Advanced query
$posts = $shadow->model(Post::class)
    ->filter([
        'status' => 'published',
        'created_at' => ['gt' => '2024-01-01']
    ])
    ->include(['author', 'comments.user'])
    ->fields(['id', 'title', 'content'])
    ->sort(['title', '-created_at'])
    ->cache(3600)
    ->paginate(25);
```

## Event System

Shadow emits events for major operations:

```php
// Model events
ShadowModelCreated
ShadowModelUpdated
ShadowModelDeleted

// Cache events
ShadowCacheHit
ShadowCacheMiss
ShadowCacheInvalidated

// API events
ShadowApiRequest
ShadowApiResponse
ShadowApiError
```

## Extension Points

Shadow can be extended through various points:

1. **Custom Services**

   ```php
   Shadow::extend('custom', function ($shadow) {
       return new CustomService($shadow);
   });
   ```

2. **Custom Resources**

   ```php
   class CustomResource extends ShadowResource
   {
       // Custom transformation logic
   }
   ```

3. **Custom Query Builders**

   ```php
   class CustomQueryBuilder extends ShadowQueryBuilder
   {
       // Custom query building logic
   }
   ```

4. **Custom Cache Drivers**

   ```php
   class CustomCacheDriver implements CacheDriverInterface
   {
       // Custom caching logic
   }
   ```
