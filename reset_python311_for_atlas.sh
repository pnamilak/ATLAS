#!/bin/bash
set -e

echo "=================================================="
echo "Fixing ATLAS universal build environment"
echo "=================================================="

# 1) Go to project root
cd ~/ATLAS

# 2) Remove only the bad universal venv and old build output
rm -rf ~/ATLAS/ATLAS-UNIVERSAL/venv
rm -rf ~/ATLAS/ATLAS-UNIVERSAL/build
rm -rf ~/ATLAS/ATLAS-UNIVERSAL/dist

# 3) Make sure old shell command cache is cleared
hash -r || true

# 4) Force python.org Python 3.11 to the front of PATH
export PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# 5) Verify we are NOT using Homebrew Python
which python3
python3 --version
file /Library/Frameworks/Python.framework/Versions/3.11/bin/python3

# 6) Go into universal folder
cd ~/ATLAS/ATLAS-UNIVERSAL

# 7) Create fresh venv using python.org Python explicitly
/Library/Frameworks/Python.framework/Versions/3.11/bin/python3 -m venv venv

# 8) Activate it
source venv/bin/activate

# 9) Verify this venv is the one being used
echo "python => $(which python)"
echo "pip    => $(which pip)"
python -c "import sys; print(sys.executable)"
pip -V

# 10) Upgrade packaging tools
python -m pip install --upgrade pip setuptools wheel

# 11) Install dependencies INSIDE this venv
python -m pip install -r requirements.txt
python -m pip install pyinstaller==6.3.0 pillow

# 12) Double-check PyInstaller and Python paths
echo "pyinstaller => $(which pyinstaller)"
pyinstaller --version
python -c "import sys; print('PYTHON EXE:', sys.executable)"
python -c "import struct; print(struct.__file__)"

# 13) Clean build again
rm -rf build dist

# 14) Run universal build
pyinstaller --clean --noconfirm ATLAS-UNIVERSAL.spec

# 15) Verify universal app
file dist/ATLAS.app/Contents/MacOS/ATLAS
lipo -info dist/ATLAS.app/Contents/MacOS/ATLAS
