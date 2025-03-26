# JollyPackager API Reference

This document provides detailed information about JollyPackager's API, including commands, services, and configuration options.

## Console Commands

### MakePackageCommand

Creates a new Laravel package with the JollyPackager structure.

```php
use ThinkNeverland\JollyPackager\Console\Commands\MakePackageCommand;

/**
 * Command signature: jolly:make {vendor} {package} {--force}
 */
class MakePackageCommand extends Command
{
    // ...
}
```

#### Arguments

- `vendor`: The vendor name (lowercase, alphanumeric with hyphens)
- `package`: The package name (lowercase, alphanumeric with hyphens)

#### Options

- `--force`: Force creation even if package exists

#### Methods

- `handle()`: Main command execution
- `createPackageStructure(string $packagePath)`: Create directory structure
- `generateComposerJson(string $vendor, string $package, string $packagePath)`: Generate composer.json
- `generateServiceProvider(string $vendor, string $package, string $packagePath)`: Generate service provider
- `generateReadme(string $vendor, string $package, string $packagePath)`: Generate README.md
- `initializeGit(string $packagePath)`: Initialize git repository

### GenerateDocsCommand

Generates comprehensive documentation for Laravel projects and packages.

```php
use ThinkNeverland\JollyPackager\Console\Commands\GenerateDocsCommand;

/**
 * Command signature: jolly:docs {directory} {--output=docs} {--exclude=}
 */
class GenerateDocsCommand extends Command
{
    // ...
}
```

#### Arguments

- `directory`: The directory to scan for documentation
- `--output`: Output directory for documentation (default: docs)
- `--exclude`: Comma-separated list of patterns to exclude

#### Methods

- `handle()`: Main command execution
- `documentControllers(string $directory, string $outputPath, array $excludePatterns)`: Document controllers
- `documentModels(string $directory, string $outputPath, array $excludePatterns)`: Document models
- `documentRoutes(string $directory, string $outputPath)`: Document routes
- `documentComponents(string $directory, string $outputPath, array $excludePatterns)`: Document components

## Service Provider

### JollyPackagerServiceProvider

Registers and bootstraps JollyPackager services.

```php
use ThinkNeverland\JollyPackager\JollyPackagerServiceProvider;

class JollyPackagerServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->mergeConfigFrom(
            __DIR__ . '/../config/jollypackager.php',
            'jollypackager'
        );
    }

    public function boot(): void
    {
        // Register commands and publish assets
    }
}
```

## Configuration

### Package Configuration (config/jollypackager.php)

```php
return [
    /*
    |--------------------------------------------------------------------------
    | Package Generation Settings
    |--------------------------------------------------------------------------
    */
    'package' => [
        'namespace' => 'App',
        'author' => [
            'name' => 'Your Name',
            'email' => 'your.email@example.com',
        ],
        'license' => 'MIT',
        'stubs_path' => __DIR__ . '/../stubs/package',
    ],

    /*
    |--------------------------------------------------------------------------
    | Documentation Generation Settings
    |--------------------------------------------------------------------------
    */
    'docs' => [
        'output_path' => 'docs',
        'excluded_directories' => [
            'vendor',
            'node_modules',
            'storage',
            'bootstrap/cache',
        ],
        'excluded_files' => [
            '*.blade.php',
            '*.test.php',
            '*.spec.php',
        ],
        'templates' => [
            'controller' => __DIR__ . '/../stubs/docs/controller.md',
            'model' => __DIR__ . '/../stubs/docs/model.md',
            'route' => __DIR__ . '/../stubs/docs/route.md',
            'component' => __DIR__ . '/../stubs/docs/component.md',
        ],
    ],
];
```

## Stubs

### Package Stubs

#### ServiceProvider.stub

```php
<?php

namespace {{ namespace }};

use Illuminate\Support\ServiceProvider;

class {{ class }}ServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->mergeConfigFrom(
            __DIR__.'/../config/{{ package }}.php', '{{ package }}'
        );
    }

    public function boot(): void
    {
        if ($this->app->runningInConsole()) {
            $this->publishes([
                __DIR__.'/../config/{{ package }}.php' => config_path('{{ package }}.php'),
            ], 'config');
        }
    }
}
```

### Documentation Stubs

#### controller.md

```markdown
# {{ class }}

## 🏴‍☠️ Overview

{{ description }}

## 🗺️ Methods

{{ methods }}

## ⚙️ Properties

{{ properties }}
```

#### model.md

```markdown
# {{ class }}

## 🏴‍☠️ Overview

{{ description }}

## ⚙️ Properties

{{ properties }}

## 🗺️ Relationships

{{ relationships }}

## 🎯 Methods

{{ methods }}
```

#### route.md

```markdown
# 🗺️ Routes

## 🏴‍☠️ Overview

{{ description }}

## 📚 Route Definitions

{{ routes }}
```

#### component.md

```markdown
# {{ class }}

## 🏴‍☠️ Overview

{{ description }}

## ⚙️ Properties

{{ properties }}

## 🗺️ Methods

{{ methods }}

## 📚 Blade Template

{{ blade_template }}
```

## Helper Methods

### File Operations

```php
protected function findFiles(string $directory, string $pattern, array $excludePatterns = []): array
```

Finds files matching a pattern in a directory.

```php
protected function getNamespace(string $file): string
```

Extracts namespace from a PHP file.

### Documentation Generation

```php
protected function getDocComment($reflection): string
```

Extracts and formats documentation comments.

```php
protected function getMethodSignature(ReflectionMethod $method): string
```

Generates method signature documentation.

### Package Generation

```php
protected function createPackageStructure(string $packagePath): void
```

Creates the package directory structure.

```php
protected function generateComposerJson(string $vendor, string $package, string $packagePath): void
```

Generates the composer.json file for a package.
