# Model Configuration

Porter provides powerful model-level control over data handling during export operations through the `PorterConfigurable` trait.

## Basic Setup

Add the `PorterConfigurable` trait to your model:

```php
use ThinkNeverland\Porter\Traits\PorterConfigurable;

class User extends Model
{
    use PorterConfigurable;
}
```

## Configuration Options

### Data Anonymization

Control which fields should be randomized during export:

```php
class User extends Model
{
    use PorterConfigurable;

    protected $omittedFromPorter = [
        'email',
        'name',
        'phone',
        'address',
        'password'
    ];
}
```

### Row Preservation

Specify which rows should remain unchanged during export:

```php
class User extends Model
{
    use PorterConfigurable;

    protected $keepForPorter = [
        1,  // Admin user
        2,  // System user
        3   // Test user
    ];
}
```

### Model Exclusion

Exclude entire models from export operations:

```php
class TemporaryData extends Model
{
    use PorterConfigurable;

    protected $ignoreFromPorter = true;
}
```

## Smart Field Type Detection

Porter automatically detects field types based on column names:

| Field Type | Detected Names | Generated Data |
|------------|---------------|----------------|
| Email | email, mail | Safe email address |
| Name | name, username | Full name |
| Phone | phone, mobile, tel | Phone number |
| Address | address, location | Street address |
| City | city, town | City name |
| Country | country, nation | Country name |
| Date | date, timestamp | Date string |
| URL | url, link, website | Valid URL |
| Password | password, pwd | Secure string |
| Token | token, key | SHA-256 hash |

## Custom Data Generation

Override the default data generation for specific fields:

```php
class User extends Model
{
    use PorterConfigurable;

    protected function generateFakeValue(string $type, $value, $faker): mixed
    {
        switch ($type) {
            case 'email':
                return $faker->companyEmail;  // Use company emails
            case 'name':
                return 'User_' . $faker->randomNumber();  // Custom format
            default:
                return parent::generateFakeValue($type, $value, $faker);
        }
    }
}
```

## Performance Optimization

Porter includes several performance optimizations:

1. **Static Caching**

   ```php
   private static $fakerInstance = null;
   private static $columnTypeCache = [];
   ```

2. **Type Safety**

   ```php
   public function porterRandomizeRow(array $row): array
   {
       if (!is_array($row)) {
           throw new InvalidArgumentException('Input must be an array');
       }
       // ... rest of the method
   }
   ```

3. **Efficient Type Detection**

   ```php
   protected function getColumnType(string $columnName): string
   {
       if (!isset(self::$columnTypeCache[$columnName])) {
           $type = $this->determineColumnType($columnName);
           self::$columnTypeCache[$columnName] = $type;
       }

       return self::$columnTypeCache[$columnName];
   }
   ```

## Best Practices

1. **Data Protection**
   - Always anonymize sensitive data
   - Use appropriate field types for data generation
   - Keep a list of preserved records

2. **Performance**
   - Cache type detection results
   - Use batch processing for large datasets
   - Optimize custom data generation

3. **Maintenance**
   - Document preserved record IDs
   - Keep field lists updated
   - Review anonymization rules regularly

4. **Testing**
   - Verify anonymized data format
   - Test with large datasets
   - Validate custom generators

## Example: Complete Model Configuration

```php
use ThinkNeverland\Porter\Traits\PorterConfigurable;

class User extends Model
{
    use PorterConfigurable;

    // Fields to anonymize
    protected $omittedFromPorter = [
        'email',
        'name',
        'phone',
        'address',
        'password',
        'api_token'
    ];

    // Records to preserve
    protected $keepForPorter = [
        1,  // Super admin
        2   // System user
    ];

    // Custom data generation
    protected function generateFakeValue(string $type, $value, $faker): mixed
    {
        switch ($type) {
            case 'email':
                return 'user_' . $faker->randomNumber() . '@example.com';
            case 'api_token':
                return 'tk_' . $faker->sha256;
            default:
                return parent::generateFakeValue($type, $value, $faker);
        }
    }
}
```
