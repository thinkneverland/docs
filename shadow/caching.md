# Caching Guide

## Overview

Shadow provides a powerful caching system that helps optimize performance through multiple caching strategies and intelligent cache management.

## Cache Configuration

### Basic Setup

```php
// config/shadow.php
'cache' => [
    // Enable/disable caching
    'enabled' => env('SHADOW_CACHE_ENABLED', true),
    
    // Cache TTL in seconds
    'ttl' => env('SHADOW_CACHE_TTL', 3600),
    
    // Cache prefix for keys
    'prefix' => env('SHADOW_CACHE_PREFIX', 'shadow'),
    
    // Cache tags configuration
    'tags' => [
        'enabled' => true,
        'prefix' => 'shadow',
    ],
    
    // Cache drivers
    'driver' => env('SHADOW_CACHE_DRIVER', 'redis'),
    
    // Cache invalidation strategy
    'invalidation' => [
        'strategy' => 'tags', // Options: tags, key-pattern
        'events' => ['created', 'updated', 'deleted'],
    ],
],
```

### Environment Variables

```env
SHADOW_CACHE_ENABLED=true
SHADOW_CACHE_TTL=3600
SHADOW_CACHE_PREFIX=shadow
SHADOW_CACHE_DRIVER=redis
```

## Cache Commands

### Cache Management

```bash
# Clear all Shadow cache
php artisan shadow:cache:clear --all

# Clear specific components
php artisan shadow:cache:clear --models    # Clear model registry cache
php artisan shadow:cache:clear --schema    # Clear schema cache
php artisan shadow:cache:clear --docs      # Clear API documentation cache
php artisan shadow:cache:clear --search    # Clear search results cache

# Warm up cache
php artisan shadow:cache:warmup --all
php artisan shadow:cache:warmup --models
php artisan shadow:cache:warmup --schema

# View cache metrics
php artisan shadow:cache:metrics
php artisan shadow:cache:metrics --tag=shadow-models --detailed

# Analyze cache usage
php artisan shadow:cache:analyze
php artisan shadow:cache:analyze --tag=shadow-models --threshold=60
```

## Cache Strategies

### Model-Level Caching

```php
use ThinkNeverland\Shadow\Traits\HasShadow;

class User extends Model
{
    use HasShadow;

    protected $shadowConfig = [
        'cache' => [
            'enabled' => true,
            'ttl' => 3600,
            'tags' => ['users'],
            'invalidate_on' => ['created', 'updated', 'deleted'],
        ],
    ];
}
```

### Query-Level Caching

```php
// Cache a specific query
$users = $shadow->model(User::class)
    ->filter(['status' => 'active'])
    ->cache(3600)
    ->get();

// Cache with tags
$posts = $shadow->model(Post::class)
    ->include(['author'])
    ->cacheTags(['posts', 'authors'])
    ->remember(3600)
    ->paginate();

// Cache with custom key
$result = $shadow->model(Product::class)
    ->cacheKey('products:featured')
    ->cache(3600)
    ->get();
```

### Relationship Caching

```php
protected $shadowConfig = [
    'relationships' => [
        'posts' => [
            'cache' => [
                'enabled' => true,
                'ttl' => 1800,
                'tags' => ['user-posts'],
            ],
        ],
    ],
];
```

## Cache Invalidation

### Automatic Invalidation

Shadow automatically invalidates cache entries when:

- Models are created, updated, or deleted
- Related models are modified
- Schema changes are detected

### Manual Invalidation

```php
// Clear all cache for a model
$shadow->model(User::class)->flushCache();

// Clear specific cache tags
$shadow->cache()->tags(['users', 'posts'])->flush();

// Clear cache by pattern
$shadow->cache()->flushPattern('users:*');

// Clear cache for a specific key
$shadow->cache()->forget('users:featured');
```

## Cache Drivers

### Available Drivers

- **Redis** (Recommended for production)

  ```php
  'cache' => [
      'driver' => 'redis',
      'connection' => 'cache',
  ],
  ```

- **Memcached**

  ```php
  'cache' => [
      'driver' => 'memcached',
      'persistent_id' => 'shadow',
  ],
  ```

- **File**

  ```php
  'cache' => [
      'driver' => 'file',
      'path' => storage_path('framework/cache/shadow'),
  ],
  ```

### Driver Configuration

```php
'cache' => [
    'driver' => env('SHADOW_CACHE_DRIVER', 'redis'),
    
    'stores' => [
        'redis' => [
            'driver' => 'redis',
            'connection' => 'cache',
            'lock_connection' => 'default',
        ],
        
        'memcached' => [
            'driver' => 'memcached',
            'persistent_id' => env('MEMCACHED_PERSISTENT_ID'),
            'sasl' => [
                env('MEMCACHED_USERNAME'),
                env('MEMCACHED_PASSWORD'),
            ],
            'options' => [
                // Memcached options
            ],
        ],
    ],
],
```

## Performance Optimization

### Cache Keys

```php
// Efficient key generation
protected function generateCacheKey($query)
{
    return sprintf(
        '%s:%s:%s',
        $this->getTable(),
        md5($query->toSql()),
        md5(serialize($query->getBindings()))
    );
}

// Key prefixing
protected function getCachePrefix()
{
    return config('shadow.cache.prefix', 'shadow');
}
```

### Cache Tags

```php
// Efficient tag usage
protected function getCacheTags()
{
    return [
        'model:' . $this->getTable(),
        'type:' . class_basename($this),
    ];
}

// Relationship tags
protected function getRelationshipTags($relation)
{
    return [
        'relation:' . $this->getTable() . '.' . $relation,
        'model:' . $this->getTable(),
    ];
}
```

## Monitoring and Debugging

### Cache Metrics

```bash
# View basic metrics
php artisan shadow:cache:metrics

# View detailed metrics
php artisan shadow:cache:metrics --detailed

# Export metrics
php artisan shadow:cache:metrics --export=metrics.json
```

### Cache Analysis

```bash
# Analyze cache usage
php artisan shadow:cache:analyze

# Analyze with custom thresholds
php artisan shadow:cache:analyze \
    --hit-rate-warning=80 \
    --memory-warning=512 \
    --ttl-warning=86400
```

### Debugging

```php
// Enable cache debugging
config(['shadow.cache.debug' => true]);

// Log cache operations
\Log::debug('Cache operation', [
    'key' => $key,
    'tags' => $tags,
    'ttl' => $ttl,
    'hit' => $wasHit,
]);
```

## Best Practices

1. **Cache Strategy**
   - Use Redis for production environments
   - Implement proper cache invalidation
   - Use appropriate TTL values

2. **Performance**
   - Use cache tags for efficient invalidation
   - Implement efficient key generation
   - Monitor cache hit rates

3. **Maintenance**
   - Regularly analyze cache usage
   - Monitor memory usage
   - Schedule cache warmup

4. **Security**
   - Don't cache sensitive data
   - Implement proper access controls
   - Use secure connections for remote cache servers
