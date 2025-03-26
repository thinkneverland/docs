# Configuration Guide

This guide covers all configuration options available in the Porter package.

## Configuration File

The configuration file is located at `config/porter.php` and contains settings for S3 bucket access and export options.

### Basic Structure

```php
return [
    's3' => [
        // Target bucket configuration
        'target_bucket'     => env('AWS_BUCKET'),
        'target_region'     => env('AWS_DEFAULT_REGION'),
        'target_access_key' => env('AWS_ACCESS_KEY_ID'),
        'target_secret_key' => env('AWS_SECRET_ACCESS_KEY'),
        'target_url'        => env('AWS_URL'),
        'target_endpoint'   => env('AWS_ENDPOINT'),

        // Source bucket configuration
        'source_bucket'     => env('AWS_SOURCE_BUCKET'),
        'source_region'     => env('AWS_SOURCE_REGION'),
        'source_access_key' => env('AWS_SOURCE_ACCESS_KEY_ID'),
        'source_secret_key' => env('AWS_SOURCE_SECRET_ACCESS_KEY'),
        'source_url'        => env('AWS_SOURCE_URL'),
        'source_endpoint'   => env('AWS_SOURCE_ENDPOINT'),
    ],

    'export_alt' => [
        'enabled'                 => env('EXPORT_ALT_AWS_ENABLED', false),
        'bucket'                  => env('EXPORT_ALT_AWS_BUCKET'),
        'region'                  => env('EXPORT_ALT_AWS_REGION'),
        'access_key'              => env('EXPORT_ALT_AWS_ACCESS_KEY_ID'),
        'secret_key'              => env('EXPORT_ALT_AWS_SECRET_ACCESS_KEY'),
        'url'                     => env('EXPORT_ALT_AWS_URL'),
        'endpoint'                => env('EXPORT_ALT_AWS_ENDPOINT'),
        'use_path_style_endpoint' => env('EXPORT_ALT_AWS_USE_PATH_STYLE_ENDPOINT', false),
    ],

    'expiration' => env('EXPORT_AWS_EXPIRATION', 3600),
];
```

## S3 Configuration

### Primary S3 Configuration

The primary S3 configuration is used for standard export operations and as the target for cloning operations:

```php
's3' => [
    'target_bucket'     => env('AWS_BUCKET'),
    'target_region'     => env('AWS_DEFAULT_REGION'),
    'target_access_key' => env('AWS_ACCESS_KEY_ID'),
    'target_secret_key' => env('AWS_SECRET_ACCESS_KEY'),
    'target_url'        => env('AWS_URL'),
    'target_endpoint'   => env('AWS_ENDPOINT'),
]
```

### Source S3 Configuration

The source S3 configuration is used as the source bucket for cloning operations:

```php
's3' => [
    'source_bucket'     => env('AWS_SOURCE_BUCKET'),
    'source_region'     => env('AWS_SOURCE_REGION'),
    'source_access_key' => env('AWS_SOURCE_ACCESS_KEY_ID'),
    'source_secret_key' => env('AWS_SOURCE_SECRET_ACCESS_KEY'),
    'source_url'        => env('AWS_SOURCE_URL'),
    'source_endpoint'   => env('AWS_SOURCE_ENDPOINT'),
]
```

### Alternative Export Configuration

The alternative export configuration allows exporting to a different S3 bucket:

```php
'export_alt' => [
    'enabled'                 => env('EXPORT_ALT_AWS_ENABLED', false),
    'bucket'                  => env('EXPORT_ALT_AWS_BUCKET'),
    'region'                  => env('EXPORT_ALT_AWS_REGION'),
    'access_key'              => env('EXPORT_ALT_AWS_ACCESS_KEY_ID'),
    'secret_key'              => env('EXPORT_ALT_AWS_SECRET_ACCESS_KEY'),
    'url'                     => env('EXPORT_ALT_AWS_URL'),
    'endpoint'                => env('EXPORT_ALT_AWS_ENDPOINT'),
    'use_path_style_endpoint' => env('EXPORT_ALT_AWS_USE_PATH_STYLE_ENDPOINT', false),
]
```

## Export Settings

### File Expiration

Control how long exported files are retained:

```php
'expiration' => env('EXPORT_AWS_EXPIRATION', 3600), // Time in seconds
```

## IAM Policy Requirements

For S3 operations to work correctly, your IAM policies need the following permissions:

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

## Best Practices

1. **Environment Variables**
   - Always use environment variables for sensitive information
   - Keep different configurations for development and production
   - Use meaningful names for buckets and endpoints

2. **Security**
   - Use IAM roles with minimal required permissions
   - Regularly rotate access keys
   - Enable bucket encryption when possible

3. **Performance**
   - Set appropriate expiration times based on your needs
   - Configure endpoints for optimal geographic access
   - Use path style endpoints only when necessary

4. **Monitoring**
   - Keep track of export file sizes
   - Monitor S3 usage and costs
   - Set up alerts for failed operations
