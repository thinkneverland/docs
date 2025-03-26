# Porter

Porter is a powerful Laravel package designed to streamline database export, import, and S3 bucket management operations. It provides a robust set of tools for handling data migration and backup tasks with built-in support for data anonymization and selective export.

## Overview

Porter simplifies complex data operations in Laravel applications by providing:

- Database export with customizable data anonymization
- Database import with optimized streaming
- S3 bucket cloning with intelligent caching
- Support for multiple S3 configurations
- Model-level control over data handling

## Key Features

### Database Operations

- Export database to SQL files with optional data anonymization
- Import SQL files with optimized streaming and chunk processing
- Support for both local and S3 storage
- Configurable data retention and expiration
- Automatic handling of database structure and relationships

### S3 Management

- Clone contents between S3 buckets
- Support for multiple S3 configurations
- Intelligent caching for file existence checks
- Retry mechanisms for failed transfers
- Progress tracking and detailed reporting

### Data Protection

- Model-level control over data anonymization
- Smart field type detection
- Configurable data retention
- Secure handling of sensitive information
- Support for data masking and randomization

### Developer Experience

- Simple and intuitive command-line interface
- Extensive configuration options
- Clear and detailed error reporting
- Progress indicators for long-running operations
- Comprehensive logging and debugging tools

## System Requirements

- PHP 8.1 or higher
- Laravel 10.x or 11.x
- AWS SDK for PHP
- Composer for dependency management

## Documentation Structure

- [Getting Started](getting-started.md)
- [Configuration](configuration.md)
- [Commands](commands.md)
- [Model Configuration](model-configuration.md)
- [S3 Integration](s3-integration.md)
- [Best Practices](best-practices.md)
- [Troubleshooting](troubleshooting.md)

## License

Porter is a commercial package licensed by Think Neverland. Each license is specific to a single production environment. For full licensing details, visit [Think Neverland License Page](https://thinkneverland.com/license).
