#!/bin/bash
#!/bin/sh

# Coded By Xnuvers007 don't modified without Credits

# For Windows Version , will be soon

mkdir -p sndcpy
wget -P sndcpy/ https://github.com/rom1v/sndcpy/releases/download/v1.1/sndcpy-v1.1.zip
unzip sndcpy/sndcpy-v1.1.zip -d sndcpy/
cd sndcpy/
chmod +x sndcpy
./sndcpy
