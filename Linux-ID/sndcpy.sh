#!/bin/bash
#!/bin/sh

# Dikode oleh Xnuvers007, Dilarang memodifikasi tanpa mencantumkan sumber aslinya

mkdir -p sndcpy
wget -P sndcpy/ https://github.com/rom1v/sndcpy/releases/download/v1.1/sndcpy-v1.1.zip
unzip sndcpy/sndcpy-v1.1.zip -d sndcpy/
cd sndcpy/
chmod +x sndcpy
./sndcpy
