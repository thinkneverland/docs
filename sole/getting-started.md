# Getting Started with Sole

This guide will walk you through setting up and using Sole in your Laravel application.

## Installation

1. Install the package via Composer:

```bash
composer require thinkneverland/sole
```

2. Publish the assets:

```bash
php artisan vendor:publish --tag=sole-assets
```

3. Add the JavaScript to your layout:

```html
<!-- Development version -->
<script src="{{ asset('vendor/sole/sole-core.js') }}"></script>

<!-- With PWA support -->
<script src="{{ asset('vendor/sole/sole-pwa.js') }}"></script>

<!-- With accessibility improvements -->
<script src="{{ asset('vendor/sole/sole-a11y.js') }}"></script>

<!-- Production version (minified, all features) -->
<script src="{{ asset('vendor/sole/sole.min.js') }}"></script>
```

## Creating Your First Component

1. Use the artisan command to create a new component:

```bash
php artisan make:sole Counter
```

This will create a new file at `resources/views/components/Counter.sole` with the following structure:

```html
<template>
    <div>
        <h2>{{ $state->title }}</h2>
        <p>Counter: {{ $state->count }}</p>
        <button click="increment">Increment</button>
    </div>
</template>

<?php
// Component state and methods
$state->title ??= 'Counter';
$state->count ??= 0;

function mount() {
    // Called when component is first mounted
}

function increment() {
    $state->count++;
}

function updating($property, $value) {
    // Called before state updates
}

function updated($property, $value) {
    // Called after state updates
}
?>

<style scoped>
div {
    padding: 1rem;
}
</style>
```

## Using Components

1. Use the `@sole` directive in your Blade views:

```html
@sole('components.counter')
```

2. Pass props to your component:

```html
@sole('components.counter', ['title' => 'My Counter'])
```

## Component Structure

### Template Section

The template section contains your component's HTML using Blade syntax:

```html
<template>
    <div>
        <!-- Your component's HTML here -->
    </div>
</template>
```

### PHP Section

The PHP section defines your component's logic:

```php
<?php
// Initial state
$state->property ??= 'default value';

// Lifecycle hooks
function mount() {
    // Component initialization
}

// Event handlers
function handleClick() {
    $state->property = 'new value';
}
?>
```

### Style Section

The style section contains component-specific CSS:

```html
<style scoped>
/* Styles are automatically scoped to your component */
div {
    /* Your styles here */
}
</style>
```

## Advanced Features

### Progressive Web App Support

Enable offline capabilities:

```html
<div offline-capable>
    <!-- This content will work offline -->
    <p>{{ $state->message }}</p>
    <button click="saveData">Save (works offline)</button>
</div>
```

### State Management

#### Computed Properties

```php
function mount() {
    $state->items = [
        ['name' => 'Item 1', 'price' => 10],
        ['name' => 'Item 2', 'price' => 20]
    ];
    
    $this->defineComputed('total', function() {
        return array_sum(array_column($state->items, 'price'));
    }, ['items']);
}
```

#### Shared State

```php
function mount() {
    $this->useSharedState('cart');
    $state->items ??= [];
}
```

### File Uploads

```html
<input 
    type="file" 
    upload 
    :max-file-size="5242880"
    :allowed-types="['image/jpeg', 'image/png']"
>
```

### Internationalization

```php
// Define translations
$translations = [
    'en' => [
        'welcome.title' => 'Welcome',
        'welcome.description' => 'Hello, :name!'
    ],
    'fr' => [
        'welcome.title' => 'Bienvenue',
        'welcome.description' => 'Bonjour, :name!'
    ]
];

function mount() {
    app('sole.translator')->registerComponentTranslations('welcome', $translations);
}
```

## Best Practices

1. **Component Organization**
   - Keep components focused and single-purpose
   - Use meaningful names that describe functionality
   - Group related components in subdirectories

2. **State Management**
   - Initialize all state properties in mount()
   - Use computed properties for derived values
   - Keep state mutations predictable

3. **Performance**
   - Use lazy loading for large components
   - Implement proper caching strategies
   - Optimize asset loading

4. **Security**
   - Validate all user input
   - Use CSRF protection
   - Implement proper authorization

5. **Accessibility**
   - Use semantic HTML
   - Include ARIA attributes
   - Test with screen readers

## Debugging

Enable debug mode in your `.env` file:

```env
SOLE_DEBUG=true
```

Or enable per component:

```html
<sole name="components.counter" :debug="true"></sole>
```

## Next Steps

- Explore the [API Reference](api-reference.md) for detailed documentation
- Learn about advanced features like AI integration
- Join the community and contribute to the project
