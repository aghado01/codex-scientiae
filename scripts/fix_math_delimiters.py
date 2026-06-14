import sys
import re
from pathlib import Path

def fix_file(path: Path):
    text = path.read_text(encoding='utf-8')
    orig_text = text
    
    # Replace \( and \) with $
    text = text.replace('\\(', '$').replace('\\)', '$')
    
    # Replace \[ and \] with $$
    text = text.replace('\\[', '$$').replace('\\]', '$$')
    
    # Fix double-wrapping of block math
    # Sometimes we get $$\n$$\ncontent\n$$\n$$
    text = re.sub(r'\$\$\n\s*\$\$', '$$', text)
    # Also clean up inline double wraps
    text = re.sub(r'\$\$\$\$', '$$', text)
    # And triple wraps like $$$ -> $$ or $?
    # If it was $$ $foo$ $$ -> block double wrap? Actually let's just do $$$$ -> $$
    
    # Find $$$
    # If it's inline like $$$foo$$$, it might become $foo$. 
    # But let's just stick to $$$$ -> $$ and $$$ -> $$.
    text = text.replace('$$$$', '$$')
    text = text.replace('$$$', '$$')

    if text != orig_text:
        path.write_text(text, encoding='utf-8')
        print(f"Fixed delimiters in {path.name}")

def main():
    target = Path("compendia/ph")
    if not target.exists():
        print(f"Error: {target} does not exist.")
        return
        
    for p in target.glob("*.md"):
        if p.name == "_contents.md":
            continue
        fix_file(p)
        
if __name__ == "__main__":
    main()
