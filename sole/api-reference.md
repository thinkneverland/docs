# Sole API Reference

This document provides detailed information about Sole's API, including components, services, and configuration options.

## Core Classes

### SoleManager

The main class responsible for managing components and rendering.

```php
use ThinkNeverland\Sole\SoleManager;

public function __construct($app)
{
    $this->app = $app;
}
```

#### Methods

- `render($component, $props = [])`: Render a component with optional props
- `parseComponent($path)`: Parse a .sole file into its sections
- `wrapPhpCode($code, $state)`: Prepare PHP code for execution

### SoleComponent

Base component class that provides core functionality.

```php
class SoleComponent
{
    public $element;
    public $props;
    public $behaviors;
    public $pollTimers;
    public $rateLimit;
}
```

#### Properties

- `element`: The component's DOM element
- `props`: Component properties
- `behaviors`: Attached behaviors
- `pollTimers`: Active polling timers
- `rateLimit`: Rate limiting configuration

#### Methods

- `dispatch(eventName, detail)`: Dispatch a component event
- `startPolling(endpoint, interval, callback)`: Start polling an endpoint
- `stopPolling(endpoint)`: Stop polling an endpoint

## Services

### SoleTranslator

Handles internationalization and translations.

```php
use ThinkNeverland\Sole\I18n\SoleTranslator;

class SoleTranslator
{
    protected string $locale;
    protected string $fallbackLocale;
    protected array $translations = [];
    protected array $componentTranslations = [];
}
```

#### Methods

- `setLocale(string $locale)`: Set the current locale
- `registerComponentTranslations(string $component, array $translations)`: Register translations
- `translate(string $key, array $replace = [])`: Get a translation

### FileUploadBehavior

Handles file uploads with progress tracking and validation.

```php
class FileUploadBehavior implements Behavior
{
    protected $maxFileSize;
    protected $allowedTypes;
}
```

#### Methods

- `handleFiles(FileList $files)`: Process uploaded files
- `validateFile(File $file)`: Validate a file
- `uploadFile(File $file)`: Upload a file

## Configuration

### Main Configuration (config/sole.php)

```php
return [
    // Debug Mode
    'debug' => env('SOLE_DEBUG', false),
    
    // Debug Options
    'debug_options' => [
        'lifecycle' => true,
        'state' => true,
        'network' => true,
        'performance' => true,
        'dom' => true,
        'events' => true,
        'stack_traces' => true,
    ],
    
    // Internationalization
    'i18n' => [
        'locale' => 'en',
        'fallback_locale' => 'en',
        'cache_time' => 60 * 24, // minutes
    ],
    
    // Progressive Web App
    'pwa' => [
        'enabled' => true,
        'cache_version' => 'v1',
        'offline_page' => '/offline.html',
    ],
];
```

## Component Lifecycle

### Lifecycle Hooks

```php
// Called when component is first mounted
function mount() {}

// Called before state updates
function updating($property, $value) {}

// Called after state updates
function updated($property, $value) {}

// Called before component is destroyed
function destroy() {}
```

## Events

### Component Events

```php
// Dispatch an event
$this->dispatch('custom-event', ['data' => 'value']);

// Listen for an event
$this->on('custom-event', function($data) {
    // Handle event
});
```

### System Events

- `sole:mounted`: Component mounted
- `sole:updated`: State updated
- `sole:destroyed`: Component destroyed
- `sole:error`: Error occurred

## TypeScript Support

### Type Definitions

```typescript
declare namespace Sole {
    interface ComponentProps {
        [key: string]: string;
    }

    interface EventPayload {
        type: string;
        data: any;
        source: string;
    }

    interface UploadProgress {
        loaded: number;
        total: number;
        percentage: number;
    }
}
```

## Behaviors

### Available Behaviors

1. **Interactive Behavior**

```html
<div clickable hover>
    <!-- Content -->
</div>
```

2. **Collapsible Behavior**

```html
<div class="sole-collapsible">
    <button class="sole-collapsible-trigger">Toggle</button>
    <div class="sole-collapsible-content">
        <!-- Content -->
    </div>
</div>
```

3. **Input Behavior**

```html
<input type="text" clearable>
```

4. **Selection Behavior**

```html
<div selectable>
    <div role="option">Item 1</div>
    <div role="option">Item 2</div>
</div>
```

## Security

### CSRF Protection

CSRF protection is automatically enabled for all component requests.

### File Upload Security

```php
'upload' => [
    'max_size' => 50 * 1024 * 1024, // 50MB
    'allowed_types' => [
        'image/jpeg',
        'image/png',
        'application/pdf'
    ],
    'storage' => [
        'disk' => 'public',
        'path' => 'uploads'
    ]
]
```

### Authorization

```php
protected $middleware = ['sole.auth'];

public function authorize()
{
    return auth()->user()->can('view', $this->model);
}
```

## Progressive Web App

### Service Worker

```javascript
// public/sole-service-worker.js
const CACHE_NAME = 'sole-cache-v1';
const RUNTIME_CACHE = 'sole-runtime';

self.addEventListener('install', event => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => cache.addAll(PRECACHE_URLS))
    );
});
```

### Offline Support

```html
<div offline-capable>
    <!-- This content will work offline -->
</div>
```

## Testing

### Component Testing

```php
use ThinkNeverland\Sole\Testing\SoleTester;

class CounterTest extends TestCase
{
    public function test_counter_increments()
    {
        $component = SoleTester::component('counter')
            ->withState(['count' => 0])
            ->render();
        
        $component->click('button');
        
        $component->assertSee('Count: 1');
        $component->assertStateEquals('count', 1);
    }
}
```

### Available Assertions

- `assertSee($text)`
- `assertDontSee($text)`
- `assertStateEquals($key, $value)`
- `assertEventDispatched($event)`
- `assertHasClass($class)`
- `assertVisible()`
- `assertHidden()`
- `assertAccessible()`
