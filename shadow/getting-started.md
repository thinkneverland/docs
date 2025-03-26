# Getting Started with Shadow API

## Introduction

Welcome to Shadow API! This guide will help you get up and running quickly with automatic API generation for your Laravel applications.

## Prerequisites

Before you begin, ensure you have:

- PHP 8.1 or higher
- Laravel 9.0 or higher
- Composer
- Database (MySQL, PostgreSQL, or SQLite)

## Installation

1. Install the package via Composer:

```bash
composer require thinkneverland/shadow
```

2. Register the service provider in your `config/app.php`:

```php
'providers' => [
    // ...
    Thinkneverland\Shadow\ShadowServiceProvider::class,
],
```

3. Publish the configuration:

```bash
php artisan vendor:publish --provider="Thinkneverland\Shadow\ShadowServiceProvider"
```

4. Configure your environment:

```env
SHADOW_API_PREFIX=shadow-api
SHADOW_DEBUG=false
SHADOW_CACHE_ENABLED=true
SHADOW_CACHE_TTL=3600
SHADOW_DOCS_AUTH_ENABLED=true
```

## Quick Start

### 1. Prepare Your Model

Add the `HasShadow` trait to your model and configure its behavior:

```php
use ThinkNeverland\Shadow\Traits\HasShadow;

class User extends Model
{
    use HasShadow;
    
    protected $shadowConfig = [
        'searchable' => ['name', 'email'],
        'filterable' => ['status', 'role'],
        'sortable' => ['created_at', 'updated_at']
    ];
}
```

### 2. Register Routes

Add Shadow routes to your API configuration:

```php
// routes/api.php
use ThinkNeverland\Shadow\Facades\Shadow;

Shadow::routes();
```

### 3. Access Your API

Your API is now available with the following endpoints:

```
GET    /shadow-api/model/{model}           # List resources
GET    /shadow-api/model/{model}/{id}      # Show a specific resource
POST   /shadow-api/model/{model}           # Create a resource
PUT    /shadow-api/model/{model}/{id}      # Update a resource
DELETE /shadow-api/model/{model}/{id}      # Delete a resource
```

Additional utility endpoints:

```
GET    /shadow-api/models                  # List all available models
GET    /shadow-api/help                    # API documentation and help
GET    /shadow-api/help/{model}            # Help for a specific model
```

## Basic Usage

### Querying Resources

```http
# List all users with filters
GET /shadow-api/users?filter[status]=active&sort=-created_at

# Get specific user
GET /shadow-api/users/1

# Create user
POST /shadow-api/users

# Update user
PUT /shadow-api/users/1

# Delete user
DELETE /shadow-api/users/1
```

### Working with Relations

```http
# Include related resources
GET /shadow-api/users?include=posts,comments

# Filter by relation
GET /shadow-api/users?filter[posts.status]=published

# Select specific fields
GET /shadow-api/users?fields=id,name,email
```

## Response Format

### Success Response

```json
{
    "success": true,
    "message": "Operation successful",
    "data": {
        "id": 1,
        "name": "John Doe",
        "email": "john@example.com",
        "created_at": "2024-01-01T12:00:00Z",
        "updated_at": "2024-01-01T12:00:00Z"
    }
}
```

### List Response with Pagination

```json
{
    "success": true,
    "data": [...],
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
        "email": [
            "The email field is required."
        ]
    }
}
```

## Documentation

### Generating API Documentation

```bash
# Generate Swagger documentation
php artisan shadow:generate-docs --format=swagger

# Generate Postman collection
php artisan shadow:generate-docs --format=postman
```

Access your API documentation:

- Swagger UI: `/shadow-api/docs`
- OpenAPI JSON: `/shadow-api/docs/swagger.json`
- Postman Collection: `/shadow-api/docs/postman`

## Troubleshooting

### Common Issues

1. **404 Errors**: Ensure your routes are properly registered
2. **Authorization Errors**: Check your middleware configuration
3. **Validation Errors**: Verify your model's validation rules

### Debugging

Enable debug mode in your `.env` file:

```env
SHADOW_DEBUG=true
```

Check Laravel logs for detailed error information:

```
storage/logs/laravel.log
```

## Next Steps

- Explore the [API Reference](api-reference.md) for detailed endpoint documentation
- Learn about [Core Concepts](core.md) for a deeper understanding
- Check out [Advanced Usage](advanced-usage.md) for more features
- Review [Security Best Practices](security.md) for secure implementation

## Getting Help

Need assistance? Here's how to get help:

- 📘 Read the full documentation
- 🐛 Report issues on GitHub
- 📧 Contact support at <support@thinkneverland.com>
- 💬 Join our community forum
