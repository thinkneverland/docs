# Available Commands

Porter provides several Artisan commands for managing database exports, imports, and S3 operations.

## Installation Command

### porter:install

Installs and configures the Porter package.

```bash
php artisan porter:install
```

**What it does:**

- Publishes the configuration file
- Prompts for S3 credentials
- Sets up environment variables
- Configures storage settings

## Export Commands

### porter:export

Exports the database to an SQL file.

```bash
php artisan porter:export {filename} [--drop-if-exists] [--keep-if-exists] [--no-expiration]
```

**Arguments:**

- `filename`: The name of the export file

**Options:**

- `--drop-if-exists`: Includes DROP TABLE IF EXISTS statements
- `--keep-if-exists`: Keeps IF EXISTS statements
- `--no-expiration`: Prevents automatic file deletion

**Example:**

```bash
php artisan porter:export backup.sql --drop-if-exists
```

**Features:**

- Supports both local and S3 storage
- Handles data anonymization based on model configuration
- Generates presigned URLs for S3 downloads
- Manages file expiration
- Supports multipart uploads for large files

## Import Commands

### porter:import

Imports a database from an SQL file.

```bash
php artisan porter:import {file}
```

**Arguments:**

- `file`: Path to the SQL file (local or S3)

**Features:**

- Optimized streaming import
- Chunk processing for large files
- Support for both local and S3 files
- Automatic error handling
- Progress indicators

**Examples:**

```bash
# Import from local file
php artisan porter:import database.sql

# Import from S3
php artisan porter:import s3://bucket-name/database.sql
```

## S3 Commands

### porter:clone-s3

Clones contents between configured S3 buckets.

```bash
php artisan porter:clone-s3
```

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

## Common Options

Most commands support these common features:

- Progress bars for long operations
- Detailed error messages
- Confirmation prompts for destructive operations
- Verbose mode for debugging

## Error Handling

Commands handle various error scenarios:

- Connection failures
- Permission issues
- File access problems
- Storage limitations
- Timeout errors

Each error includes:

- Error code
- Detailed message
- Suggested resolution
- Debug information (in verbose mode)

## Best Practices

1. **Export Operations**
   - Use `--drop-if-exists` when replacing entire tables
   - Set appropriate expiration times
   - Monitor file sizes and storage usage

2. **Import Operations**
   - Backup existing data before imports
   - Test imports in development first
   - Monitor memory usage for large imports

3. **S3 Operations**
   - Verify bucket permissions
   - Use appropriate IAM policies
   - Monitor transfer costs

4. **General Usage**
   - Run in maintenance mode for large operations
   - Schedule operations during low-traffic periods
   - Monitor and log all operations
