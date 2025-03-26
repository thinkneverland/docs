# 🌑 Shadow

Shadow is a powerful Laravel package that automatically generates RESTful APIs for your Eloquent models with consistent error handling and standardized responses.

## 🎯 Key Features

### API Generation

- **Automatic Endpoints**: Instant RESTful API creation for Eloquent models
- **Standardized Responses**: Consistent response format across all endpoints
- **Relationship Support**: Automatic handling of model relationships
- **Foreign Key Resolution**: Smart handling of related data

### Data Management

- **Flexible Validation**: Model-specific validation rules
- **Pagination**: Built-in support for paginated responses
- **Query Parameters**: Filtering, sorting, and searching capabilities
- **Data Transformation**: Automatic data formatting and transformation

### Error Handling

- **Comprehensive Errors**: Detailed error handling with friendly messages
- **Server Logging**: Extensive error details logged server-side
- **Security Focus**: Technical details hidden from API responses
- **Standardized Format**: Consistent error response structure

## 🔧 System Requirements

- PHP 8.1 or higher
- Laravel 10.0 or higher
- MySQL 5.7+ / PostgreSQL 9.6+ / SQLite 3.8+

## 🚀 Quick Start

1. Install via Composer:

```bash
composer require thinkneverland/shadow
```

2. Register the service provider in `config/app.php`:

```php
'providers' => [
    Thinkneverland\Shadow\ShadowServiceProvider::class,
],
```

3. Publish the configuration:

```bash
php artisan vendor:publish --provider="Thinkneverland\Shadow\ShadowServiceProvider" --tag="config"
```

4. Register routes in `RouteServiceProvider.php`:

```php
use Thinkneverland\Shadow\Facades\Shadow;

public function boot(): void
{
    Shadow::routes();
}
```

## 📚 Documentation

For detailed documentation, please visit our [GitBook documentation](https://thinkneverland.gitbook.io/shadow/).

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guide](contributing.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

Shadow is open-source software licensed under the MIT license. See the [LICENSE](LICENSE.md) file for more details.
