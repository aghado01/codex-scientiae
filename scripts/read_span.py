#!/usr/bin/env python3
"""
read_span.py

Reads a specific byte-offset range from a file and prints it to stdout.
This allows tools or assistants to load only target sections of a document
without needing to ingest the entire file.

Usage:
  python scripts/read_span.py --file <file_path> --start <start_byte> --end <end_byte>
"""

import sys
import argparse
from pathlib import Path

def read_span(file_path: Path, start_byte: int, end_byte: int):
    if not file_path.exists() or not file_path.is_file():
        print(f"Error: File '{file_path}' does not exist or is not a file.", file=sys.stderr)
        sys.exit(1)
        
    file_size = file_path.stat().st_size
    if start_byte < 0 or start_byte >= file_size:
        print(f"Error: Start byte {start_byte} is out of bounds (file size: {file_size}).", file=sys.stderr)
        sys.exit(1)
        
    if end_byte < start_byte:
        print(f"Error: End byte {end_byte} cannot be less than start byte {start_byte}.", file=sys.stderr)
        sys.exit(1)
        
    # Cap end_byte to EOF
    if end_byte >= file_size:
        end_byte = file_size - 1
        
    length = end_byte - start_byte + 1
    
    with file_path.open('rb') as f:
        f.seek(start_byte)
        chunk = f.read(length)
        
    # Decode as UTF-8, replacing invalid sequences gracefully
    decoded = chunk.decode('utf-8', errors='replace')
    sys.stdout.write(decoded)
    # Ensure there's a trailing newline if none exists
    if not decoded.endswith('\n'):
        sys.stdout.write('\n')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Read a specific byte-offset range from a file.")
    parser.add_argument("--file", "-f", required=True, help="Path to the file to read.")
    parser.add_argument("--start", "-s", type=int, required=True, help="Start byte offset (0-based, inclusive).")
    parser.add_argument("--end", "-e", type=int, required=True, help="End byte offset (0-based, inclusive).")
    
    args = parser.parse_args()
    read_span(Path(args.file), args.start, args.end)
