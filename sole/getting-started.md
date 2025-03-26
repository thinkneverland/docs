# Getting Started with Sole

This guide will help you get started with Sole by walking you through installation and basic usage.

## Installation

1. Install Sole via Composer:

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

4. For TypeScript support, add types to your `tsconfig.json`:

```json
{
    "compilerOptions": {
        "types": ["@thinkneverland/sole"]
    }
}
```

## Basic Usage

### Creating Your First Component

Create a new file `resources/views/components/counter.sole`:

```php
<template>
    <div>
        <h2>Count: {{ $state->count }}</h2>
        <button click="increment">Increment</button>
    </div>
</template>

<?php
function mount() {
    $state->count = 0;
}

function increment() {
    $state->count++;
}
?>
```

### Using Components in Your Views

Include your Sole component in a Blade view:

```php
<x-counter />
```

### State Management

Initialize and manage component state:

```php
<template>
    <div>
        <input type="text" model="name">
        <p>Hello, {{ $state->name }}!</p>
    </div>
</template>

<?php
function mount() {
    $state->name = '';
}
?>
```

### Event Handling

Handle user interactions:

```php
<template>
    <div>
        <button click="handleClick">Click me</button>
        <p>{{ $state->message }}</p>
    </div>
</template>

<?php
function mount() {
    $state->message = '';
}

function handleClick() {
    $state->message = 'Button clicked!';
}
?>
```

### File Uploads

Handle file uploads with progress tracking:

```php
<template>
    <div>
        <input type="file" upload="handleUpload">
        <div class="progress" show="$state->uploading">
            {{ $state->progress }}%
        </div>
    </div>
</template>

<?php
function mount() {
    $state->uploading = false;
    $state->progress = 0;
}

function handleUpload($file) {
    $state->uploading = true;
    
    $this->upload($file, function($progress) {
        $state->progress = $progress;
    })->then(function($response) {
        $state->uploading = false;
        $state->progress = 100;
    });
}
?>
```

### Real-time Updates

Enable auto-refresh capabilities:

```php
<template>
    <div>
        <div refresh="30s">
            <h3>Last updated: {{ $state->timestamp }}</h3>
            <ul>
                @foreach($state->items as $item)
                    <li>{{ $item->name }}</li>
                @endforeach
            </ul>
        </div>
    </div>
</template>

<?php
function mount() {
    $this->refresh('30s');
    $state->items = [];
    $state->timestamp = now();
}

function refresh() {
    $state->items = Item::latest()->get();
    $state->timestamp = now();
}
?>
```

### Computed Properties

Use computed properties for derived state:

```php
<template>
    <div>
        <input type="number" model="price">
        <input type="number" model="quantity">
        <p>Total: ${{ $state->total }}</p>
    </div>
</template>

<?php
function mount() {
    $state->price = 0;
    $state->quantity = 0;
    
    $this->defineComputed('total', function() {
        return $state->price * $state->quantity;
    }, ['price', 'quantity']);
}
?>
```

## Next Steps

- Learn about [Component Configuration](configuration.md)
- Explore [Advanced Features](advanced-features.md)
- Check out [Best Practices](best-practices.md)
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/sole/) for more resources
