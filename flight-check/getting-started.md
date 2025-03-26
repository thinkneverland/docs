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
    'check_rich_black' => true,
    'check_overprint' => true,
],
```

### Bleed and Margins

```php
'bleed' => [
    'min_bleed_mm' => 3,
    'min_bleed_inches' => 0.125,
    'safe_margin_mm' => 6,
    'safe_margin_inches' => 0.25,
    'check_trim_marks' => true,
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
    "color": {
        "modes": ["CMYK"],
        "ink_coverage": {
            "coated": 280,
            "uncoated": 260
        },
        "rgb_detected": false,
        "spot_colors": []
    },
    "fonts": {
        "embedded": ["Helvetica", "Arial"],
        "missing": [],
        "sizes": {
            "min_positive": 6,
            "min_reversed": 8
        }
    },
    "dielines": [
        {
            "color": "Dieline",
            "stroke_width_mm": 0.25,
            "stroke_width_inches": 0.01,
            "stroke_center_mm": {
                "x": 105,
                "y": 148.5
            },
            "stroke_edges_mm": {
                "outer_x": 106.25,
                "outer_y": 149.75
            },
            "dimensions": {
                "width_mm": 210,
                "height_mm": 297,
                "width_inches": 8.27,
                "height_inches": 11.69
            }
        }
    ],
    "issues": [
        {
            "message": "Ink coverage exceeds limit for uncoated paper",
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
   - Ensure proper resolution (300 DPI for images, 1200 DPI for line art)
   - Include necessary bleed (3mm/0.125")
   - Embed all fonts
   - Set appropriate safety margins (6mm/0.25")

2. **Configuration**
   - Set appropriate thresholds for your print method
   - Configure error levels based on your requirements
   - Customize settings for your specific workflow
   - Enable auto-corrections where appropriate

3. **Processing**
   - Use batch processing for multiple files
   - Implement proper error handling
   - Clean up temporary files after processing
   - Monitor processing timeouts

4. **Integration**
   - Use appropriate storage options (local/S3)
   - Implement proper security measures
   - Handle reports appropriately
   - Set up monitoring and logging

## Troubleshooting

### Common Issues

1. **File Access Issues**
   - Check file permissions
   - Verify S3 credentials
   - Ensure valid URLs
   - Check disk space

2. **Processing Errors**
   - Check file format compatibility
   - Verify Imagick installation
   - Check memory limits
   - Monitor processing timeouts

3. **Report Issues**
   - Verify configuration settings
   - Check error thresholds
   - Review format specifications
   - Validate output formats

## Next Steps

- Explore the [API Reference](./api-reference.md)
- Learn about [Configuration Options](./configuration.md)
- Review [Security Best Practices](./security.md)
- Check [Contributing Guidelines](../CONTRIBUTING.md)
