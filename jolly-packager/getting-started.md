# Getting Started with Jolly Packager

This guide will help you get started with Jolly Packager, from installation to creating your first package and generating documentation.

## Installation

1. Install the package via Composer:

```bash
composer require thinkneverland/jollypackager
```

2. Publish the configuration file:

```bash
php artisan vendor:publish --tag=config
```

## Creating a New Package

The `jolly:make` command helps you create a new Laravel package with all the necessary structure and files.

### Basic Usage

```bash
php artisan jolly:make vendor package
```

For example:

```bash
php artisan jolly:make acme my-package
```

This will create a new package with the following structure:

```
acme/my-package/
├── src/
│   ├── MyPackageServiceProvider.php
│   └── Console/
│       └── Commands/
├── config/
├── database/
├── resources/
├── routes/
├── tests/
├── composer.json
└── README.md
```

### Command Options

- `--force`: Overwrite existing files if they exist
- `--no-git`: Skip git repository initialization
- `--no-composer`: Skip composer.json generation

## Generating Documentation

The `jolly:docs` command generates comprehensive documentation for your Laravel project.

### Basic Usage

```bash
php artisan jolly:docs app --output=docs
```

### Command Options

- `--output`: Specify the output directory for documentation
- `--exclude`: Specify patterns to exclude from documentation
- `--format`: Choose the documentation format (markdown, html)

### Documentation Structure

The generated documentation will include:

- Controllers
- Models
- Routes
- Components

## Configuration

You can customize Jolly Packager's behavior by modifying the configuration file at `config/jollypackager.php`:

```php
return [
    'package' => [
        'namespace' => env('JOLLYPACKAGER_NAMESPACE', 'App'),
        'author' => env('JOLLYPACKAGER_AUTHOR', 'Your Name'),
        'email' => env('JOLLYPACKAGER_EMAIL', 'your.email@example.com'),
    ],
    'docs' => [
        'output_dir' => env('JOLLYPACKAGER_DOCS_DIR', 'docs'),
        'exclude_patterns' => [
            'vendor/*',
            'storage/*',
            'bootstrap/*',
        ],
    ],
];
```

## Next Steps

- Check out the [API Reference](api-reference.md) for detailed information about all available commands and options
- Learn about [Contributing](contributing.md) to Jolly Packager
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/jolly-packager/) for more resources
