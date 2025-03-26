# Troubleshooting Guide

This guide helps you diagnose and resolve common issues when using Porter.

## Common Issues

### Installation Issues

1. **Package Not Found**

   ```
   Error: Package thinkneverland/porter not found
   ```

   **Solution:**
   - Verify your composer.json file
   - Check your package version constraints
   - Update your composer repositories
   - Run `composer update`

2. **Configuration Not Published**

   ```
   Error: Configuration file not found
   ```

   **Solution:**

   ```bash
   php artisan vendor:publish --tag=porter-config
   ```

### Export Issues

1. **Memory Limit Exceeded**

   ```
   Error: Allowed memory size exhausted
   ```

   **Solutions:**
   - Increase PHP memory limit in php.ini
   - Reduce chunk size in porter.php
   - Use streaming mode for large exports

   ```php
   // In php.ini
   memory_limit = 512M
   
   // Or in your application
   ini_set('memory_limit', '512M');
   ```

2. **Permission Denied**

   ```
   Error: Unable to write to export directory
   ```

   **Solutions:**
   - Check directory permissions
   - Verify user ownership
   - Set correct storage permissions

   ```bash
   chmod -R 775 storage/
   chown -R www-data:www-data storage/
   ```

### S3 Integration Issues

1. **Connection Failed**

   ```
   Error: Could not connect to S3
   ```

   **Solutions:**
   - Verify credentials
   - Check network connectivity
   - Validate endpoint URLs

   ```php
   // Test S3 connection
   try {
       Storage::disk('s3')->put('test.txt', 'test');
       Storage::disk('s3')->delete('test.txt');
       echo "S3 connection successful";
   } catch (Exception $e) {
       echo "S3 connection failed: " . $e->getMessage();
   }
   ```

2. **Access Denied**

   ```
   Error: Access denied for bucket operation
   ```

   **Solutions:**
   - Check IAM permissions
   - Verify bucket policies
   - Review CORS settings

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "s3:PutObject",
           "s3:GetObject",
           "s3:ListBucket"
         ],
         "Resource": [
           "arn:aws:s3:::your-bucket",
           "arn:aws:s3:::your-bucket/*"
         ]
       }
     ]
   }
   ```

### Import Issues

1. **SQL Syntax Error**

   ```
   Error: SQL syntax error in import file
   ```

   **Solutions:**
   - Check file encoding (use UTF-8)
   - Verify SQL compatibility
   - Remove problematic statements

   ```bash
   # Check file encoding
   file -i your_export.sql
   
   # Convert to UTF-8 if needed
   iconv -f ISO-8859-1 -t UTF-8 your_export.sql > your_export_utf8.sql
   ```

2. **Foreign Key Constraints**

   ```
   Error: Cannot add or update a child row
   ```

   **Solutions:**
   - Disable foreign key checks
   - Import in correct order
   - Fix data relationships

   ```sql
   SET FOREIGN_KEY_CHECKS=0;
   -- Import data
   SET FOREIGN_KEY_CHECKS=1;
   ```

## Debugging Tools

### Command Line Debugging

1. **Verbose Mode**

   ```bash
   php artisan porter:export export.sql -v
   ```

2. **Debug Output**

   ```bash
   php artisan porter:export export.sql --debug
   ```

### Log Analysis

1. **Laravel Logs**

   ```bash
   tail -f storage/logs/laravel.log
   ```

2. **Porter Specific Logs**

   ```php
   Log::channel('porter')->info('Export started', [
       'file' => $filename,
       'options' => $options
   ]);
   ```

## Performance Issues

### Slow Exports

1. **Large Tables**

   ```php
   // Optimize chunk size
   config(['porter.export.chunk_size' => 1000]);
   
   // Use batch processing
   config(['porter.export.use_batches' => true]);
   ```

2. **S3 Upload Speed**

   ```php
   // Configure multipart upload
   config([
       'porter.s3.multipart' => [
           'enabled' => true,
           'part_size' => 5 * 1024 * 1024 // 5MB
       ]
   ]);
   ```

### Memory Usage

1. **Memory Monitoring**

   ```php
   Log::info('Memory usage', [
       'current' => memory_get_usage(true),
       'peak' => memory_get_peak_usage(true)
   ]);
   ```

2. **Garbage Collection**

   ```php
   // Force garbage collection
   gc_collect_cycles();
   ```

## Recovery Procedures

### Failed Exports

1. **Cleanup Temporary Files**

   ```php
   // Clean up failed exports
   Storage::delete(Storage::files('exports/temp'));
   ```

2. **Resume Failed Operations**

   ```php
   // Enable auto-resume
   config(['porter.export.auto_resume' => true]);
   ```

### Data Corruption

1. **Backup Verification**

   ```php
   // Verify export integrity
   if (!Porter::verifyExport($filename)) {
       Log::error('Export verification failed');
   }
   ```

2. **Recovery from Backup**

   ```php
   // Restore from last good backup
   Porter::restoreFromBackup($lastGoodBackup);
   ```

## Support Resources

1. **Documentation**
   - [Porter Documentation](https://thinkneverland.com/docs/porter)
   - [Laravel Documentation](https://laravel.com/docs)
   - [AWS S3 Documentation](https://docs.aws.amazon.com/s3)

2. **Community**
   - [GitHub Issues](https://github.com/thinkneverland/porter/issues)
   - [Laravel Forums](https://laracasts.com/discuss)
   - [Stack Overflow](https://stackoverflow.com/questions/tagged/laravel-porter)
