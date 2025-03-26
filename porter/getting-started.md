# Getting Started with Porter

This guide will help you get started with Porter, from installation to performing your first database export and S3 bucket cloning operation.

## Installation

1. Install the package via Composer:

```bash
composer require thinkneverland/porter
```

2. Run the installation command:

```bash
php artisan porter:install
```

During installation, you'll be prompted to provide S3 credentials for both primary and alternative (secondary) S3 buckets. These will be stored in your `.env` file if not already set.

## Basic Usage

### Database Export

Export your database to an SQL file:

```bash
php artisan porter:export backup.sql
```

Available options:

- `--drop-if-exists`: Include `DROP TABLE IF EXISTS` statements
- `--keep-if-exists`: Keep `IF EXISTS` for all tables
- `--no-expiration`: Prevent automatic file deletion

Example with options:

```bash
php artisan porter:export backup.sql --drop-if-exists --no-expiration
```

### Database Import

Import a database from an SQL file:

```bash
php artisan porter:import backup.sql
```

You can import from:

- Local file: `php artisan porter:import /path/to/backup.sql`
- S3 bucket: `php artisan porter:import s3://bucket-name/path/to/backup.sql`

### S3 Bucket Cloning

Clone content between S3 buckets:

```bash
php artisan porter:clone-s3
```

This will clone files from the source bucket to the target bucket as defined in your configuration.

## Model Configuration

Configure how your models handle data during export/import operations:

```php
use ThinkNeverland\Porter\Traits\PorterConfigurable;

class User extends Model
{
    use PorterConfigurable;

    // Fields to randomize during export/import
    protected $omittedFromPorter = ['email', 'name'];
    
    // Specific row IDs to keep unchanged
    protected $keepForPorter = [1, 2, 3];
    
    // Exclude this model from operations
    protected $ignoreFromPorter = true;
}
```

Available configuration properties:

- `$omittedFromPorter`: Fields to randomize
- `$keepForPorter`: Row IDs to preserve
- `$ignoreFromPorter`: Exclude model from operations

## Configuration

The package uses a configuration file at `config/porter.php`. You can customize settings for:

- S3 bucket configurations
- Export expiration times
- File storage locations
- Data handling preferences

Example configuration:

```php
return [
    's3' => [
        'target_bucket' => env('AWS_BUCKET'),
        'source_bucket' => env('AWS_SOURCE_BUCKET'),
        // ... other S3 settings
    ],
    'export_alt' => [
        'enabled' => env('EXPORT_ALT_AWS_ENABLED', false),
        'bucket' => env('EXPORT_ALT_AWS_BUCKET'),
        // ... alternative S3 settings
    ],
    'expiration' => env('EXPORT_AWS_EXPIRATION', 3600),
];
```

## Next Steps

- Check out the [Configuration Guide](configuration.md) for detailed settings
- Learn about [S3 Integration](s3-integration.md) for bucket operations
- Explore [Model Configuration](model-configuration.md) for data handling
- Review [Best Practices](best-practices.md) for optimal usage
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/porter/) for more resources
