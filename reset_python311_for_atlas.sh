#!/bin/bash
set -e

echo "============================================================"
echo "ATLAS Mac Python 3.11 reset + clean reinstall"
echo "============================================================"

echo ""
echo "[1/10] Show current python commands"
which python3 || true
which python || true
python3 --version || true
python --version || true

echo ""
echo "[2/10] Remove old project virtual environments"
rm -rf ~/ATLAS/ATLAS-ARM64/venv || true
rm -rf ~/ATLAS/ATLAS-X64/venv || true
rm -rf ~/ATLAS/ATLAS-UNIVERSAL/venv || true

echo ""
echo "[3/10] Remove old build folders"
rm -rf ~/ATLAS/ATLAS-ARM64/build ~/ATLAS/ATLAS-ARM64/dist || true
rm -rf ~/ATLAS/ATLAS-X64/build ~/ATLAS/ATLAS-X64/dist || true
rm -rf ~/ATLAS/ATLAS-UNIVERSAL/build ~/ATLAS/ATLAS-UNIVERSAL/dist || true

echo ""
echo "[4/10] Uninstall Homebrew python@3.11 if present"
if command -v brew >/dev/null 2>&1; then
  brew uninstall --ignore-dependencies python@3.11 || true
  brew cleanup || true
else
  echo "Homebrew not found, skipping brew uninstall"
fi

echo ""
echo "[5/10] Remove python.org Python 3.11 framework install if present"
sudo rm -rf /Library/Frameworks/Python.framework/Versions/3.11 || true
sudo rm -f /usr/local/bin/python3.11 || true
sudo rm -f /usr/local/bin/pip3.11 || true
sudo rm -f /usr/local/bin/idle3.11 || true
sudo rm -f /usr/local/bin/pydoc3.11 || true
sudo rm -f /usr/local/bin/2to3-3.11 || true

echo ""
echo "[6/10] Clean old PATH entries from shell profiles"
for f in ~/.zprofile ~/.zshrc ~/.bash_profile ~/.bashrc; do
  if [ -f "$f" ]; then
    cp "$f" "$f.bak_atlas_python_reset"
    python3 - <<PY
from pathlib import Path
p = Path("$f")
text = p.read_text()
lines = text.splitlines()
filtered = []
for line in lines:
    s = line.strip()
    if '/Library/Frameworks/Python.framework/Versions/3.11/bin' in s:
        continue
    if '/opt/homebrew/bin' in s and 'python' in s.lower():
        continue
    filtered.append(line)
p.write_text("\n".join(filtered) + ("\n" if filtered else ""))
print("Cleaned:", p)
PY
  fi
done

echo ""
echo "[7/10] Download official python.org Python 3.11 installer"
cd ~
rm -f python-3.11.9-macos11.pkg
curl -L -o python-3.11.9-macos11.pkg https://www.python.org/ftp/python/3.11.9/python-3.11.9-macos11.pkg

echo ""
echo "[8/10] Install official python.org Python 3.11"
sudo installer -pkg ~/python-3.11.9-macos11.pkg -target /

echo ""
echo "[9/10] Add python.org Python 3.11 to PATH"
touch ~/.zprofile
grep -q '/Library/Frameworks/Python.framework/Versions/3.11/bin' ~/.zprofile || \
echo 'export PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:$PATH"' >> ~/.zprofile

export PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:$PATH"
hash -r

echo ""
echo "[10/10] Verify clean install"
which python3
python3 --version
file /Library/Frameworks/Python.framework/Versions/3.11/bin/python3 || true

echo ""
echo "============================================================"
echo "Python reset complete"
echo "============================================================"
echo ""
echo "Next commands to prepare ATLAS-UNIVERSAL:"
echo "cd ~/ATLAS/ATLAS-UNIVERSAL"
echo "python3 -m venv venv"
echo "source venv/bin/activate"
echo "which python"
echo "python -m pip install --upgrade pip setuptools wheel"
echo "pip install -r requirements.txt"
echo "pip install pyinstaller==6.3.0 pillow"
echo "rm -rf build dist"
echo "pyinstaller --clean --noconfirm ATLAS-UNIVERSAL.spec"
