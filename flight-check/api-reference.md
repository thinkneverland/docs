# Flight Check API Reference

This document provides detailed information about Flight Check's API, including classes, methods, and configuration options.

## Core Classes

### FlightCheck Facade

The main entry point for using Flight Check functionality:

```php
use ThinkNeverland\FlightCheck\Facades\FlightCheck;
```

#### Methods

##### `checkFile()`

Check a file from a local path.

```php
public function checkFile(string $filePath, array $options = []): array
```

**Parameters:**

- `$filePath`: The path to the file
- `$options`: Additional options for the check (optional)
  - `check_resolution`: bool (default: true)
  - `check_colors`: bool (default: true)
  - `check_fonts`: bool (default: true)
  - `check_bleed`: bool (default: true)
  - `check_dielines`: bool (default: true)
  - `check_special_finishes`: bool (default: true)
  - `check_barcodes`: bool (default: true)
  - `check_compliance`: bool (default: true)

**Returns:** Array containing the preflight check report

**Throws:**

- `FileNotFoundException`: When the file does not exist
- `UnsupportedFileTypeException`: When the file type is not supported

---

##### `checkS3File()`

Check a file from an S3 path.

```php
public function checkS3File(string $s3Path, array $options = []): array
```

**Parameters:**

- `$s3Path`: The S3 path to the file
- `$options`: Additional options for the check (same as checkFile)

**Returns:** Array containing the preflight check report

**Throws:**

- `FileNotFoundException`: When the file does not exist in S3
- `UnsupportedFileTypeException`: When the file type is not supported
- `Exception`: When S3 storage is not configured

---

##### `checkFromUrl()`

Check a file from a pre-signed URL.

```php
public function checkFromUrl(string $url, array $options = []): array
```

**Parameters:**

- `$url`: The pre-signed URL to the file
- `$options`: Additional options for the check (same as checkFile)

**Returns:** Array containing the preflight check report

**Throws:**

- `FileNotFoundException`: When the file cannot be downloaded
- `UnsupportedFileTypeException`: When the file type is not supported

---

##### `batchCheck()`

Batch check multiple files.

```php
public function batchCheck(array $files, array $options = []): array
```

**Parameters:**

- `$files`: Array of file paths, S3 paths, or URLs
- `$options`: Additional options for the check (same as checkFile)

**Returns:** Array containing:

- `reports`: Array of preflight check reports
- `errors`: Array of errors for failed checks

---

##### `formatReport()`

Format a report in a specific format.

```php
public function formatReport(array $report, string $format = 'json')
```

**Parameters:**

- `$report`: The preflight check report
- `$format`: The format to return ('json', 'xml', 'summary')

**Returns:** The formatted report in the specified format

---

##### `applyCorrections()`

Apply automatic corrections to a file.

```php
public function applyCorrections(string $filePath, array $corrections, string $outputPath): array
```

**Parameters:**

- `$filePath`: The path to the file
- `$corrections`: Array of corrections to apply:

  ```php
  [
      'convert_rgb_to_cmyk' => bool,
      'flatten_transparencies' => bool,
      'remove_non_printable_layers' => bool,
      'standardize_overprint' => bool,
      'fix_dieline_colors' => bool,
  ]
  ```

- `$outputPath`: The path to save the corrected file

**Returns:** Array containing the correction report

**Throws:**

- `FileNotFoundException`: When the file does not exist
- `UnsupportedFileTypeException`: When the file type is not supported

## File Analyzers

### BaseAnalyzer

Abstract base class for all file analyzers.

```php
abstract class BaseAnalyzer
{
    protected string $filePath;
    protected array $config;
    protected array $report = [];

    public function analyze(array $options = []): array;
    public function applyCorrections(array $corrections, string $outputPath): array;
}
```

### Specific Analyzers

#### PdfAnalyzer

Analyzes PDF files.

```php
class PdfAnalyzer extends BaseAnalyzer
{
    protected function checkResolution(): void;
    protected function checkColors(): void;
    protected function checkFonts(): void;
    protected function checkBleed(): void;
    protected function checkLayers(): void;
    protected function checkSpecialFinishes(): void;
    protected function checkBarcodes(): void;
    protected function checkCompliance(): void;
    protected function checkDielines(): void;
    protected function extractMetadata(): void;
}
```

#### AiAnalyzer

Analyzes Adobe Illustrator files.

