# Sole - Single-File Components for Laravel

Sole is a powerful Laravel package that enables you to write single-file `.sole` components with Blade/PHP/HTML and optional CSS, with minimal JavaScript. The package's JavaScript engine automatically handles server communication, DOM updates, validation, and more.

## 🎯 Key Features

### Component Development

- **Single-File Components**: Write Blade, PHP, and CSS in one file
- **Automatic Updates**: Server communication and DOM updates handled automatically
- **Lifecycle Hooks**: Mount, updating, updated, and more
- **Scoped CSS**: Component-specific styling
- **TypeScript Support**: Full TypeScript integration

### Advanced Features

- **State Management**: Computed properties, shared state, and history
- **File Handling**: Secure file uploads with progress tracking
- **Real-time Updates**: Rate-limited polling and auto-refresh
- **Event System**: Type-safe cross-component events
- **PWA Support**: Progressive Web App capabilities

### AI & Accessibility

- **AI Features**: Text processing, suggestions, and enhancements
- **Accessibility**: Automatic improvements and ARIA enhancements
- **Internationalization**: Multi-language support with formatting
- **Analytics**: Built-in monitoring and tracking

## 🔧 System Requirements

- PHP 8.1 or higher
- Laravel 10.0 or higher
- Node.js 16.0 or higher (for TypeScript support)

## 🚀 Quick Start

1. Install via Composer:

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

<!-- Production version (minified, all features) -->
<script src="{{ asset('vendor/sole/sole.min.js') }}"></script>
```

4. Create your first Sole component:

```php
// resources/views/components/counter.sole
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

## 📚 Documentation

For detailed documentation, please visit our [GitBook documentation](https://thinkneverland.gitbook.io/sole/).

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guide](contributing.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

Sole is open-source software licensed under the MIT license. See the [LICENSE](LICENSE.md) file for more details.
