# API Reference

This document provides detailed information about Shadow's API, including endpoints, parameters, and response formats.

## Endpoints

### Resource Endpoints

#### List Resources

```http
GET /shadow-api/model/{model}
```

**Parameters:**

- `search`: Search term for searchable fields
- `sort`: Field to sort by
- `order`: Sort order (asc/desc)
- `page`: Page number
- `per_page`: Items per page
- `include`: Related resources to include
- `fields`: Fields to return
- `filter`: Filter conditions

**Example:**

```http
GET /shadow-api/model/users?search=john&sort=name&order=desc&page=1&per_page=15&include=posts
```

#### Show Resource

```http
GET /shadow-api/model/{model}/{id}
```

**Parameters:**

- `include`: Related resources to include
- `fields`: Fields to return

**Example:**

```http
GET /shadow-api/model/users/1?include=posts,comments
```

#### Create Resource

```http
POST /shadow-api/model/{model}
```

**Parameters:**

- Request body: Resource data

**Example:**

```http
POST /shadow-api/model/users
Content-Type: application/json

{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "secret123"
}
```

#### Update Resource

```http
PUT /shadow-api/model/{model}/{id}
```

**Parameters:**

- Request body: Resource data

**Example:**

```http
PUT /shadow-api/model/users/1
Content-Type: application/json

{
    "name": "John Doe Updated",
    "email": "john.updated@example.com"
}
```

#### Delete Resource

```http
DELETE /shadow-api/model/{model}/{id}
```

### Utility Endpoints

#### List Available Models

```http
GET /shadow-api/models
```

#### Get API Documentation

```http
GET /shadow-api/help
```

#### Get Model Documentation

```http
GET /shadow-api/help/{model}
```

## Response Formats

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
    },
    "meta": {
        "timestamp": "2024-01-01T12:00:00Z",
        "request_id": "550e8400-e29b-41d4-a716-446655440000"
    }
}
```

### List Response

```json
{
    "success": true,
    "data": [
        {
            "id": 1,
            "name": "John Doe",
            "email": "john@example.com"
        },
        {
            "id": 2,
            "name": "Jane Doe",
            "email": "jane@example.com"
        }
    ],
    "meta": {
        "current_page": 1,
        "last_page": 5,
        "per_page": 15,
        "total": 72,
        "timestamp": "2024-01-01T12:00:00Z",
        "request_id": "550e8400-e29b-41d4-a716-446655440000"
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
        ],
        "password": [
            "The password must be at least 8 characters."
        ]
    },
    "meta": {
        "timestamp": "2024-01-01T12:00:00Z",
        "request_id": "550e8400-e29b-41d4-a716-446655440000"
    }
}
```

## Query Parameters

### Filtering

```http
GET /shadow-api/model/users?filter[status]=active&filter[role]=admin
```

### Sorting

```http
GET /shadow-api/model/users?sort=name&order=desc
```

### Pagination

```http
GET /shadow-api/model/users?page=1&per_page=15
```

### Including Relations

```http
GET /shadow-api/model/users?include=posts,comments
```

### Field Selection

```http
GET /shadow-api/model/users?fields=id,name,email
```

## Error Codes

| HTTP Status | Error Type | Description |
|-------------|------------|-------------|
| 400 | Bad Request | Invalid request parameters |
| 401 | Unauthorized | Authentication required |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource not found |
| 422 | Validation Error | Invalid data provided |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Server Error | Internal server error |

## Rate Limiting

By default, Shadow implements rate limiting:

- 60 requests per minute per IP
- Customizable via configuration

## Authentication

Shadow supports various authentication methods:

- API Tokens
- OAuth2
- Session-based authentication

## Next Steps

- Learn about [Advanced Features](advanced-features.md)
- Review [Best Practices](best-practices.md)
- Check out [Examples](examples.md)
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/shadow/) for more resources
