# 🛫 Flight Check

Flight Check is a powerful Laravel package designed for preflight checking of print files, ensuring your print-ready files meet industry standards and specifications. It supports multiple file formats including AI, EPS, PS, and PDF, making it an essential tool for print preparation workflows.

## 🎯 Key Features

### File Format Support

- **Adobe Illustrator (AI)**: Full support for AI files
- **Encapsulated PostScript (EPS)**: Complete EPS file analysis
- **PostScript (PS)**: Comprehensive PS file checking
- **Portable Document Format (PDF)**: In-depth PDF analysis

### Core Capabilities

- **Resolution Analysis**: Check DPI/PPI for images and line art
- **Color Management**: CMYK, spot color, and ink coverage validation
- **Font Verification**: Font embedding and size requirements
- **Bleed & Margins**: Bleed area and safety margin validation
- **Dieline Analysis**: Precise measurements and validation

### Advanced Features

- **Special Finishes**: Spot varnish, embossing, and foil detection
- **Barcode Validation**: Resolution and contrast checking
- **Compliance Checking**: PDF/X standards verification
- **Auto-Correction**: Automated fixes for common issues

### Deployment Options

- **Traditional Server**: Run on standard web servers
- **AWS Lambda**: Serverless deployment with S3 integration
- **API Integration**: RESTful API for system integration

## 🔧 System Requirements

- PHP 8.0 or higher
- Laravel 8.0 or higher
- Imagick PHP extension
- Fileinfo PHP extension
- AWS SDK (for S3 integration)

## 🎨 Print Industry Standards

Flight Check ensures compliance with key print industry standards:

1. **Resolution Requirements**
   - Minimum 300 DPI for images
   - 1200 DPI for line art
   - Compression artifact detection

2. **Color Standards**
   - CMYK and spot color validation
   - Ink coverage limits
   - Rich black specifications
   - Overprint settings

3. **Typography Standards**
   - Font embedding requirements
   - Minimum size requirements
   - Reversed text specifications

4. **Production Requirements**
   - Standard bleed specifications
   - Safety margin guidelines
   - Trim mark validation
   - Dieline specifications

## 🔍 Analysis Features

### Comprehensive File Analysis

- Metadata extraction (XMP, EXIF, ICC profiles)
- Embedded font detection
- Layer analysis
- Transparency detection

### Geometric Analysis

- Precise size calculations
- Metric and imperial measurements
- Dieline stroke measurements
- Bleed area calculations

### Quality Control

- Resolution verification
- Color space validation
- Font compliance checking
- Print standards compliance

### Automated Corrections

- RGB to CMYK conversion
- Transparency flattening
- Layer optimization
- Dieline standardization

## 🚀 Use Cases

1. **Print Service Providers**
   - Automate file checking
   - Standardize quality control
   - Reduce prepress time
   - Minimize printing errors

2. **Design Agencies**
   - Validate files before submission
   - Ensure print readiness
   - Maintain quality standards
   - Streamline workflows

3. **Publishing Houses**
   - Verify document specifications
   - Maintain consistency
   - Automate quality control
   - Optimize production

4. **Packaging Industry**
   - Validate dieline specifications
   - Check special finishes
   - Ensure color compliance
   - Verify barcode quality

## 🔐 Security Features

- Secure file handling
- AWS S3 integration
- Temporary file cleanup
- Access control options

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guide](../CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

Flight Check is open-source software licensed under the MIT license. See the [LICENSE](LICENSE.md) file for more details.
