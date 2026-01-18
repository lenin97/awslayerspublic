# AWS Lambda Layers for Document Processing

This repository contains **production-ready AWS Lambda Layers** designed for **document processing and conversion workflows** in serverless environments.

All layers are built using **Docker-based, reproducible build pipelines** to ensure compatibility with the **AWS Lambda Linux runtime** and to enable reuse across multiple Lambda functions.

---

## Architecture Overview

```mermaid
flowchart TD
    A[Client / Upstream Service] --> B[API Gateway]
    B --> C[AWS Lambda Function]
    C --> D[build-word-layer<br/>DOCX Parsing & Text Extraction]
    C --> E[lambda-poppler-layer<br/>PDF Rendering & Inspection]
    C --> F[Processed Output<br/>S3 / API Response]
```

### Diagram Explanation

The diagram illustrates a **serverless document processing pipeline** where **native Linux dependencies** are isolated into reusable **AWS Lambda Layers**.

- Client requests are handled through **API Gateway**
- A single Lambda function consumes multiple layers depending on document type
- Document-specific tooling is decoupled from application logic
- Processed outputs are returned via API or stored in **Amazon S3**

This design improves **reusability, security, and deployment simplicity**, while remaining within AWS Lambda runtime constraints.

---

## Included Layers

### 📦 build-word-layer

A Lambda Layer providing **Microsoft Word (.docx) document processing capabilities** for AWS Lambda.

**Purpose**
- Parse Word documents and extract structured text
- Enable document preprocessing in serverless workflows

**Key Features**
- Docker-built binaries for Lambda compatibility
- Minimal runtime footprint
- Clean separation between native dependencies and Lambda code

**Typical Use Cases**
- CV / résumé parsing
- Document validation pipelines
- Text extraction prior to NLP or AI processing

---

### 📦 lambda-poppler-layer

A Lambda Layer packaging **Poppler utilities** for PDF processing inside AWS Lambda.

**Purpose**
- Enable PDF inspection and high-quality rendering in serverless environments

**Key Features**
- Includes Poppler tools such as `pdftoppm` and `pdfinfo`
- Compiled specifically for the Lambda execution environment
- Optimised to reduce cold-start overhead

**Typical Use Cases**
- PDF to image conversion
- OCR preprocessing pipelines
- Secure document preview generation

---

## Publishing a Lambda Layer

This repository includes a **PowerShell script** to safely publish a pre-built Lambda Layer ZIP to AWS using the **AWS CLI**.

The script performs **validation, logging, and publishing** to ensure the layer is compatible with AWS Lambda requirements.

### Prerequisites

Before running the script, ensure:

- AWS CLI is installed and available in your `PATH`
- You have a configured AWS profile with permission to publish Lambda layers
- The layer ZIP file already exists (built via Docker or other tooling)
- You are running PowerShell with execution permissions enabled

### Configuration

At the top of the script, update the configuration section for each layer:

- `LayerName` — Name of the Lambda Layer in AWS  
- `LayerZip` — ZIP file containing the layer contents  
- `Description` — Short description of what the layer provides  
- `CompatibleRuntimes` — Python runtimes supported by the layer  
- `CompatibleArchitectures` — CPU architecture (e.g. `x86_64`)  
- `AwsProfile` — AWS CLI profile to use  
- `AwsRegion` — AWS region where the layer will be published  

Each layer should be published **independently** with its own configuration.

### What the Script Does

1. **Validates prerequisites**
   - Confirms the AWS CLI is installed

2. **Validates the ZIP structure**
   - Ensures the ZIP contains either:
     - `python/`
     - or `opt/python/`
   - This matches AWS Lambda Layer requirements

3. **Publishes the layer**
   - Uses `aws lambda publish-layer-version`
   - Sets compatible runtimes and architectures
   - Outputs the published layer version details

4. **Fails fast on errors**
   - Any validation or AWS error stops execution immediately

### Result

After successful execution:

- A new **Lambda Layer version** is created in AWS
- The layer can be attached to any Lambda function
- The layer becomes reusable across multiple services and environments

This approach ensures **repeatable, auditable, and CI/CD-friendly** Lambda Layer publishing.

---

## Why This Repository Matters

This project demonstrates practical experience with:

- AWS Lambda internals and runtime limitations
- Docker-based Linux binary compilation
- Infrastructure modularisation using Lambda Layers
- Serverless document processing at scale
- Production-ready cloud architecture design

The layers were designed with **real-world constraints** in mind, including:

- Lambda package size limits
- Cold start performance
- Reusability across multiple services
- CI/CD-friendly build pipelines

---

## Skills Highlighted

- AWS Lambda & Lambda Layers  
- Docker & Linux build environments  
- Serverless architecture design  
- Document processing workflows  
- Cloud-native infrastructure modularisation  

---

## Notes

If Mermaid diagrams are not rendered in your environment, the architecture is:

Client → API Gateway → Lambda  
Lambda → build-word-layer / lambda-poppler-layer  
Output → S3 or API response

---

## License

MIT License
