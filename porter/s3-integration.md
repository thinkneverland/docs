# S3 Integration Guide

Porter provides comprehensive support for Amazon S3 and S3-compatible storage services. This guide covers all aspects of S3 integration.

## Configuration

### Primary S3 Setup

Configure your primary S3 bucket in `.env`:

```env
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_DEFAULT_REGION=your_region
AWS_BUCKET=your_bucket
AWS_URL=your_url
AWS_ENDPOINT=your_endpoint (optional)
```

### Source Bucket for Cloning

Configure a source bucket for cloning operations:

```env
AWS_SOURCE_BUCKET=source_bucket
AWS_SOURCE_REGION=source_region
AWS_SOURCE_ACCESS_KEY_ID=source_access_key
AWS_SOURCE_SECRET_ACCESS_KEY=source_secret_key
AWS_SOURCE_URL=source_url
AWS_SOURCE_ENDPOINT=source_endpoint (optional)
```

### Alternative Export Configuration

Set up an alternative S3 bucket for exports:

```env
EXPORT_ALT_AWS_ENABLED=true
EXPORT_ALT_AWS_BUCKET=alt_bucket
EXPORT_ALT_AWS_REGION=alt_region
EXPORT_ALT_AWS_ACCESS_KEY_ID=alt_access_key
EXPORT_ALT_AWS_SECRET_ACCESS_KEY=alt_secret_key
EXPORT_ALT_AWS_URL=alt_url
EXPORT_ALT_AWS_ENDPOINT=alt_endpoint
EXPORT_ALT_AWS_USE_PATH_STYLE_ENDPOINT=false
```

## Features

### Multipart Uploads

Porter supports multipart uploads for large files:

- Automatic chunking of large files
- Configurable chunk size
- Retry mechanism for failed chunks
- Progress tracking
- Automatic cleanup of incomplete uploads

### Presigned URLs

Generate secure, time-limited download URLs:

```php
// URL expires in 1 hour by default
$url = Porter::generatePresignedUrl($bucket, $key);

// Custom expiration time
$url = Porter::generatePresignedUrl($bucket, $key, 7200); // 2 hours
```

### Intelligent Caching

Porter implements smart caching for S3 operations:

- File existence checks are cached
- Metadata caching
- Configurable cache duration
- Automatic cache invalidation

## Operations

### Exporting to S3

Export database to S3:

```bash
php artisan porter:export s3://bucket/path/export.sql
```

Options:

- `--drop-if-exists`: Include DROP TABLE statements
- `--keep-if-exists`: Keep IF EXISTS statements
- `--no-expiration`: Prevent automatic deletion

### Importing from S3

Import database from S3:

```bash
php artisan porter:import s3://bucket/path/import.sql
```

### Cloning Buckets

Clone between S3 buckets:

```bash
php artisan porter:clone-s3
```

Features:

- Selective file copying
- Progress tracking
- Error handling
- Retry mechanism

## IAM Configuration

### Required Permissions

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
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name",
        "arn:aws:s3:::your-bucket-name/*"
      ]
    }
  ]
}
```

## Performance Optimization

### Chunk Size Configuration

Optimize chunk size based on your needs:

```php
// In your service provider or bootstrap code
config(['porter.chunk_size' => 5 * 1024 * 1024]); // 5MB chunks
```

### Concurrent Operations

Porter supports concurrent operations:

- Parallel chunk uploads
- Batch processing for cloning
- Configurable concurrency limits

### Caching Strategy

Implement efficient caching:

```php
// In your service provider
config([
    'porter.cache.enabled' => true,
    'porter.cache.ttl' => 3600, // 1 hour
    'porter.cache.store' => 'redis'
]);
```

## Error Handling

### Common Issues

1. **Connection Timeouts**
   - Increase timeout settings
   - Use closer region endpoints
   - Check network connectivity

2. **Permission Errors**
   - Verify IAM policies
   - Check bucket permissions
   - Validate access keys

3. **Storage Limits**
   - Monitor bucket usage
   - Clean up old exports
   - Set up alerts

### Retry Strategy

Porter implements smart retry handling:

- Exponential backoff
- Configurable retry attempts
- Selective retry for specific errors

## Best Practices

1. **Security**
   - Use IAM roles when possible
   - Rotate access keys regularly
   - Enable bucket encryption
   - Use VPC endpoints

2. **Performance**
   - Choose appropriate regions
   - Optimize chunk sizes
   - Use caching effectively
   - Monitor transfer speeds

3. **Cost Management**
   - Clean up old exports
   - Monitor data transfer
   - Use lifecycle policies
   - Track storage usage

4. **Monitoring**
   - Set up CloudWatch alerts
   - Monitor error rates
   - Track transfer speeds
   - Log all operations
