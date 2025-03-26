# Configuration Guide

This guide covers all configuration options available in Porter, from basic settings to advanced S3 configurations.

## Basic Configuration

The Porter package uses a configuration file located at `config/porter.php` after running the install command.

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

# Export Settings
EXPORT_AWS_EXPIRATION=3600  # Expiration time in seconds
```

## Configuration File

The main configuration file (`config/porter.php`) contains all settings for Porter:

```php
return [
    's3' => [
        // Target bucket (used only for cloning operations)
        'target_bucket'     => env('AWS_BUCKET'),
        'target_region'     => env('AWS_DEFAULT_REGION'),
        'target_access_key' => env('AWS_ACCESS_KEY_ID'),
        'target_secret_key' => env('AWS_SECRET_ACCESS_KEY'),
        'target_url'        => env('AWS_URL'),
        'target_endpoint'   => env('AWS_ENDPOINT', null),  // Endpoint for target (optional)

        // Source bucket (used only for cloning operations)
        'source_bucket'     => env('AWS_SOURCE_BUCKET'),
        'source_region'     => env('AWS_SOURCE_REGION'),
        'source_access_key' => env('AWS_SOURCE_ACCESS_KEY_ID'),
        'source_secret_key' => env('AWS_SOURCE_SECRET_ACCESS_KEY'),
        'source_url'        => env('AWS_SOURCE_URL'),
        'source_endpoint'   => env('AWS_SOURCE_ENDPOINT', null),  // Endpoint for source (optional)
    ],

    // Alternate S3 Export Configuration
    'export_alt' => [
        'enabled'                 => env('EXPORT_ALT_AWS_ENABLED', false),
        'bucket'                  => env('EXPORT_ALT_AWS_BUCKET', null),
        'region'                  => env('EXPORT_ALT_AWS_REGION', null),
        'access_key'              => env('EXPORT_ALT_AWS_ACCESS_KEY_ID', null),
        'secret_key'              => env('EXPORT_ALT_AWS_SECRET_ACCESS_KEY', null),
        'url'                     => env('EXPORT_ALT_AWS_URL', null),
        'endpoint'                => env('EXPORT_ALT_AWS_ENDPOINT', null), // Optional for custom S3 services like MinIO
        'use_path_style_endpoint' => env('EXPORT_ALT_AWS_USE_PATH_STYLE_ENDPOINT', false),
    ],

    'expiration' => env('EXPORT_AWS_EXPIRATION', 3600),  // Expiration time in seconds
];
```

## S3 Configuration Details

### Primary S3 Configuration

- `target_bucket`: The main S3 bucket for operations
- `target_region`: AWS region for the target bucket
- `target_access_key`: AWS access key for target bucket
- `target_secret_key`: AWS secret key for target bucket
- `target_url`: Custom URL for S3-compatible services
- `target_endpoint`: Custom endpoint for S3-compatible services

### Source S3 Configuration

- `source_bucket`: Source bucket for cloning operations
- `source_region`: AWS region for the source bucket
- `source_access_key`: AWS access key for source bucket
- `source_secret_key`: AWS secret key for source bucket
- `source_url`: Custom URL for source S3-compatible service
- `source_endpoint`: Custom endpoint for source S3-compatible service

### Alternative Export Configuration

- `enabled`: Enable alternative S3 export
- `bucket`: Alternative bucket for exports
- `region`: AWS region for alternative bucket
- `access_key`: AWS access key for alternative bucket
- `secret_key`: AWS secret key for alternative bucket
- `url`: Custom URL for alternative S3-compatible service
- `endpoint`: Custom endpoint for alternative S3-compatible service
- `use_path_style_endpoint`: Use path-style endpoints for custom S3 services

## IAM Policy Requirements

For S3 operations, ensure your IAM policies include the following permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "arn:aws:s3:::your-primary-bucket-name/*",
        "arn:aws:s3:::your-alternative-bucket-name/*"
      ]
    }
  ]
}
```

Replace `your-primary-bucket-name` and `your-alternative-bucket-name` with your actual bucket names.

## Model Configuration

Models can be configured using the `PorterConfigurable` trait:

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

## Next Steps

- Learn about [S3 Integration](s3-integration.md) for advanced S3 features
- Explore [Model Configuration](model-configuration.md) for data handling
- Review [Best Practices](best-practices.md) for optimal usage
- Check [Troubleshooting](troubleshooting.md) for common issues
