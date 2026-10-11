#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status,
# if any variable is unreferenced, or if a piped command fails.
set -euo pipefail

# Default configuration
DPI=150
INPUT_PDF=""
OUTPUT_PDF=""
LOSSLESS=false

show_usage() {
    cat << EOF
Usage: $(basename "$0") -i input.pdf [options]

This script optimizes and reduces the file size of a raster/image-based PDF 
by downsampling the images to a target DPI and applying high-efficiency compression.

Options:
  -i, --input FILE      Input PDF file (required)
  -o, --output FILE     Output PDF file (default: <input>_compressed.pdf)
  -r, --resolution DPI  Target DPI resolution to downsample to (default: 150)
  -l, --lossless        Use lossless (Flate) compression instead of lossy (JPEG)
  -h, --help            Show this help message and exit

Dependencies:
  ghostscript must be installed.
  Install via: sudo apt install ghostscript
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -i|--input)
            INPUT_PDF="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_PDF="$2"
            shift 2
            ;;
        -r|--resolution)
            DPI="$2"
            shift 2
            ;;
        -l|--lossless)
            LOSSLESS=true
            shift 1
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo "Error: Unknown option '$1'" >&2
            show_usage >&2
            exit 1
            ;;
    esac
done

# Basic Validation
if [[ -z "$INPUT_PDF" ]]; then
    echo "Error: Input PDF file is required." >&2
    show_usage >&2
    exit 1
fi

if [[ ! -f "$INPUT_PDF" ]]; then
    echo "Error: Input file '$INPUT_PDF' does not exist." >&2
    exit 1
fi

# Ensure DPI is a valid positive integer
if ! [[ "$DPI" =~ ^[0-9]+$ ]] || [ "$DPI" -le 0 ]; then
    echo "Error: Resolution (DPI) must be a positive integer." >&2
    exit 1
fi

# Set default output filename if none was provided
if [[ -z "$OUTPUT_PDF" ]]; then
    filename=$(basename -- "$INPUT_PDF")
    basename="${filename%.*}"
    OUTPUT_PDF="${basename}_compressed.pdf"
fi

# Check for ghostscript dependency
if ! command -v gs &> /dev/null; then
    echo "Error: Ghostscript ('gs') is not installed." >&2
    echo "Please install it using:" >&2
    echo "  sudo apt update && sudo apt install ghostscript" >&2
    exit 1
fi

# Build Ghostscript Arguments
GS_ARGS=(
    -sDEVICE=pdfwrite
    -dCompatibilityLevel=1.4
    -dNOPAUSE
    -dBATCH
    -dQUIET
    
    # Enable downsampling for all image types
    -dDownsampleColorImages=true
    -dColorImageResolution="$DPI"
    -dColorImageDownsampleType=/Average
    
    -dDownsampleGrayImages=true
    -dGrayImageResolution="$DPI"
    -dGrayImageDownsampleType=/Average
    
    -dDownsampleMonoImages=true
    -dMonoImageResolution="$DPI"
    -dMonoImageDownsampleType=/Average
)

if [ "$LOSSLESS" = true ]; then
    echo "Compressing $INPUT_PDF to $OUTPUT_PDF (Lossless Flate, ${DPI} DPI)..."
    GS_ARGS+=(
        -dAutoFilterColorImages=false
        -dColorImageFilter=/FlateEncode
        
        -dAutoFilterGrayImages=false
        -dGrayImageFilter=/FlateEncode
    )
else
    echo "Compressing $INPUT_PDF to $OUTPUT_PDF (Lossy JPEG, ${DPI} DPI)..."
    GS_ARGS+=(
        -dAutoFilterColorImages=false
        -dColorImageFilter=/DCTEncode
        
        -dAutoFilterGrayImages=false
        -dGrayImageFilter=/DCTEncode
    )
fi

# Execute Ghostscript
gs "${GS_ARGS[@]}" -sOutputFile="$OUTPUT_PDF" "$INPUT_PDF"

# Compare file sizes
orig_size=$(stat -c %s "$INPUT_PDF")
new_size=$(stat -c %s "$OUTPUT_PDF")
savings_pct=$(( (orig_size - new_size) * 100 / orig_size ))

echo "Done!"
echo "Original Size:   $((orig_size / 1024)) KB"
echo "Compressed Size: $((new_size / 1024)) KB (${savings_pct}% reduction)"
