# API Reference

This document provides detailed information about Sole's API, including component structure, directives, and available methods.

## Component Structure

### Template Section

```html
<template>
    <!-- Your component's HTML here -->
    <div>
        <h2>{{ $state->title }}</h2>
        <button click="handleClick">Click me</button>
    </div>
</template>
```

### PHP Section

```php
<?php
// Component logic here
function mount() {
    // Initialization
}

function handleClick() {
    // Event handling
}
?>
```

### Style Section

```html
<style scoped>
/* Component-specific styles */
</style>
```

## Directives

### Template Directives

#### Model Binding

```html
<input type="text" model="name">
<textarea model="description"></textarea>
<select model="category">
    <option value="1">Option 1</option>
    <option value="2">Option 2</option>
</select>
```

#### Event Handling

```html
<button click="handleClick">Click</button>
<input change="handleChange">
<form submit="handleSubmit">
```

#### Conditional Rendering

```html
<div show="$state->isVisible">
    <!-- Content shown when isVisible is true -->
</div>

<div hide="$state->isHidden">
    <!-- Content hidden when isHidden is true -->
</div>

<div if="$state->count > 0">
    <!-- Content shown when count is greater than 0 -->
</div>
```

#### Loops

```html
<ul>
    @foreach($state->items as $item)
        <li>{{ $item->name }}</li>
    @endforeach
</ul>

<div repeat="$state->count">
    <p>Repeated {{ $index + 1 }} times</p>
</div>
```

#### File Upload

```html
<input type="file" upload="handleUpload">
<input type="file" upload="handleUpload" :max-size="5242880">
<input type="file" upload="handleUpload" :allowed-types="['image/jpeg', 'image/png']">
```

#### Real-time Updates

```html
<div refresh="30s">
    <!-- Content refreshed every 30 seconds -->
</div>

<div refresh="1m">
    <!-- Content refreshed every minute -->
</div>
```

### Component Methods

#### Lifecycle Hooks

```php
function mount() {
    // Called when component is first mounted
}

function updating($property, $value) {
    // Called before state updates
}

function updated($property, $value) {
    // Called after state updates
}

function unmount() {
    // Called when component is unmounted
}
```

#### State Management

```php
// Initialize state
$state->property = 'value';

// Define computed property
$this->defineComputed('total', function() {
    return $state->price * $state->quantity;
}, ['price', 'quantity']);

// Use shared state
$this->useSharedState('cart');

// Enable state history
$this->enableHistory(['count'], 10);
```

#### File Upload

```php
function handleUpload($file) {
    $this->upload($file, function($progress) {
        $state->progress = $progress;
    })->then(function($response) {
        $state->uploading = false;
    });
}
```

#### Real-time Updates

```php
function refresh() {
    $state->items = Item::latest()->get();
    $state->timestamp = now();
}
```

#### Event Handling

```php
function handleClick() {
    $state->count++;
}

function handleChange($event) {
    $state->value = $event->target->value;
}

function handleSubmit($event) {
    $event->preventDefault();
    // Handle form submission
}
```

## Component Configuration

### Basic Configuration

```php
class Counter extends Component
{
    protected $props = [
        'title' => 'Counter',
        'initialCount' => 0
    ];
    
    protected $state = [
        'count' => 0
    ];
}
```

### Advanced Configuration

```php
class UserProfile extends Component
{
    protected $props = [
        'userId' => null,
        'showEmail' => true
    ];
    
    protected $state = [
        'user' => null,
        'loading' => false,
        'error' => null
    ];
    
    protected $computed = [
        'fullName' => function() {
            return "{$state->user->first_name} {$state->user->last_name}";
        }
    ];
    
    protected $watchers = [
        'userId' => function($value) {
            $this->loadUser($value);
        }
    ];
}
```

## Error Handling

### Validation Errors

```php
function validate() {
    if (empty($state->name)) {
        $this->addError('name', 'Name is required');
    }
}
```

### API Errors

```php
function handleError($error) {
    $state->error = $error->getMessage();
    $this->notify('error', 'An error occurred');
}
```

## Next Steps

- Learn about [Advanced Features](advanced-features.md)
- Review [Best Practices](best-practices.md)
- Check out [Examples](examples.md)
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/sole/) for more resources
