# 🚢 Porter

Porter is a powerful Laravel package that enables seamless database and S3 bucket management through export, import, and cloning operations. It provides a flexible and secure way to handle data transfers between environments.

## 🎯 Key Features

### Database Management

- **Export**: Create SQL dumps with customizable options
- **Import**: Import SQL files from local or S3 storage
- **Smart Configuration**: Model-based data handling
- **Expiration Control**: Automatic file cleanup

### S3 Integration

- **Bucket Cloning**: Transfer files between S3 buckets
- **Multiple Storage**: Support for primary and alternative S3 buckets
- **Multipart Uploads**: Efficient handling of large files
- **Custom Endpoints**: Support for custom S3-compatible services

### Security

- **Data Anonymization**: Randomize sensitive data during export
- **Selective Export**: Control which models and fields to include
- **IAM Integration**: Secure AWS credentials management
- **Temporary Links**: Expiring download URLs for exports

## 🔧 System Requirements

- PHP 8.1 or higher
- Laravel 10.0 or higher
- MySQL/MariaDB database
- AWS S3 compatible storage (optional)

## 🚀 Quick Start

1. Install via Composer:

```bash
composer require thinkneverland/porter
```

2. Run the installation command:

```bash
php artisan porter:install
```

3. Configure your S3 credentials in `.env`:

```env
AWS_BUCKET=your-bucket-name
AWS_DEFAULT_REGION=your-region
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
```

4. Export your database:

```bash
php artisan porter:export backup.sql
```

## 📚 Documentation

For detailed documentation, please visit our [GitBook documentation](https://thinkneverland.gitbook.io/porter/).

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guide](contributing.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

Porter is open-source software licensed under the MIT license. See the [LICENSE](LICENSE.md) file for more details.
