# Flight Check Configuration Guide

This guide provides detailed information about configuring Flight Check for your specific needs. The configuration file `config/flightcheck.php` contains all available settings.

## Configuration File Structure

### Resolution & Image Quality

```php
'dpi' => [
    // Minimum DPI for images
    'min' => 300,
    
    // Minimum DPI for line art
    'line_art' => 1200,
    
    // Check for compression artifacts
    'check_compression_artifacts' => true,
],
```

### Color & Ink Management

```php
'color' => [
    // Allowed color modes
    'allowed_modes' => ['CMYK', 'Spot'],
    
    // Maximum ink coverage settings
    'max_ink_coverage' => [
        'coated' => 300,   // Maximum for coated paper (%)
        'uncoated' => 240, // Maximum for uncoated paper (%)
    ],
    
    // Color conversion settings
    'auto_convert_rgb' => true,
    'check_rich_black' => true,
    'check_overprint' => true,
],
```

### Fonts & Text

```php
'fonts' => [
    // Require all fonts to be embedded
    'require_embedded' => true,
    
    // Minimum font size requirements
    'min_size' => [
        'positive' => 5, // Minimum size for positive text (pt)
        'reversed' => 7, // Minimum size for reversed text (pt)
    ],
],
```

### Bleed, Margins & Trim

```php
'bleed' => [
    // Bleed settings
    'min_bleed_mm' => 3,
    'min_bleed_inches' => 0.125,
    
    // Safety margin settings
    'safe_margin_mm' => 6,
    'safe_margin_inches' => 0.25,
    
    // Trim mark settings
    'check_trim_marks' => true,
],
```

### Layers & Transparency

```php
'layers' => [
    // Transparency settings
    'check_transparency' => true,
    'auto_flatten' => true,
    
    // Layer checks
    'check_hidden_layers' => true,
],
```

### Special Finishes

```php
'special_finishes' => [
    // Special finish detection
    'check_spot_varnish' => true,
    'check_embossing' => true,
    'check_foil' => true,
],
```

### Barcode & QR Code Validation

```php
'barcodes' => [
    // Barcode quality settings
    'check_resolution' => true,
    'check_contrast' => true,
    'check_quiet_zones' => true,
],
```

### File Compliance & Standards

```php
'compliance' => [
    // Compliance standards to check
    'standards' => ['PDF/X-1a', 'PDF/X-4'],
    
    // RIP compatibility check
    'check_rip_compatibility' => true,
],
```

### Dieline Settings

```php
'dieline' => [
    // Dieline detection settings
    'detect_colors' => ['Dieline', 'CutContour', 'PerfCut', 'Die'],
    'calculate_stroke_center' => true,
    'calculate_stroke_edges' => true,
    'detect_multiple_dielines' => true,
    
    // Auto-fix settings
    'auto_fix' => true,
    'max_stroke_width_mm' => 0.25,
],
```

### Auto-Correction Features

```php
'auto_correction' => [
    // Automatic correction settings
    'convert_rgb_to_cmyk' => true,
    'flatten_transparencies' => true,
    'remove_non_printable_layers' => true,
    'standardize_overprint' => true,
    'fix_dieline_colors' => true,
],
```

### Output Settings

```php
'output' => [
    // Output format settings
    'format' => ['json', 'xml', 'summary'],
    
    // Error threshold level
    'error_threshold' => 'fail', // fail, error, warning
    
    // Output unit settings
    'units' => ['mm', 'cm', 'inches'],
],
```

### Storage Settings

```php
'storage' => [
    // Default storage settings
    'disk' => 'local',
    
    // S3 configuration
    's3' => [
        'enabled' => false,
        'bucket' => '',
        'region' => '',
        'key' => '',
        'secret' => '',
    ],
],
```

### Processing Settings

```php
'processing' => [
    // Batch processing settings
    'batch_size' => 10,
    
    // Processing timeout
    'timeout' => 300,
    
    // Temporary directory
    'temp_directory' => 'app/temp/flightcheck',
],
```

## Configuration Best Practices

### 1. Resolution Settings

- Set appropriate DPI based on print method:
  - Digital Print: 300 DPI minimum
  - Offset Print: 300-350 DPI
  - Large Format: 150-300 DPI
  - Line Art: 1200 DPI minimum

### 2. Color Management

- Configure ink coverage limits:

  ```php
  'max_ink_coverage' => [
      'coated' => 300,    // Standard for coated stock
      'uncoated' => 240,  // Lower for uncoated stock
  ],
  ```

- Enable rich black checking:

  ```php
  'check_rich_black' => true,
  ```

- Configure overprint settings:

  ```php
  'check_overprint' => true,
  ```

