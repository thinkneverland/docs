# Best Practices

This guide outlines recommended practices for using Porter effectively and securely in your Laravel applications.

## Security

### Data Protection

1. **Sensitive Data Handling**
   - Always anonymize sensitive information
   - Use appropriate field types for data generation
   - Implement custom data generators for special cases
   - Review and update anonymization rules regularly

2. **Access Control**
   - Use IAM roles with minimal permissions
   - Rotate access keys regularly
   - Enable bucket encryption for S3 storage
   - Use VPC endpoints when possible

3. **Environment Management**
   - Keep separate configurations for different environments
   - Never commit sensitive credentials to version control
   - Use environment variables for all sensitive settings
   - Document required permissions and access patterns

## Performance

### Database Operations

1. **Export Optimization**
   - Use appropriate chunk sizes for large tables
   - Enable multipart uploads for large files
   - Implement caching for repeated operations
   - Schedule exports during off-peak hours

2. **Import Optimization**
   - Use streaming imports for large files
   - Disable foreign key checks when appropriate
   - Consider table locking strategies
   - Monitor memory usage during imports

3. **S3 Operations**
   - Choose geographically close regions
   - Use appropriate storage classes
   - Implement retry mechanisms
   - Monitor transfer speeds

### Resource Management

1. **Memory Usage**

   ```php
   // Configure chunk size based on available memory
   config(['porter.chunk_size' => min(
       5 * 1024 * 1024,  // 5MB
       intval(ini_get('memory_limit')) * 0.1  // 10% of PHP memory limit
   )]);
   ```

2. **Disk Space**

   ```php
   // Clean up old exports
   config(['porter.cleanup' => [
       'enabled' => true,
       'keep_days' => 7,
       'min_free_space' => 500 * 1024 * 1024  // 500MB
   ]]);
   ```

## Code Organization

### Model Configuration

1. **Trait Usage**

   ```php
   use ThinkNeverland\Porter\Traits\PorterConfigurable;

   class User extends Model
   {
       use PorterConfigurable;

       // Group related configurations together
       protected $omittedFromPorter = [
           // Personal information
           'name',
           'email',
           'phone',

           // Security
           'password',
           'api_token',

           // Financial
           'bank_account',
           'credit_card'
       ];
   }
   ```

2. **Custom Generators**

   ```php
   protected function generateFakeValue(string $type, $value, $faker): mixed
   {
       // Group cases logically
       switch ($type) {
           // User identifiers
           case 'email':
           case 'username':
               return $this->generateIdentifier($faker);

           // Security tokens
           case 'api_token':
           case 'remember_token':
               return $this->generateSecureToken($faker);

           default:
               return parent::generateFakeValue($type, $value, $faker);
       }
   }
   ```

## Error Handling

### Graceful Degradation

1. **Connection Issues**

   ```php
   try {
       // Attempt S3 operation
   } catch (S3Exception $e) {
       // Fall back to local storage
       Log::warning('S3 operation failed, using local storage', [
           'error' => $e->getMessage()
       ]);
   }
   ```

2. **Memory Management**

   ```php
   if (!$this->hasEnoughMemory()) {
       // Reduce chunk size
       $this->adjustChunkSize();
       // Or switch to streaming mode
       $this->useStreamingMode();
   }
   ```

## Monitoring

### Logging

1. **Operation Tracking**

   ```php
   Log::info('Starting database export', [
       'tables' => $tables,
       'options' => $options,
       'memory_usage' => memory_get_usage(true)
   ]);
   ```

2. **Performance Metrics**

   ```php
   $start = microtime(true);
   // Perform operation
   $duration = microtime(true) - $start;

   Log::info('Export completed', [
       'duration' => $duration,
       'file_size' => $fileSize,
       'rows_processed' => $rowCount
   ]);
   ```

## Testing

### Automated Tests

1. **Configuration Testing**

   ```php
   public function test_export_configuration()
   {
       $this->assertNotNull(config('porter.s3.target_bucket'));
       $this->assertTrue(config('porter.export_alt.enabled'));
   }
   ```

2. **Data Anonymization**

   ```php
   public function test_data_anonymization()
   {
       $user = User::factory()->create();
       $exported = $user->porterRandomizeRow($user->toArray());

       $this->assertNotEquals($user->email, $exported['email']);
       $this->assertNotEquals($user->name, $exported['name']);
   }
   ```

## Maintenance

### Regular Tasks

1. **Clean Up**
   - Remove expired exports
   - Archive old backups
   - Monitor storage usage
   - Update IAM policies

2. **Updates**
   - Keep dependencies updated
   - Review security patches
   - Test with new Laravel versions
   - Update documentation

3. **Monitoring**
   - Check error logs
   - Monitor performance metrics
   - Review access patterns
   - Audit security settings