```php
class AiAnalyzer extends BaseAnalyzer
{
    // Similar methods to PdfAnalyzer
}
```

#### EpsAnalyzer

Analyzes EPS files.

```php
class EpsAnalyzer extends BaseAnalyzer
{
    // Similar methods to PdfAnalyzer
}
```

#### PsAnalyzer

Analyzes PostScript files.

```php
class PsAnalyzer extends BaseAnalyzer
{
    // Similar methods to PdfAnalyzer
}
```

## Report Structure

### File Information

```php
'file' => [
    'name' => string,
    'path' => string,
    'size' => int,
    'type' => string,
    's3_path' => string|null,
    'url' => string|null,
]
```

### Resolution Information

```php
'dpi' => [
    'actual_dpi' => int,
    'actual_ppi' => int,
    'required_dpi' => int,
    'status' => string,
]
```

### Color Information

```php
'color' => [
    'modes' => array,
    'ink_coverage' => [
        'coated' => int,
        'uncoated' => int,
    ],
    'rgb_detected' => bool,
    'spot_colors' => array,
]
```

### Font Information

```php
'fonts' => [
    'embedded' => array,
    'missing' => array,
    'sizes' => [
        'min_positive' => int,
        'min_reversed' => int,
    ],
]
```

### Dieline Information

```php
'dielines' => [
    [
        'color' => string,
        'stroke_width_mm' => float,
        'stroke_width_inches' => float,
        'stroke_center_mm' => [
            'x' => float,
            'y' => float,
        ],
        'stroke_edges_mm' => [
            'outer_x' => float,
            'outer_y' => float,
        ],
        'dimensions' => [
            'width_mm' => float,
            'height_mm' => float,
            'width_inches' => float,
            'height_inches' => float,
        ],
    ],
]
```

### Issues Information

```php
'issues' => [
    [
        'message' => string,
        'severity' => string, // 'error', 'warning', 'info'
        'category' => string,
    ],
]
```

## Configuration Options

### Resolution Settings

```php
'dpi' => [
    'min' => int,
    'line_art' => int,
    'check_compression_artifacts' => bool,
]
```

### Color Settings

```php
'color' => [
    'allowed_modes' => array,
    'max_ink_coverage' => array,
    'auto_convert_rgb' => bool,
    'check_rich_black' => bool,
    'check_overprint' => bool,
]
```

### Font Settings

```php
'fonts' => [
    'require_embedded' => bool,
    'min_size' => array,
]
```

### Bleed Settings

```php
'bleed' => [
    'min_bleed_mm' => float,
    'min_bleed_inches' => float,
    'safe_margin_mm' => float,
    'safe_margin_inches' => float,
]
```

### Storage Settings

```php
'storage' => [
    'disk' => string,
    's3' => [
        'enabled' => bool,
        'bucket' => string,
        'region' => string,
        'key' => string,
        'secret' => string,
    ],
]
```

## Error Handling

### Exceptions

- `FileNotFoundException`: Thrown when a file cannot be found
- `UnsupportedFileTypeException`: Thrown when the file type is not supported
- `Exception`: Thrown for general errors

### Error Categories

- `resolution`: Resolution-related issues
- `color`: Color-related issues
- `font`: Font-related issues
- `bleed`: Bleed-related issues
- `dieline`: Dieline-related issues
- `compliance`: Standards compliance issues
- `special_finishes`: Special finish-related issues
- `barcode`: Barcode-related issues

### Severity Levels

- `error`: Critical issues that must be fixed
- `warning`: Issues that should be reviewed
- `info`: Informational messages

## Best Practices

1. **Error Handling**

   ```php
   try {
       $report = FlightCheck::checkFile($filePath);
   } catch (FileNotFoundException $e) {
       // Handle file not found
   } catch (UnsupportedFileTypeException $e) {
       // Handle unsupported file type
   } catch (\Exception $e) {
       // Handle other errors
   }
   ```

2. **Batch Processing**

   ```php
   $results = FlightCheck::batchCheck($files);
   foreach ($results['reports'] as $report) {
       // Process successful reports
   }
   foreach ($results['errors'] as $error) {
       // Handle errors
   }
   ```

3. **Report Handling**

   ```php
   $report = FlightCheck::checkFile($filePath);
   
   // Get different formats
   $json = FlightCheck::formatReport($report, 'json');
   $xml = FlightCheck::formatReport($report, 'xml');
   $summary = FlightCheck::formatReport($report, 'summary');
   ```