### 3. Font Requirements

- Enable font embedding:

  ```php
  'fonts' => [
      'require_embedded' => true,
      'min_size' => [
          'positive' => 5,  // Minimum for regular text
          'reversed' => 7,  // Higher minimum for reversed text
      ],
  ],
  ```

### 4. Bleed Settings

- Set appropriate bleed for different products:

  ```php
  'bleed' => [
      'min_bleed_mm' => 3,        // Standard print
      'min_bleed_inches' => 0.125, // US measurements
      'safe_margin_mm' => 6,       // Text safety
  ],
  ```

### 5. Error Handling

- Configure error thresholds:

  ```php
  'output' => [
      'error_threshold' => 'fail',  // Strict checking
      // Or 'warning' for less strict
  ],
  ```

### 6. Storage Configuration

- For S3 integration:

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

### 7. Processing Settings

- Configure batch processing:

  ```php
  'processing' => [
      'batch_size' => 10,
      'timeout' => 300,
      'temp_directory' => 'app/temp/flightcheck',
  ],
  ```

## Environment Variables

For sensitive configuration values, you can use environment variables:

```env
FLIGHTCHECK_S3_BUCKET=your-bucket
FLIGHTCHECK_S3_REGION=your-region
FLIGHTCHECK_S3_KEY=your-key
FLIGHTCHECK_S3_SECRET=your-secret
```

## Configuration Validation

The package validates your configuration on startup. Common validation errors include:

- Invalid DPI values
- Missing required settings
- Invalid color mode settings
- Incorrect S3 credentials

## Configuration Caching

Flight Check caches the configuration for better performance. To clear the cache:

```bash
php artisan config:clear
```

## Custom Configuration

You can extend the default configuration by creating a custom configuration file:

```php
// config/flightcheck.php
return array_merge(
    require __DIR__ . '/flightcheck.php',
    [
        // Your custom settings
    ]
);
```

## Configuration Examples

### Digital Print Configuration

```php
return [
    'dpi' => [
        'min' => 300,
        'line_art' => 1200,
    ],
    'color' => [
        'allowed_modes' => ['CMYK'],
        'max_ink_coverage' => [
            'coated' => 300,
            'uncoated' => 240,
        ],
    ],
    'bleed' => [
        'min_bleed_mm' => 3,
        'safe_margin_mm' => 6,
    ],
];
```

### Packaging Configuration

```php
return [
    'dpi' => [
        'min' => 300,
        'line_art' => 1200,
    ],
    'color' => [
        'allowed_modes' => ['CMYK', 'Spot'],
        'max_ink_coverage' => [
            'coated' => 300,
            'uncoated' => 240,
        ],
    ],
    'dieline' => [
        'detect_colors' => ['Dieline', 'CutContour'],
        'max_stroke_width_mm' => 0.25,
    ],
    'special_finishes' => [
        'check_spot_varnish' => true,
        'check_embossing' => true,
    ],
];
```

## Environment-Specific Configuration

### Development

```php
'processing' => [
    'timeout' => 600,    // Longer timeout for debugging
    'batch_size' => 5,   // Smaller batch size
],
'output' => [
    'format' => ['json', 'summary'],  // More detailed output
],
```

### Production

```php
'processing' => [
    'timeout' => 300,     // Standard timeout
    'batch_size' => 20,   // Larger batch size
],
'output' => [
    'format' => ['json'], // Efficient output
],
```

### AWS Lambda

```php
'storage' => [
    'disk' => 's3',
    's3' => [
        'enabled' => true,
        // Use environment variables for credentials
        'bucket' => env('AWS_BUCKET'),
        'region' => env('AWS_REGION'),
    ],
],
```

## Security Considerations

1. **API Keys & Credentials**
   - Store sensitive data in environment variables
   - Never commit credentials to version control

2. **File Access**
   - Set appropriate permissions on temporary directories
   - Clean up temporary files after processing

3. **S3 Configuration**
   - Use IAM roles with minimal required permissions
   - Enable encryption for stored files

## Troubleshooting

### Common Issues

1. **Memory Limits**

   ```php
   'processing' => [
       'batch_size' => 5,  // Reduce for large files
   ],
   ```

2. **Timeout Issues**

   ```php
   'processing' => [
       'timeout' => 600,  // Increase for complex files
   ],
   ```

3. **Storage Problems**

   ```php
   'storage' => [
       'temp_directory' => 'app/temp/flightcheck',  // Ensure writable
   ],
   ```

## Next Steps

- Review the [API Reference](./api-reference.md)
- Explore [Advanced Features](./advanced-features.md)
- Check [Security Best Practices](./security.md)
