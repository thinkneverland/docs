# Getting Started with Shadow

This guide will help you get started with Shadow by walking you through installation and basic usage.

## Installation

1. Install Shadow via Composer:

```bash
composer require thinkneverland/shadow
```

2. Register the service provider in `config/app.php`:

```php
'providers' => [
    Thinkneverland\Shadow\ShadowServiceProvider::class,
],
```

3. Publish the configuration file:

```bash
php artisan vendor:publish --provider="Thinkneverland\Shadow\ShadowServiceProvider" --tag="config"
```

4. Register the Shadow routes in your `RouteServiceProvider.php`:

```php
use Thinkneverland\Shadow\Facades\Shadow;

public function boot(): void
{
    Shadow::routes();
}
```

## Basic Usage

### Automatic API Generation

Shadow automatically creates RESTful endpoints for your Eloquent models:

```
GET    /shadow-api/model/{model}           # List resources
GET    /shadow-api/model/{model}/{id}      # Show a specific resource
POST   /shadow-api/model/{model}           # Create a resource
PUT    /shadow-api/model/{model}/{id}      # Update a resource
DELETE /shadow-api/model/{model}/{id}      # Delete a resource
```

### Model Configuration

Add the `HasShadow` trait to your models to enable API generation:

```php
use Thinkneverland\Shadow\Traits\HasShadow;

class User extends Model
{
    use HasShadow;
    
    protected $fillable = ['name', 'email', 'password'];
}
```

### Custom Model Configuration

You can customize how your model is exposed in the API:

```php
class User extends Model
{
    use HasShadow;
    
    public static function shadowConfig()
    {
        return [
            'display_column' => 'name',
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
            'relationships' => [
                'include' => ['posts', 'comments'],
                'exclude' => ['password_resets']
            ],
            'searchable' => ['name', 'email'],
            'sortable' => ['created_at', 'name'],
        ];
    }
}
```

### Standardized Responses

All API responses follow a consistent format:

```json
{
    "success": true,
    "message": "Operation successful",
    "data": { ... }
}
```

For list operations:

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

### Error Handling

Shadow provides comprehensive error handling:

```json
{
    "success": false,
    "message": "Human-friendly error message"
}
```

For validation errors:

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

### Query Parameters

Shadow supports various query parameters for filtering and sorting:

```
GET /shadow-api/model/users?search=john&sort=name&order=desc&page=1&per_page=15
```

## Next Steps

- Learn about [Configuration Options](configuration.md)
- Explore [Advanced Features](advanced-features.md)
- Check out [Best Practices](best-practices.md)
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/shadow/) for more resources
