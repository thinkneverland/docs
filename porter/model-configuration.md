# Model Configuration

This guide explains how to configure your Laravel models to work with Porter's data handling features.

## Basic Configuration

Add the `PorterConfigurable` trait to your models to enable Porter's data handling features:

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

## Configuration Properties

### `$omittedFromPorter`

Specifies fields that should be randomized during export/import operations.

```php
protected $omittedFromPorter = [
    'email',
    'name',
    'phone',
    'address'
];
```

Porter will automatically detect field types and generate appropriate random values:

- Email fields: Random email addresses
- Name fields: Random names
- Phone fields: Random phone numbers
- Address fields: Random addresses
- Other fields: Random strings or numbers based on type

### `$keepForPorter`

Specifies specific row IDs that should remain unchanged during export/import.

```php
protected $keepForPorter = [
    1,  // Admin user
    2,  // System user
    3   // Default user
];
```

This is useful for preserving important system records or default data.

### `$ignoreFromPorter`

Excludes the entire model from Porter operations.

```php
protected $ignoreFromPorter = true;
```

Use this when you want to completely skip a model during export/import operations.

## Advanced Configuration

### Custom Value Generation

You can define custom value generators for specific fields:

```php
use ThinkNeverland\Porter\Traits\PorterConfigurable;

class User extends Model
{
    use PorterConfigurable;

    protected $omittedFromPorter = ['email', 'name'];

    public function getPorterValue($field)
    {
        switch ($field) {
            case 'email':
                return 'custom-' . uniqid() . '@example.com';
            case 'name':
                return 'Custom User ' . rand(1, 1000);
            default:
                return parent::getPorterValue($field);
        }
    }
}
```

### Relationship Handling

Porter automatically handles relationships during export/import:

```php
class Post extends Model
{
    use PorterConfigurable;

    protected $omittedFromPorter = ['title', 'content'];

    public function author()
    {
        return $this->belongsTo(User::class);
    }

    public function comments()
    {
        return $this->hasMany(Comment::class);
    }
}
```

- Foreign keys are automatically updated
- Related records are preserved
- Relationship integrity is maintained

## Best Practices

### Data Anonymization

1. **Identify Sensitive Fields**
   - Personal information
   - Contact details
   - Financial data
   - Authentication credentials

2. **Use Appropriate Randomization**
   - Match data types
   - Maintain data integrity
   - Consider relationships

3. **Preserve Important Data**
   - System records
   - Default configurations
   - Reference data

### Performance Optimization

1. **Selective Export**
   - Only export necessary models
   - Exclude large tables when possible
   - Use `$ignoreFromPorter` for irrelevant models

2. **Efficient Processing**
   - Use chunking for large datasets
   - Optimize relationship loading
   - Cache generated values

### Security Considerations

1. **Data Protection**
   - Always anonymize sensitive data
   - Use secure random generation
   - Validate data integrity

2. **Access Control**
   - Restrict export/import operations
   - Log all data operations
   - Monitor for suspicious activity

## Examples

### User Model Example

```php
use ThinkNeverland\Porter\Traits\PorterConfigurable;

class User extends Model
{
    use PorterConfigurable;

    protected $omittedFromPorter = [
        'email',
        'name',
        'phone',
        'address'
    ];

    protected $keepForPorter = [1]; // Keep admin user

    public function getPorterValue($field)
    {
        switch ($field) {
            case 'email':
                return 'porter-' . uniqid() . '@example.com';
            case 'name':
                return 'Porter User ' . rand(1, 1000);
            case 'phone':
                return '+1' . rand(1000000000, 9999999999);
            case 'address':
                return rand(100, 9999) . ' Porter Street';
            default:
                return parent::getPorterValue($field);
        }
    }
}
```

### Product Model Example

```php
use ThinkNeverland\Porter\Traits\PorterConfigurable;

class Product extends Model
{
    use PorterConfigurable;

    protected $omittedFromPorter = [
        'name',
        'description',
        'price'
    ];

    protected $keepForPorter = [1, 2]; // Keep default products

    public function getPorterValue($field)
    {
        switch ($field) {
            case 'name':
                return 'Product ' . rand(1, 1000);
            case 'description':
                return 'Random product description ' . rand(1, 1000);
            case 'price':
                return rand(1, 1000) / 100; // Random price between 0.01 and 10.00
            default:
                return parent::getPorterValue($field);
        }
    }
}
```

## Next Steps

- Review [Configuration](configuration.md) for global settings
- Learn about [S3 Integration](s3-integration.md) for file handling
- Check [Best Practices](best-practices.md) for optimal usage
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/porter/) for more resources
