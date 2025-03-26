# Available Commands

This guide covers all available commands in Porter, their options, and usage examples.

## Installation Command

### `porter:install`

Installs and configures Porter in your Laravel application.

```bash
php artisan porter:install
```

This command will:

- Publish the configuration file
- Prompt for S3 credentials
- Set up necessary environment variables

## Export Commands

### `porter:export`

Exports your database to an SQL file.

```bash
php artisan porter:export {file} [--drop-if-exists] [--keep-if-exists] [--no-expiration]
```

#### Arguments

- `file`: The name of the SQL file to create

#### Options

- `--drop-if-exists`: Include `DROP TABLE IF EXISTS` statements
- `--keep-if-exists`: Keep `IF EXISTS` for all tables
- `--no-expiration`: Prevent automatic file deletion

#### Examples

```bash
# Basic export
php artisan porter:export backup.sql

# Export with DROP TABLE statements
php artisan porter:export backup.sql --drop-if-exists

# Export without expiration
php artisan porter:export backup.sql --no-expiration
```

**Features:**

- Supports both local and S3 storage
- Handles data anonymization based on model configuration
- Generates presigned URLs for S3 downloads
- Manages file expiration
- Supports multipart uploads for large files

## Import Commands

### `porter:import`

Imports a database from an SQL file.

```bash
php artisan porter:import {file}
```

#### Arguments

- `file`: Path to the SQL file to import

#### Examples

```bash
# Import from local file
php artisan porter:import backup.sql

# Import from S3
php artisan porter:import s3://bucket-name/path/to/backup.sql
```

**Features:**

- Optimized streaming import
- Chunk processing for large files
- Support for both local and S3 files
- Automatic error handling
- Progress indicators

## S3 Commands

### `porter:clone-s3`

Clones content between configured S3 buckets.

```bash
php artisan porter:clone-s3
```

This command will:

- Copy files from source bucket to target bucket
- Maintain file structure and metadata
- Handle large files with multipart uploads

**Features:**

- Intelligent file existence caching
- Batch processing with configurable size
- Retry mechanism for failed transfers
- Progress tracking
- Detailed error reporting

**Process:**

1. Validates S3 configurations
2. Tests connections to both buckets
3. Lists files in source bucket
4. Checks for existing files in target
5. Transfers files in batches
6. Reports success/failure

## Testing Commands

### `porter:test`

Runs the Porter test suite to verify functionality.

```bash
php artisan porter:test
```

This command will:

- Test database export/import
- Test S3 operations
- Verify configurations

## Command Output Examples

### Database Export Output

```bash
$ php artisan porter:export backup.sql
Database exported successfully to: backup.sql
Download your SQL file here: http://localhost/download/backup.sql
```

### S3 Cloning Output

```bash
$ php artisan porter:clone-s3
Starting S3 bucket cloning...
Files copied: 150/150
Cloning completed successfully!
```

## Error Handling

Commands provide clear error messages for common issues:

- Invalid file paths
- Database connection errors
- S3 credential issues
- Permission problems

## Next Steps

- Review [Configuration](configuration.md) for command settings
- Learn about [S3 Integration](s3-integration.md) for S3 operations
- Check [Troubleshooting](troubleshooting.md) for common issues
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/porter/) for more resources
