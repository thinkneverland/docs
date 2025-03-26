# Getting Started with Porter

This guide will help you get up and running with Porter in your Laravel application.

## Installation

1. Install the package via Composer:

```bash
composer require thinkneverland/porter
```

2. Run the installation command:

```bash
php artisan porter:install
```

This command will:

- Publish the configuration file
- Prompt for S3 credentials
- Set up necessary environment variables

## Basic Configuration

### Environment Variables

Add the following variables to your `.env` file:

```env
# Primary S3 Configuration
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_DEFAULT_REGION=your_region
AWS_BUCKET=your_bucket
AWS_URL=your_url
AWS_ENDPOINT=your_endpoint (optional)

# Source S3 Configuration (for cloning)
AWS_SOURCE_BUCKET=source_bucket
AWS_SOURCE_REGION=source_region
AWS_SOURCE_ACCESS_KEY_ID=source_access_key
AWS_SOURCE_SECRET_ACCESS_KEY=source_secret_key
AWS_SOURCE_URL=source_url
AWS_SOURCE_ENDPOINT=source_endpoint (optional)

# Alternative Export Configuration (optional)
EXPORT_ALT_AWS_ENABLED=false
EXPORT_ALT_AWS_BUCKET=alt_bucket
EXPORT_ALT_AWS_REGION=alt_region
EXPORT_ALT_AWS_ACCESS_KEY_ID=alt_access_key
EXPORT_ALT_AWS_SECRET_ACCESS_KEY=alt_secret_key
EXPORT_ALT_AWS_URL=alt_url
EXPORT_ALT_AWS_ENDPOINT=alt_endpoint
EXPORT_ALT_AWS_USE_PATH_STYLE_ENDPOINT=false
```

## Basic Usage

### Exporting Database

Export your database to an SQL file:

```bash
php artisan porter:export export.sql
```

Options:

- `--drop-if-exists`: Include DROP TABLE IF EXISTS statements
- `--keep-if-exists`: Keep IF EXISTS statements
- `--no-expiration`: Prevent automatic file deletion

### Importing Database

Import a database from an SQL file:

```bash
php artisan porter:import database.sql
```

The import command supports both local files and S3 paths:

```bash
php artisan porter:import s3://bucket-name/path/to/database.sql
```

### Cloning S3 Buckets

Clone contents between configured S3 buckets:

```bash
php artisan porter:clone-s3
```

## Model Configuration

Add the `PorterConfigurable` trait to your models to control data handling during export:

```php
use ThinkNeverland\Porter\Traits\PorterConfigurable;

class User extends Model
{
    use PorterConfigurable;

    // Fields to be randomized during export
    protected $omittedFromPorter = ['email', 'name'];
    
    // Specific row IDs to keep unchanged
    protected $keepForPorter = [1, 2, 3];
    
    // Set to true to exclude this model
    protected $ignoreFromPorter = true;
}
```

## Next Steps

- Review the [Configuration](configuration.md) guide for detailed settings
- Learn about available [Commands](commands.md)
- Explore [Model Configuration](model-configuration.md) options
- Check [S3 Integration](s3-integration.md) for advanced S3 features
- Follow [Best Practices](best-practices.md) for optimal usage
