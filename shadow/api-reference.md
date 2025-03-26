# Shadow API Reference

This document provides detailed information about Shadow's API, including endpoints, configuration options, and core services.

## Core Services

### ShadowService

The main service that manages API operations and model interactions.

```php
use ThinkNeverland\Shadow\Services\ShadowService;

class UserController extends Controller
{
    protected $shadow;
    
    public function __construct(ShadowService $shadow)
    {
        $this->shadow = $shadow;
    }
}
```

### ModelRegistry

Manages the registration and configuration of Shadow-enabled models.

```php
use ThinkNeverland\Shadow\Services\Registry\ModelRegistry;

// Models are automatically discovered and registered
$models = app(ModelRegistry::class)->getModels();
```

## API Endpoints

### Resource Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/shadow-api/model/{model}` | List resources |
| GET | `/shadow-api/model/{model}/{id}` | Show a specific resource |
| POST | `/shadow-api/model/{model}` | Create a resource |
| PUT | `/shadow-api/model/{model}/{id}` | Update a resource |
| DELETE | `/shadow-api/model/{model}/{id}` | Delete a resource |

### Utility Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/shadow-api/models` | List all available models |
| GET | `/shadow-api/help` | API documentation and help |
| GET | `/shadow-api/help/{model}` | Help for a specific model |
| GET | `/shadow-api/help/resources/{model}/schema` | View schema for a model |
| GET | `/shadow-api/help/resources/{model}/actions` | View available actions |
| GET | `/shadow-api/help/resources/{model}/validation` | View validation rules |
| GET | `/shadow-api/help/resources/{model}/examples` | View examples |

### Documentation Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/shadow-api/docs` | Swagger UI documentation |
| GET | `/shadow-api/docs/swagger.json` | OpenAPI/Swagger JSON |
| GET | `/shadow-api/docs/postman` | Postman collection |

## Query Parameters

### Filtering

```http
GET /shadow-api/users?filter[status]=active
GET /shadow-api/users?filter[role]=admin&filter[active]=true
GET /shadow-api/users?filter[created_at][gt]=2024-01-01
```

Supported operators:

- `eq` (equals, default)
- `gt` (greater than)
- `gte` (greater than or equal)
- `lt` (less than)
- `lte` (less than or equal)
- `like` (SQL LIKE)
- `in` (IN array)
- `null` (IS NULL)
- `not_null` (IS NOT NULL)

### Sorting

```http
GET /shadow-api/users?sort=name
GET /shadow-api/users?sort=-created_at
GET /shadow-api/users?sort=role,-created_at
```

### Pagination

```http
GET /shadow-api/users?page=2
GET /shadow-api/users?per_page=50
```

### Including Relations

```http
GET /shadow-api/users?include=posts
GET /shadow-api/users?include=posts.comments,profile
```

### Field Selection

```http
GET /shadow-api/users?fields=id,name,email
GET /shadow-api/users?fields=id,name&include=posts:id,title
```

## Configuration

### Package Configuration

```php
// config/shadow.php
return [
    // Base path for API routes
    'route_prefix' => 'shadow-api',

    // List of models to expose in the API
    'models' => [
        'include' => [],
        'exclude' => [],
    ],
    
    // Middleware to apply to all API routes
    'middleware' => ['api'],
    
    // Enable/disable API documentation
    'enable_documentation' => true,
    
    // Configure model namespace paths
    'model_namespaces' => [
        'App\\Models',
    ],
    
    // Cache settings
    'cache' => [
        'enabled' => true,
        'ttl' => 3600,
    ],
    
    // Response formatting
    'response' => [
        'include_request_info' => true,
    ],
];
```

### Model Configuration

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

## Response Format

### Success Response

```json
{
    "success": true,
    "message": "Operation successful",
    "data": { ... },
    "request_info": {
        "timestamp": "2024-01-01T12:34:56+00:00",
        "ip": "192.168.1.1",
        "method": "GET",
        "url": "https://example.com/shadow-api/users/1",
        "user_agent": "Mozilla/5.0...",
        "user": {
            "id": 1,
            "name": "John Doe"
        },
        "request_id": "550e8400-e29b-41d4-a716-446655440000"
    }
}
```

### List Response

```json
{
    "success": true,
    "data": [ ... ],
    "meta": {
        "current_page": 1,
        "last_page": 5,
        "per_page": 15,
        "total": 72
    }
}
```

### Error Response

```json
{
    "success": false,
    "message": "The provided data is invalid.",
    "errors": {
        "field_name": [
            "Error message for field"
        ]
    }
}
```

## Error Handling

### HTTP Status Codes

| Status | Error Type | User Message |
|--------|------------|--------------|
| 400 | Invalid Request | "The request could not be processed." |
| 401 | Unauthorized | "You must be logged in to perform this action." |
| 403 | Forbidden | "You do not have permission to perform this action." |
| 404 | Not Found | "The requested record could not be found." |
| 409 | Conflict | "This record already exists. Please check for duplicates." |
| 422 | Validation | "The provided data is invalid." |
| 500 | Server Error | "An unexpected error occurred. Please try again later." |

## Cache Management

### Cache Commands

```bash
# Clear all Shadow cache
php artisan shadow:cache:clear --all

# Clear specific components
php artisan shadow:cache:clear --models
php artisan shadow:cache:clear --schema
php artisan shadow:cache:clear --docs

# Warm up cache
php artisan shadow:cache:warmup --all
php artisan shadow:cache:warmup --models

# View cache metrics
php artisan shadow:cache:metrics
php artisan shadow:cache:metrics --tag=shadow-models --detailed
```

## Documentation Generation

### Command Line

```bash
# Generate Swagger documentation
php artisan shadow:generate-docs --format=swagger

# Generate Postman collection
php artisan shadow:generate-docs --format=postman

# Specify output location
php artisan shadow:generate-docs --format=swagger --output=public/swagger/api-docs.json
```
