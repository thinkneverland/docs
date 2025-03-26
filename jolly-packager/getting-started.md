# Getting Started with JollyPackager

This guide will walk you through installing and using JollyPackager for both package creation and documentation generation.

## Installation

1. Install the package via Composer:

```bash
composer require thinkneverland/jollypackager
```

2. Publish the configuration file:

```bash
php artisan vendor:publish --provider="ThinkNeverland\JollyPackager\JollyPackagerServiceProvider" --tag="config"
```

## Creating a New Package

### Basic Package Creation

Create a new Laravel package with a single command:

```bash
php artisan jolly:make vendor-name package-name
```

For example:

```bash
php artisan jolly:make acme awesome-package
```

This will create a new package in `packages/acme/awesome-package` with the following structure:

```
awesome-package/
├── src/
│   ├── AwesomePackageServiceProvider.php
│   └── Console/
│       └── Commands/
├── config/
├── database/
│   ├── migrations/
│   └── seeders/
├── resources/
│   └── views/
├── routes/
├── tests/
├── composer.json
└── README.md
```

### Customizing Package Generation

You can customize the package generation by modifying the configuration in `config/jollypackager.php`:

```php
return [
    'package' => [
        'namespace' => 'App',
        'author' => [
            'name' => 'Your Name',
            'email' => 'your.email@example.com',
        ],
        'license' => 'MIT',
        'stubs_path' => __DIR__ . '/../stubs/package',
    ],
];
```

## Generating Documentation

### Basic Documentation Generation

Generate documentation for your Laravel project or package:

```bash
php artisan jolly:docs app/
```

This will scan the specified directory and generate comprehensive Markdown documentation in the `docs` directory.

### Customizing Documentation Output

1. Specify a custom output directory:

```bash
php artisan jolly:docs app/ --output=custom-docs
```

2. Exclude specific patterns:

```bash
php artisan jolly:docs app/ --exclude=tests,vendor
```

### Documentation Structure

The generated documentation will be organized as follows:

```
docs/
├── README.md          # Main documentation page
├── controllers/       # Controller documentation
│   └── UserController.md
├── models/           # Model documentation
│   └── User.md
├── routes/           # Route documentation
│   ├── api.md
│   └── web.md
└── components/       # Component documentation
    └── Button.md
```

## Best Practices

### Package Development

1. **Namespace Convention**
   - Use PSR-4 compliant namespaces
   - Follow Laravel's naming conventions
   - Keep class names descriptive

2. **File Organization**
   - Group related files in directories
   - Use appropriate subdirectories
   - Follow Laravel's directory structure

3. **Documentation**
   - Write clear PHPDoc comments
   - Include usage examples
   - Document public methods

### Documentation Generation

1. **Code Comments**
   - Use descriptive PHPDoc blocks
   - Include parameter types
   - Document return values
   - Add usage examples

2. **Directory Structure**
   - Organize code logically
   - Use appropriate namespaces
   - Keep related files together

3. **File Naming**
   - Use consistent naming
   - Follow Laravel conventions
   - Be descriptive

## Common Tasks

### Adding Commands to Your Package

1. Create a new command in your package:

```bash
php artisan make:command MyCommand
```

2. Move the command to your package's `src/Console/Commands` directory

3. Register the command in your service provider:

```php
public function boot()
{
    if ($this->app->runningInConsole()) {
        $this->commands([
            MyCommand::class,
        ]);
    }
}
```

### Adding Configuration

1. Create a config file in your package's `config` directory

2. Register it in your service provider:

```php
public function boot()
{
    $this->publishes([
        __DIR__.'/../config/my-package.php' => config_path('my-package.php'),
    ], 'config');
}
```

### Adding Views

1. Create views in your package's `resources/views` directory

2. Register them in your service provider:

```php
public function boot()
{
    $this->loadViewsFrom(__DIR__.'/../resources/views', 'my-package');
}
```

## Troubleshooting

### Common Issues

1. **Package Not Found**
   - Check composer.json autoload settings
   - Run `composer dump-autoload`
   - Verify namespace matches PSR-4

2. **Documentation Not Generated**
   - Check file permissions
   - Verify directory paths
   - Check for excluded patterns

3. **Missing Dependencies**
   - Run `composer install`
   - Check minimum PHP version
   - Verify Laravel version

## Next Steps

- Explore the [API Reference](api-reference.md) for detailed documentation
- Learn about customizing templates and stubs
- Contribute to the project on GitHub
