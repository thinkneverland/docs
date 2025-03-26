# Getting Started with Flight Check

This guide will help you get up and running with Flight Check, showing you how to install, configure, and use the package for preflight checking of print files.

## Installation

1. Install the package via Composer:

```bash
composer require thinkneverland/flight-check
```

2. Publish the configuration file:

```bash
php artisan vendor:publish --tag=flightcheck-config
```

## Basic Configuration

The configuration file `config/flightcheck.php` contains all the settings for Flight Check. Here are the key sections you should configure:

### Resolution Settings

```php
'dpi' => [
    'min' => 300, // Minimum DPI for images
    'line_art' => 1200, // Minimum DPI for line art
    'check_compression_artifacts' => true,
],
```

### Color Management

```php
'color' => [
    'allowed_modes' => ['CMYK', 'Spot'],
    'max_ink_coverage' => [
        'coated' => 300,
        'uncoated' => 240,
    ],
    'auto_convert_rgb' => true,
],
```

### Bleed and Margins

```php
'bleed' => [
    'min_bleed_mm' => 3,
    'min_bleed_inches' => 0.125,
    'safe_margin_mm' => 6,
    'safe_margin_inches' => 0.25,
],
```

## Basic Usage

### Checking Local Files

```php
use ThinkNeverland\FlightCheck\Facades\FlightCheck;

// Check a single file
$report = FlightCheck::checkFile('/path/to/file.pdf');

// Format the report
$jsonReport = FlightCheck::formatReport($report, 'json');
$xmlReport = FlightCheck::formatReport($report, 'xml');
$summaryReport = FlightCheck::formatReport($report, 'summary');
```

### Checking S3 Files

1. Configure S3 in your `config/flightcheck.php`:

```php
'storage' => [
    'disk' => 's3',
    's3' => [
        'enabled' => true,
        'bucket' => 'your-bucket',
        'region' => 'your-region',
        'key' => 'your-key',
        'secret' => 'your-secret',
    ],
],
```

2. Check files from S3:

```php
// Check a file from S3
$report = FlightCheck::checkS3File('path/to/file.pdf');
```

### Checking Files from URLs

```php
// Check a file from a URL
$report = FlightCheck::checkFromUrl('https://example.com/file.pdf');
```

### Batch Processing

```php
// Check multiple files
$files = [
    '/path/to/file1.pdf',
    's3://bucket/path/to/file2.pdf',
    'https://example.com/file3.pdf',
];

$reports = FlightCheck::batchCheck($files);
```

## Understanding Reports

### Report Structure

```json
{
    "file": {
        "name": "example.pdf",
        "path": "/path/to/example.pdf",
        "size": 1024000,
        "type": "pdf"
    },
    "dpi": {
        "actual_dpi": 300,
        "actual_ppi": 300,
        "required_dpi": 300,
        "status": "pass"
    },
    "dielines": [
        {
            "color": "Dieline",
            "stroke_width_mm": 0.25,
            "dimensions": {
                "width_mm": 210,
                "height_mm": 297
            }
        }
    ],
    "issues": [
        {
            "message": "RGB images found",
            "severity": "warning",
            "category": "color"
        }
    ]
}
```

### Report Formats

1. **JSON Format**: Detailed, machine-readable format
2. **XML Format**: Alternative structured format
3. **Summary Format**: Human-readable summary

## Auto-Corrections

### Available Corrections

```php
$corrections = [
    'convert_rgb_to_cmyk' => true,
    'flatten_transparencies' => true,
    'remove_non_printable_layers' => true,
    'standardize_overprint' => true,
    'fix_dieline_colors' => true,
];

$correctionReport = FlightCheck::applyCorrections(
    '/path/to/file.pdf',
    $corrections,
    '/path/to/output.pdf'
);
```

## Best Practices

1. **File Preparation**
   - Use appropriate color spaces (CMYK/Spot)
   - Ensure proper resolution
   - Include necessary bleed
   - Embed all fonts

2. **Configuration**
   - Set appropriate thresholds
   - Configure error levels
   - Customize for your workflow

3. **Processing**
   - Use batch processing for multiple files
   - Implement error handling
   - Clean up temporary files

4. **Integration**
   - Use appropriate storage options
   - Implement proper security measures
   - Handle reports appropriately

## Troubleshooting

### Common Issues

1. **File Access Issues**
   - Check file permissions
   - Verify S3 credentials
   - Ensure valid URLs

2. **Processing Errors**
   - Check file format compatibility
   - Verify Imagick installation
   - Check memory limits

3. **Report Issues**
   - Verify configuration settings
   - Check error thresholds
   - Review format specifications

## Next Steps

- Explore the [API Reference](./api-reference.md)
- Learn about [Advanced Features](./advanced-features.md)
- Review [Configuration Options](./configuration.md)
- Check [Security Best Practices](./security.md)
