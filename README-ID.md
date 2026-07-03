# 📱 ScreenMirror — Tampilkan & Kendalikan Layar HP Android di Laptop

<div align="center">

**Lihat dan kendalikan layar HP Android kamu secara langsung di laptop — pakai kabel USB atau tanpa kabel (WiFi)!**

Mendukung Windows & Linux | USB / WiFi / Wireless Debugging | Dilengkapi Audio | Gratis & Open Source

[![GitHub Stars](https://img.shields.io/github/stars/Xnuvers007/ScreenMirror?style=for-the-badge&logo=github)](https://github.com/Xnuvers007/ScreenMirror/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/Xnuvers007/ScreenMirror?style=for-the-badge&logo=github)](https://github.com/Xnuvers007/ScreenMirror/network)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux-blue?style=for-the-badge)](https://github.com/Xnuvers007/ScreenMirror)

</div>

---

> 📘 **Panduan ini ditulis untuk semua orang, termasuk yang tidak memiliki latar belakang IT.**
> Ikuti setiap langkah dengan pelan dan teliti. Jika ada yang membingungkan, baca keterangan 💡 di bawah setiap langkah.

---

## 📖 Daftar Isi

| No | Bagian |
|----|--------|
| 1 | [Apa itu ScreenMirror?](#-apa-itu-screenmirror) |
| 2 | [Untuk Apa Ini Digunakan?](#-untuk-apa-ini-digunakan) |
| 3 | [Yang Perlu Disiapkan](#-yang-perlu-disiapkan) |
| 4 | [Kompatibilitas Perangkat](#-kompatibilitas-perangkat) |
| 5 | [TAHAP 1: Download & Ekstrak Program](#-tahap-1-download--ekstrak-program) |
| 6 | [TAHAP 2: Aktifkan USB Debugging di HP (WAJIB)](#-tahap-2-aktifkan-usb-debugging-di-hp-wajib) |
| 7 | [TAHAP 3: Install Alat Pendukung (Sekali Saja)](#-tahap-3-install-alat-pendukung-sekali-saja) |
| 8 | [TAHAP 4: Sambungkan HP ke Laptop](#-tahap-4-sambungkan-hp-ke-laptop) |
| 9 | [Tutorial: Koneksi via Kabel USB](#-tutorial-koneksi-via-kabel-usb) |
| 10 | [Tutorial: Koneksi via WiFi (Tanpa Kabel)](#-tutorial-koneksi-via-wifi-tanpa-kabel) |
| 11 | [Tutorial: Wireless Debugging (Android 11+)](#-tutorial-wireless-debugging-android-11) |
| 12 | [Tutorial: Penggunaan di Linux](#-tutorial-penggunaan-di-linux) |
| 13 | [Fitur-Fitur Unggulan](#-fitur-fitur-unggulan) |
| 14 | [Pintasan Keyboard Saat Mirroring](#-pintasan-keyboard-saat-mirroring) |
| 15 | [Tips Mengatasi Layar Patah-Patah (Lag)](#-tips-mengatasi-layar-patah-patah-lag) |
| 16 | [Keamanan: Apakah Ini Aman?](#-keamanan-apakah-ini-aman) |
| 17 | [Solusi Masalah Umum (Troubleshooting)](#-solusi-masalah-umum-troubleshooting) |
| 18 | [Tanya Jawab (FAQ)](#-tanya-jawab-faq) |
| 19 | [Struktur Folder Program](#-struktur-folder-program) |
| 20 | [Kredit & Ucapan Terima Kasih](#-kredit--ucapan-terima-kasih) |

---

## 🤔 Apa itu ScreenMirror?

**ScreenMirror** adalah program buatan [Xnuvers007](https://github.com/Xnuvers007) yang memungkinkan kamu untuk **menampilkan layar HP Android secara langsung di layar laptop atau komputer**.

Bayangkan seperti ini: apapun yang muncul di layar HP kamu, akan **muncul juga di layar laptop** secara real-time (langsung, tanpa jeda). Tidak hanya itu, kamu juga bisa **mengklik, mengetik, dan menggulir** layar HP menggunakan mouse dan keyboard laptop.

Program ini menggunakan teknologi bernama **ADB (Android Debug Bridge)** yang merupakan alat resmi dari Google/Android, sehingga sangat aman dan tidak memerlukan modifikasi apapun pada HP kamu.

> ✅ Tidak perlu root HP  
> ✅ Tidak perlu install aplikasi di HP  
> ✅ Gratis sepenuhnya  
> ✅ Kualitas gambar tinggi, bisa sampai 60 FPS  

---

## 🎯 Untuk Apa Ini Digunakan?

| Kegunaan | Penjelasan |
|----------|------------|
| 🎮 **Main Game di Layar Besar** | Nikmati game HP di monitor/laptop yang lebih besar dengan kontrol keyboard & mouse |
| 📊 **Presentasi** | Tampilkan konten HP ke audiens melalui layar laptop/proyektor |
| 📹 **Rekam Layar HP** | Simpan video layar HP langsung ke laptop dalam format MP4 berkualitas tinggi |
| 💻 **Produktivitas** | Balas chat, buka aplikasi, transfer file — semua dari laptop |
| 🛠️ **Pengembang Aplikasi** | Test dan debug aplikasi Android dengan cepat dari komputer |
| 📚 **Belajar Online** | Tampilkan layar HP ke laptop untuk screen share di Zoom/Google Meet |

---

## 📦 Yang Perlu Disiapkan

Sebelum mulai, pastikan kamu memiliki semua yang ada di daftar ini:

| Komponen | Spesifikasi Minimum | Keterangan |
|----------|--------------------|-----------| 
| **HP Android** | Android 5.0 (atau lebih baru) | Direkomendasikan Android 9+ untuk performa terbaik |
| **Laptop/PC Windows** | Windows 7/8/10/11 (64-bit) | 32-bit juga bisa, tapi 64-bit lebih disarankan |
| **Laptop/PC Linux** | Ubuntu 18.04+ / Debian / Mint / Kali | Distro berbasis Debian |
| **Kabel USB** | Kabel data (bukan charger biasa) | Kabel yang bisa transfer foto ke komputer ✓ |
| **Koneksi Internet** | Minimal untuk download awal | Hanya dibutuhkan sekali untuk download `scrcpy` |
| **WiFi (opsional)** | HP & Laptop di jaringan yang sama | Untuk koneksi tanpa kabel |

> ⚠️ **Perhatian soal Kabel USB:** Pastikan kamu menggunakan kabel yang bisa **transfer data**, bukan kabel yang hanya bisa **mengisi daya (charge)**. Caranya mudah: coba colok HP ke komputer, jika muncul pilihan "Transfer File" di HP, maka kabelnya bisa digunakan.

---

## ✅ Kompatibilitas Perangkat

### Berdasarkan Versi Android

| Versi Android | Nama | Fitur yang Tersedia |
|---------------|------|---------------------|
| Android 5.0 – 8.1 | Lollipop – Oreo | ⚠️ Dasar saja (mirror layar via USB) |
| Android 9 – 10 | Pie – Q | ✅ Penuh (USB + WiFi + audio) |
| Android 11 – 12 | R – S | ✅ Penuh + Wireless Debugging tanpa USB |
| Android 13 – 15+ | T – ke atas | ✅ Penuh + codec video terbaru (AV1) |

### Berdasarkan Merek HP (Cara Aktifkan Opsi Pengembang)

| Merek HP | Langkah untuk "Nomor Build" |
|----------|-----------------------------|
| **Samsung** | Pengaturan → Tentang Ponsel → Informasi Perangkat Lunak → Nomor Build |
| **Xiaomi / MIUI / HyperOS** | Pengaturan → Tentang Ponsel → Semua Spesifikasi → Versi MIUI/HyperOS |
| **Poco** | Pengaturan → Tentang Ponsel → Versi MIUI |
| **Oppo / ColorOS** | Pengaturan → Tentang Ponsel → Versi Build |
| **Realme / Realme UI** | Pengaturan → Tentang Ponsel → Versi Build |
| **Vivo / FunTouch** | Pengaturan → Tentang Ponsel → Versi Build |
| **OnePlus / OxygenOS** | Pengaturan → Tentang Ponsel → Versi Build |
| **Google Pixel / Stock Android** | Pengaturan → Tentang Ponsel → Nomor Build |
| **TECNO / Infinix / itel** | Pengaturan → Tentang Ponsel → Nomor Build |

---

## 📥 TAHAP 1: Download & Ekstrak Program

**Langkah ini hanya perlu dilakukan sekali.**

### Cara A: Download Langsung (Paling Mudah untuk Pemula)

1. Buka halaman utama repositori ini: **https://github.com/Xnuvers007/ScreenMirror**

2. Cari dan klik tombol hijau bertuliskan **`<> Code`** (biasanya ada di sebelah kanan atas halaman).

3. Pada menu yang muncul, klik **`Download ZIP`**.

4. Setelah proses download selesai, buka folder **`Downloads`** di laptopmu.

5. Temukan file bernama `ScreenMirror-main.zip`. **Klik kanan** file tersebut.

6. Pilih **`Extract All...`** (atau "Ekstrak Semua...").

7. Klik tombol **`Extract`**. Sebuah folder baru bernama `ScreenMirror-main` akan muncul.

8. Buka folder tersebut. Di sinilah file `run.bat` (Windows) atau `run.sh` (Linux) berada.

> 💡 **Jangan jalankan programnya dari dalam file ZIP!** Kamu harus mengekstraknya (mengeluarkannya dari ZIP) terlebih dahulu ke sebuah folder biasa, barulah bisa dijalankan.

### Cara B: Menggunakan Git (Untuk yang Sudah Familiar)

```bash
git clone https://github.com/Xnuvers007/ScreenMirror.git
cd ScreenMirror
```

---

## 🔓 TAHAP 2: Aktifkan USB Debugging di HP (WAJIB)

> 🗣️ **Apa itu USB Debugging?**  
> USB Debugging adalah fitur tersembunyi di HP Android yang khusus untuk pengembang aplikasi. Dengan mengaktifkannya, laptop dapat "berbicara" dengan HP melalui kabel USB maupun WiFi. **Fitur ini sangat aman** dan tidak akan merusak HP kamu. Kamu bisa menonaktifkannya kembali kapan saja setelah selesai.

### Langkah A: Aktifkan Mode Pengembang (Developer Mode)

Mode Pengembang adalah menu tersembunyi yang perlu "dibuka kuncinya" terlebih dahulu.

1. Buka aplikasi **Pengaturan** (ikon gerigi ⚙️) di HP kamu.

2. Gulir ke paling bawah dan ketuk **"Tentang Ponsel"** (About Phone).

3. Cari tulisan **"Nomor Build"** (Build Number). Lihat tabel di atas untuk merek HP-mu.

4. **Ketuk tulisan "Nomor Build" sebanyak 7 kali berturut-turut** dengan cepat.
   - Jika dimintai PIN/Pola HP, masukkan terlebih dahulu.
   - Saat proses mengetuk, akan muncul hitungan mundur: *"Kamu tinggal 3 langkah lagi..."*

5. ✅ Berhasil! Akan muncul pesan: **"Anda sekarang seorang pengembang!"**

### Langkah B: Aktifkan USB Debugging

Setelah Mode Pengembang aktif, sekarang aktifkan USB Debugging di dalamnya.

1. Kembali ke halaman utama **Pengaturan**.

2. Cari menu **"Opsi Pengembang"** (Developer Options). Biasanya ada di:
   - Bagian paling bawah daftar menu Pengaturan, **ATAU**
   - Di dalam menu "Sistem" atau "Pengaturan Tambahan"

3. Masuk ke **Opsi Pengembang**. Pastikan tombol toggle di bagian atas sudah dalam keadaan **ON** (berwarna biru atau hijau).

4. Gulir ke bawah, cari opsi **"USB Debugging"** (bisa juga disebut "Debug USB").

5. Ketuk toggle tersebut untuk mengaktifkannya. Akan muncul jendela peringatan.

6. Ketuk **"OK"** atau **"Izinkan"** untuk mengonfirmasi.

> 💡 **Tips:** Pada HP Samsung, opsi ini ada di: Pengaturan → Opsi Pengembang → Debugging → USB Debugging

### Langkah C: Izinkan Laptop Saat Pertama Kali Disambungkan

1. Hubungkan HP ke laptop menggunakan kabel USB.

2. Di layar HP akan muncul popup bertuliskan **"Izinkan Debugging USB?"** / **"Allow USB Debugging?"**

3. **Sangat penting:** Centang kotak kecil bertuliskan **"Selalu izinkan dari komputer ini"** / **"Always allow from this computer"**.

4. Ketuk **"Izinkan"** / **"Allow"**.

> ❓ **Tidak muncul popup?** Coba: Pengaturan → Opsi Pengembang → Cabut Otorisasi USB Debugging → lalu cabut dan sambungkan ulang kabel.

---

## 🛠️ TAHAP 3: Install Alat Pendukung (Sekali Saja)

Program ini membutuhkan aplikasi kecil bernama **scrcpy** (dibaca: "screen copy") agar bisa bekerja. Kita akan men-download dan menginstallnya secara otomatis melalui script.

**Pastikan laptop terkoneksi ke internet sebelum memulai langkah ini.**

1. Buka folder hasil ekstrak dari Tahap 1.

2. Cari file bernama **`run.bat`**, lalu **klik dua kali** untuk menjalankannya.

3. Jika muncul jendela peringatan dari Windows (Windows Defender / UAC) bertuliskan *"Windows Defender SmartScreen mencegah aplikasi..."*, klik **"More info"** (Informasi Selengkapnya) lalu klik **"Run anyway"** (Tetap Jalankan).
   > 💡 Peringatan ini muncul karena file `.bat` belum pernah dijalankan di laptop kamu sebelumnya. Ini normal dan aman.

4. Sebuah jendela hitam (Command Prompt) akan muncul. Ketik **`1`** untuk memilih Bahasa Indonesia, lalu tekan `Enter`.

5. Menu utama akan muncul. Ketik **`8`** (Download & Install Dependensi), lalu tekan `Enter`.

6. Script akan otomatis mengecek versi `scrcpy` terbaru dari internet. Setelah selesai mengecek, ketik:
   - **`1`** jika laptop kamu 64-bit (hampir semua laptop modern adalah 64-bit)
   - **`2`** jika laptop kamu 32-bit

   > 💡 **Cara cek 32 atau 64-bit:** Klik kanan "Komputer" / "This PC" → Properti → lihat "Jenis Sistem" (System type). Jika tertulis "64-bit operating system", ketik `1`.

7. Download akan dimulai. Tunggu hingga selesai (biasanya 1–5 menit tergantung kecepatan internet).

8. Setelah selesai, tekan tombol apapun untuk kembali ke Menu Utama.

> 🌟 **Fitur Cerdas:** Folder `scrcpy` yang baru diinstall akan **otomatis didaftarkan ke Environment PATH Windows secara permanen**. Artinya, laptop kamu sekarang bisa menjalankan `scrcpy` dari mana saja tanpa perlu konfigurasi tambahan!

---

## 🔌 TAHAP 4: Sambungkan HP ke Laptop

Setelah semua persiapan selesai, kini saatnya menghubungkan HP ke laptop!

Ada **3 metode koneksi** yang bisa dipilih:

| Metode | Cocok Untuk | Kualitas |
|--------|------------|----------|
| 🔌 **Kabel USB** | Semua HP Android, koneksi paling stabil | ⭐⭐⭐⭐⭐ |
| 📡 **WiFi (TCP/IP)** | Semua HP Android, butuh USB sekali | ⭐⭐⭐⭐ |
| 📶 **Wireless Debugging** | HP Android 11 ke atas, 100% tanpa kabel | ⭐⭐⭐⭐ |

---

## 🔌 Tutorial: Koneksi via Kabel USB

Metode ini adalah yang **paling mudah dan paling stabil**. Sangat disarankan untuk pemula!

**Persiapan:** Pastikan HP sudah terhubung ke laptop via kabel USB dan USB Debugging sudah diaktifkan.

1. Di folder ScreenMirror, **klik dua kali `run.bat`**.

2. Ketik **`1`** (Indonesia) dan tekan `Enter`.

3. Di Menu Utama, ketik **`1`** (Koneksi USB) dan tekan `Enter`.

4. Script akan otomatis mendeteksi HP kamu dan menampilkan informasinya (nama HP, versi Android, dll.).

5. Kamu akan ditanya beberapa pertanyaan konfigurasi:
   - **Kode Enkripsi Video (Codec):** Tekan `Enter` saja untuk menggunakan H.264 (default, paling kompatibel).
   - **Bitrate (Kualitas Gambar):** Tekan `Enter` untuk menggunakan 8M (default). Semakin besar = semakin bagus tapi butuh lebih banyak bandwidth.
   - **Maks FPS:** Tekan `Enter` untuk 60 FPS (default). Lebih halus gerakannya.
   - **Maks Resolusi:** Tekan `Enter` untuk 1080p (default). Bisa diturunkan ke 720 jika lag.
   - **Buffer Video:** Tekan `Enter` (default 50ms sudah dioptimasi).
   - **Stay Awake (Layar HP tetap menyala):** Ketik `y` lalu `Enter` (sangat disarankan!).
   - **Rekam Layar ke File:** Ketik `n` lalu `Enter` jika tidak perlu merekam.
   - **Mode Hanya Tampil (No Control):** Ketik `n` lalu `Enter` agar bisa mengkontrol HP dari laptop.
   - **Matikan Layar HP:** Ketik `n` lalu `Enter` (pilih `y` jika ingin layar HP mati sementara mirror tetap jalan).

6. ✅ **Selesai!** Jendela baru akan muncul menampilkan layar HP kamu. Kamu bisa langsung mengontrolnya dengan mouse dan keyboard!

---

## 📡 Tutorial: Koneksi via WiFi (Tanpa Kabel)

Metode ini memungkinkan kamu **bebas bergerak** tanpa terganggu kabel. HP dan laptop harus berada di **WiFi yang sama**.

> ⚠️ **Catatan Penting:** Untuk pertama kali, kamu TETAP membutuhkan kabel USB untuk setup awal. Setelah setup selesai, kamu bisa mencabut kabelnya.

### Langkah-langkah:

**Step 1: Cari tahu Alamat IP HP kamu**

Alamat IP adalah "alamat rumah" HP kamu di jaringan WiFi. Cara menemukannya:
- Buka **Pengaturan** → **WiFi** → Ketuk nama WiFi yang sedang aktif → Lihat angka di bagian **"Alamat IP"** atau **"IP Address"**
- Contoh tampilan: `192.168.1.105` (angka akan berbeda-beda untuk setiap HP)

**Step 2: Jalankan Script**

1. Sambungkan HP ke laptop dengan kabel USB (hanya untuk step ini).
2. **Klik dua kali `run.bat`** dan pilih bahasa Indonesia.
3. Di Menu Utama, ketik **`2`** (Koneksi WiFi) dan tekan `Enter`.
4. Script akan mengaktifkan mode TCP/IP di HP.
5. Saat diminta "Masukkan alamat IP HP Android:", ketik alamat IP yang kamu temukan di Step 1, lalu tekan `Enter`. Contoh: `192.168.1.105`
6. Script akan mencoba tersambung.

**Step 3: Cabut Kabel & Nikmati**

7. Setelah koneksi berhasil, **cabut kabel USB** dari laptop.
8. Ikuti pertanyaan konfigurasi seperti pada metode USB.
9. ✅ **Selesai!** HP kamu terhubung ke laptop tanpa kabel!

> 💡 **Penting:** Setiap kali HP kamu di-restart atau putus dari WiFi, kamu perlu mengulangi step ini dari awal (karena IP HP bisa berubah). Kamu bisa menyimpan konfigurasi IP agar tidak perlu mengetiknya ulang setiap kali.

---

## 📶 Tutorial: Wireless Debugging (Android 11+)

Metode ini adalah yang **paling canggih** — 100% tanpa kabel dari awal sampai akhir! Namun, hanya tersedia untuk HP dengan Android 11 ke atas.

### Langkah A: Aktifkan Wireless Debugging di HP

1. Buka **Pengaturan** → **Opsi Pengembang**.
2. Gulir ke bawah, cari **"Wireless Debugging"** (mungkin juga disebut "Debug Nirkabel" atau "Debug Wi-Fi").
3. Aktifkan togglenya. Jika ada popup konfirmasi, ketuk **"Izinkan"**.
4. Ketuk pada nama **"Wireless Debugging"** (bukan togglenya, tapi tulisannya) untuk masuk ke sub-menunya.
5. Catat **alamat IP dan Port** yang tertera di bagian atas layar (contoh: `192.168.1.5:39465`). **Port ini untuk koneksi.**

### Langkah B: Pairing (Hanya Pertama Kali)

Sebelum bisa terhubung, laptop dan HP harus saling "berkenalan" dulu:

1. Di dalam menu Wireless Debugging HP, ketuk **"Pasangkan perangkat dengan kode pencocokan"**.
2. HP akan menampilkan:
   - **Alamat IP:Port untuk pairing** (contoh: `192.168.1.5:43521`) — ini BERBEDA dari port di atas!
   - **Kode 6 digit** (contoh: `123456`)
3. Di laptop, **klik dua kali `run.bat`** → pilih Indonesia → ketik **`3`** (Wireless Debugging).
4. Saat diminta, pilih opsi **pairing** lalu masukkan IP:Port pairing dan kode 6 digit dari HP.
5. ✅ Akan muncul konfirmasi **"Successfully paired"**. Pairing selesai!

> 💡 **Pairing hanya perlu dilakukan sekali!** Setelah paired, di lain waktu kamu tinggal langsung connect tanpa perlu pairing lagi — selama menggunakan laptop yang sama.

### Langkah C: Koneksi

1. Jalankan `run.bat` → Indonesia → **`3`** (Wireless Debugging).
2. Masukkan **IP dan Port koneksi** (bukan port pairing!) yang tertera di bagian atas layar Wireless Debugging HP.
3. ✅ **Selesai!** Jendela mirror akan muncul!

---

## 🐧 Tutorial: Penggunaan di Linux

Bagi pengguna Linux, prosesnya sedikit berbeda karena menggunakan Terminal.

### Langkah 1: Install Dependensi

Buka Terminal dan jalankan perintah berikut:

```bash
# Perbarui daftar paket
sudo apt-get update

# Install adb dan scrcpy
sudo apt-get install -y adb scrcpy

# Jika ingin versi scrcpy terbaru (opsional, menggunakan snap):
sudo snap install scrcpy

# Tambahkan diri kamu ke grup plugdev (penting agar USB dikenali)
sudo usermod -aG plugdev $USER

# Log out dan log in kembali agar perubahan grup berlaku
```

### Langkah 2: Jalankan Script

```bash
# Masuk ke folder ScreenMirror
cd ScreenMirror

# Beri izin eksekusi ke semua script
chmod +x *.sh Linux-ID/*.sh

# Jalankan versi Indonesia
cd Linux-ID && ./run.sh

# --- ATAU jalankan versi Inggris ---
# ./run.sh
```

### Langkah 3: Ikuti Instruksi di Layar

Menu di Terminal akan muncul sama seperti di Windows (Anda akan diminta memilih bahasa terlebih dahulu). Ikuti saja instruksinya!

> 💡 **Tips Linux:** Jika HP tidak terdeteksi, coba jalankan `adb kill-server && adb start-server` terlebih dahulu, lalu sambungkan ulang kabel USB.

---

## 🚀 Jalankan dari Mana Saja (Global Shortcut)

Tidak perlu repot-repot menavigasi ke folder `ScreenMirror` setiap kali ingin melakukan mirroring! Program ini sudah dilengkapi dengan fitur **Auto-Path** dan **Shortcut**.

### 🪟 Untuk Pengguna Windows
1. Setelah Anda menjalankan `run.bat` untuk pertama kalinya, folder program ini akan otomatis ditambahkan ke **Environment PATH** Windows Anda.
2. Di lain waktu, Anda cukup menekan tombol **`Windows + R`** di keyboard, ketik **`mulaism`** atau **`run`**, lalu tekan Enter.
3. Program ScreenMirror akan langsung terbuka seketika! (Bisa juga dipanggil dari CMD folder manapun dengan mengetik `mulaism`).

### 🐧 Untuk Pengguna Linux
1. Jalankan `run.sh` untuk pertama kalinya. Script akan otomatis menambahkan folder ini ke `~/.bashrc` dan `~/.zshrc`.
2. Setelah me-restart terminal Anda (atau membuka tab baru), Anda bisa langsung mengetik **`mulaism`** atau **`run.sh`** dari direktori mana saja!
3. **Alternatif Install ke Sistem:** Di dalam menu utama Linux (Pilihan No. 10), Anda bisa memilih opsi **Install Shortcut**. Ini akan membuatkan perintah `screenmirror` dan `mulaism` di dalam `/usr/local/bin` agar bisa diakses secara global oleh semua user di komputer Anda.

---

## ✨ Fitur-Fitur Unggulan

ScreenMirror dilengkapi dengan berbagai fitur canggih yang bisa kamu aktifkan dari menu interaktifnya:

### Fitur Utama

| Fitur | Penjelasan | Cara Mengaktifkan |
|-------|-----------|-------------------|
| **🔗 Koneksi USB** | Mirror lewat kabel, kualitas tertinggi | Menu → `1` |
| **📡 Koneksi WiFi** | Mirror nirkabel untuk semua Android | Menu → `2` |
| **📶 Wireless Debug** | Nirkabel penuh untuk Android 11+ | Menu → `3` |
| **📸 Screenshot** | Tangkap layar HP langsung ke laptop | Menu → `7` |
| **⬇️ Auto Install** | Download scrcpy versi terbaru otomatis | Menu → `8` |
| **💾 Simpan Konfigurasi** | Simpan pengaturan agar tidak diulang | Otomatis tersimpan |

### Fitur Saat Mirroring

| Fitur | Penjelasan |
|-------|-----------|
| **🌙 Stay Awake** | Mencegah layar HP mati selama mirroring aktif |
| **🎬 Rekam Layar** | Merekam tampilan HP ke file `.mp4` yang tersimpan di laptop |
| **🖥️ No Control Mode** | Kamu hanya bisa melihat, tapi tidak bisa mengontrol HP (cocok untuk presentasi) |
| **🌑 Matikan Layar HP** | Layar HP fisik mati, tapi gambar tetap tampil di laptop (hemat baterai HP) |
| **🔊 Audio Mirroring** | Suara HP mengalir ke speaker laptop (butuh sndcpy + VLC untuk Android < 11) |
| **🔲 Fullscreen** | Jendela mirror menjadi layar penuh di laptop |

### Konfigurasi Video yang Bisa Disesuaikan

| Parameter | Nilai Default | Nilai yang Bisa Dipilih | Penjelasan |
|-----------|--------------|------------------------|-----------|
| **Codec** | H.264 | H.264, H.265, AV1 | Format kompresi video |
| **Bitrate** | 8M | 2M – 50M | Kualitas gambar (lebih besar = lebih jernih) |
| **FPS** | 60 | 15, 30, 60 | Kelancaran gambar per detik |
| **Resolusi** | 1080p | 480, 720, 1080, 1440, Bebas | Ukuran gambar yang di-stream |
| **Buffer** | 50ms | Bebas | Jeda buffer untuk koneksi stabil |

---

## ⌨️ Pintasan Keyboard Saat Mirroring

Saat jendela mirror aktif, kamu bisa menggunakan pintasan keyboard berikut:

| Pintasan Keyboard | Fungsi |
|------------------|--------|
| `Ctrl` + `H` | Tekan tombol **Home** di HP |
| `Ctrl` + `B` | Tekan tombol **Back** (Kembali) di HP |
| `Ctrl` + `M` | Tekan tombol **Menu / Overview** di HP |
| `Ctrl` + `S` | **Ambil Screenshot** (disimpan di folder tempat menjalankan script) |
| `Ctrl` + `R` | **Putar** orientasi layar (portrait/landscape) |
| `Ctrl` + `F` | **Fullscreen** / Keluar dari fullscreen |
| `Ctrl` + `W` | **Tutup** jendela mirror |
| `Ctrl` + `N` | **Matikan layar** HP (tetapi mirror jalan terus) |
| `Ctrl` + `Shift` + `N` | **Nyalakan layar** HP |
| `MOD` + `↑` | **Naikkan volume** HP |
| `MOD` + `↓` | **Turunkan volume** HP |
| `MOD` + `P` | **Matikan/nyalakan layar** HP (toggle) |
| `F11` | **Fullscreen** (alternatif) |
| `MOD` + `Q` | **Keluar** dari scrcpy |

> 💡 **Catatan:** `MOD` biasanya adalah tombol `Alt` (kiri) di keyboard Windows. Scrcpy juga mendukung sentuhan multi-jari: tahan `Ctrl` sambil klik untuk simulasi pinch-to-zoom.

---

## ⚡ Tips Mengatasi Layar Patah-Patah (Lag)

Jika gambar yang muncul di laptop terlihat putus-putus atau tidak mulus, ikuti panduan ini:

### Cara Cepat Mengurangi Lag

| Langkah | Yang Perlu Diubah | Nilai Rekomendasi |
|---------|------------------|-------------------|
| 1️⃣ | Kurangi **Resolusi** | Dari 1080p → coba **720p** |
| 2️⃣ | Kurangi **Bitrate** | Dari 8M → coba **4M** atau **6M** |
| 3️⃣ | Kurangi **FPS** | Dari 60 → coba **30** |
| 4️⃣ | Ganti **Codec** | Dari H.265 → coba **H.264** |
| 5️⃣ | Ganti **Koneksi** | Dari WiFi → gunakan **kabel USB** |

### Penyebab Umum dan Solusinya

| Masalah | Kemungkinan Penyebab | Solusi |
|---------|---------------------|--------|
| Gambar patah-patah | Sinyal WiFi lemah | Dekatkan HP & laptop ke router, atau pakai USB |
| Warna tidak natural | Codec tidak cocok | Ganti codec ke H.264 |
| Koneksi sering putus | Port USB bermasalah | Ganti port USB, coba USB 3.0 |
| Gambar hitam | HP terkunci / layar mati | Buka kunci HP, aktifkan Stay Awake |
| Suara delay | Buffer terlalu kecil | Naikkan nilai buffer video |

---

## 🔒 Keamanan: Apakah Ini Aman?

Pertanyaan yang sangat wajar! Mari kita bahas secara jujur dan transparan:

### Cara Kerjanya

Saat ScreenMirror aktif, laptop mengirimkan **sinyal virtual** (sentuhan, ketikan keyboard) ke HP melalui protokol ADB. Ini disebut *Input Event Injection*. ADB adalah teknologi resmi dari Google yang digunakan oleh jutaan developer Android di seluruh dunia.

### Kapan Ini 100% Aman?

| ✅ Aman jika... | ⚠️ Hati-hati jika... |
|----------------|---------------------|
| Kamu menggunakan laptop milikmu sendiri | Menggunakan laptop orang lain atau publik |
| Koneksi via kabel USB langsung | Menggunakan WiFi publik (kafe, mall, bandara) |
| Di jaringan WiFi pribadi / rumah | Laptop bisa diakses orang lain dari jarak jauh |
| HP kamu tidak berisi data pihak lain | HP berisi data sensitif milik orang lain |

### Mode Aman untuk Presentasi: "No Control"

Jika kamu hanya ingin **menampilkan** layar HP tanpa risiko seseorang mengontrol HP kamu dari laptop, aktifkan mode **No Control** saat ditanya selama setup. Dalam mode ini:

- ✅ Layar HP tetap tampil di laptop
- ❌ Mouse dan keyboard laptop **tidak bisa** mengontrol HP sama sekali

```bash
# Perintah scrcpy manual untuk mode ini:
scrcpy --no-control
```

---

## 🔧 Solusi Masalah Umum (Troubleshooting)

### ❌ "Perangkat tidak terdeteksi" atau "No devices/emulators found"

```
✔ Pastikan kabel USB sudah terpasang dengan benar (coba cabut dan pasang ulang)
✔ Pastikan USB Debugging sudah diaktifkan di HP (lihat Tahap 2)
✔ Perhatikan layar HP — ketuk "Izinkan" jika ada popup yang muncul
✔ Coba restart ADB server: buka Command Prompt, ketik: adb kill-server && adb start-server
✔ Coba port USB yang berbeda di laptop (USB 3.0 lebih baik dari USB 2.0)
✔ Coba ganti kabel USB (kadang kabelnya yang bermasalah)
✔ Reset otorisasi: Pengaturan → Opsi Pengembang → Cabut Otorisasi USB Debugging → sambung ulang
```

### ❌ Jendela Mirror Tiba-Tiba Tertutup Sendiri

```
✔ Cek koneksi kabel USB (mungkin longgar)
✔ Pastikan HP tidak terkunci/layar tidak mati saat mirror dimulai
✔ Coba kurangi bitrate dan resolusi untuk mengurangi beban prosesor
✔ Periksa apakah HP kamu melempar notifikasi yang meminta konfirmasi
✔ Coba restart script dari awal
```

### ❌ Layar Patah-Patah / Sangat Lag

```
✔ Gunakan koneksi USB daripada WiFi (jauh lebih stabil)
✔ Kurangi resolusi (gunakan 720p)
✔ Kurangi bitrate (gunakan 4M)
✔ Kurangi FPS (gunakan 30)
✔ Ganti codec ke H.264 (paling kompatibel)
✔ Tutup aplikasi berat yang berjalan di background laptop
```

### ❌ "scrcpy tidak ditemukan" / "'scrcpy' is not recognized"

```
✔ Jalankan menu "8. Download & Install Dependensi" di script untuk menginstall otomatis
✔ Atau download manual dari: https://github.com/Genymobile/scrcpy/releases/latest
✔ Ekstrak file ZIP ke folder: C:\scrcpy-win64-vX.X\
✔ Restart script (run.bat) setelah instalasi
```

### ❌ Koneksi WiFi Gagal / Timeout

```
✔ Pastikan HP dan laptop terhubung ke WiFi yang SAMA (bukan hotspot berbeda)
✔ Cek alamat IP HP sudah benar (bisa berubah setelah restart)
✔ Sementara matikan Windows Defender Firewall untuk menguji
✔ Pastikan port 5555 tidak diblokir oleh antivirus atau firewall
✔ Coba sambung ulang HP ke WiFi, lalu cek IP-nya lagi
```

### ❌ Muncul "The system cannot find the path specified"

```
✔ Jalankan menu "8. Download & Install Dependensi" untuk menginstall ulang
✔ Pastikan scrcpy sudah terinstall dan path sudah terdaftar
✔ Coba restart laptop setelah instalasi agar PATH diperbarui
```

### ❌ Layar HP Tampil Hitam (Black Screen)

```
✔ Buka kunci HP terlebih dahulu, lalu coba lagi
✔ Matikan opsi "Jangan Simpan Aktivitas" di Opsi Pengembang
✔ Beberapa aplikasi banking/secure memblokir screenshot — ini normal
✔ Coba ganti codec
```

### ❌ Suara HP Tidak Keluar di Laptop

```
✔ Fitur audio otomatis bekerja di Android 11+ (menggunakan scrcpy terbaru)
✔ Untuk Android 10 ke bawah: install VLC dan gunakan sndcpy (menu terpisah)
✔ Cek volume laptop tidak di-mute
✔ Pastikan driver audio laptop bekerja normal
```

---

## ❓ Tanya Jawab (FAQ)

**T: Apakah HP saya perlu di-root?**  
J: **Tidak sama sekali.** ScreenMirror menggunakan ADB, yaitu alat debugging resmi Android dari Google. Tidak ada modifikasi pada sistem HP yang diperlukan.

**T: Apakah ini bisa digunakan di iPhone atau iPad?**  
J: **Tidak.** Program ini khusus untuk HP dan tablet berbasis Android saja. iPhone/iPad tidak mendukung ADB.

**T: Apakah ScreenMirror gratis?**  
J: **Ya, 100% gratis dan open source.** Kode sumbernya bisa dilihat langsung di halaman GitHub ini.

**T: Apakah data di HP saya aman?**  
J: **Ya**, selama kamu menggunakannya di perangkat dan jaringan pribadimu sendiri. Jangan pernah mengaktifkan USB Debugging di komputer milik orang lain atau di jaringan WiFi publik yang tidak kamu percaya.

**T: Apakah bisa digunakan saat HP sedang terkunci?**  
J: **Tidak.** Layar HP harus dalam keadaan aktif (tidak terkunci) agar mirroring bisa berjalan. Aktifkan fitur **Stay Awake** agar layar HP tidak mati otomatis saat mirror sedang aktif.

**T: Apakah bisa digunakan pakai hotspot dari HP sendiri?**  
J: **Ya!** Aktifkan hotspot di HP kamu, sambungkan laptop ke hotspot tersebut, lalu gunakan metode koneksi WiFi. Ini berguna jika tidak ada WiFi rumah.

**T: Apa bedanya metode WiFi biasa dan Wireless Debugging?**  
J: **Metode WiFi (TCP/IP)** bekerja di semua Android (versi 5+) tetapi membutuhkan kabel USB untuk setup pertama kali. **Wireless Debugging** tidak membutuhkan kabel sama sekali, namun hanya tersedia di Android 11 ke atas.

**T: Layar muncul tapi ada garis hitam di sisinya (letterboxing)?**  
J: Ini terjadi karena rasio aspek layar HP berbeda dengan jendela di laptop. Kamu bisa menekan `Ctrl+R` untuk memutar tampilan, atau atur ukuran jendela mirror secara manual.

**T: Apakah bisa menjalankan lebih dari satu HP sekaligus?**  
J: Ya, secara teknis bisa, tetapi harus melalui perintah manual di terminal menggunakan argumen `-s [device-serial]`. Fitur ini belum tersedia di menu interaktif ScreenMirror.

**T: Apakah bisa digunakan untuk streaming ke YouTube/Twitch?**  
J: ScreenMirror sendiri hanya menampilkan layar HP di laptop. Untuk streaming, kamu perlu menggunakan software streaming seperti OBS Studio yang menangkap jendela ScreenMirror sebagai sumber video.

---

## 🗂️ Struktur Folder Program

Ini adalah isi dari folder ScreenMirror yang kamu download:

```
ScreenMirror/
│
├── 📄 run.bat                  ← [WINDOWS] FILE UTAMA — Klik dua kali untuk mulai!
├── 📄 run.sh                   ← [LINUX/MAC] File utama versi Inggris
│
├── 📁 Windows-ID/              ← Script Windows dalam Bahasa Indonesia
│   ├── 📄 scrcpy.bat           ← Script utama mirroring (versi ID)
│   └── 📄 sndcpy.bat           ← Script audio mirroring (versi ID)
│
├── 📁 windows/                 ← Script Windows dalam Bahasa Inggris
│   ├── 📄 scrcpy.bat           ← Script utama mirroring (versi EN)
│   └── 📄 sndcpy.bat           ← Script audio mirroring (versi EN)
│
├── 📁 Linux-ID/                ← Script Linux dalam Bahasa Indonesia
│   ├── 📄 run.sh               ← Entry point Linux Indonesia
│   ├── 📄 screenmirror.sh      ← Script utama mirroring
│   ├── 📄 info.sh              ← Informasi sistem
│   └── 📄 sndcpy.sh            ← Audio mirroring
│
├── 📄 screenmirror.sh          ← Script utama Linux Inggris
├── 📄 sndcpy.sh                ← Audio mirroring Linux Inggris
├── 📄 README.md                ← Panduan ini (versi Inggris)
├── 📄 README-ID.md             ← Panduan ini (versi Indonesia)
└── 📄 LICENSE                  ← Lisensi MIT
```

### Di Mana Konfigurasi Tersimpan?

Script secara otomatis mengingat pengaturan terakhir kamu:

- **Windows:** `C:\Users\[NamaKamu]\AppData\Roaming\screenmirror_config.ini`
- **Linux:** `~/.screenmirror.conf`

Pengaturan yang disimpan:
- Alamat IP dan Port terakhir
- FPS, bitrate, resolusi, dan codec
- Pilihan fitur (Stay Awake, No Control, dll.)

Untuk melihat atau menghapus konfigurasi yang tersimpan, gunakan menu **`9`** (Lihat/Hapus Konfigurasi Tersimpan) di menu utama.

---

## 📝 Kredit & Ucapan Terima Kasih

Program ini menggunakan beberapa teknologi hebat dari developer lain:

| Teknologi | Pembuat | Tautan | Keterangan |
|-----------|---------|--------|------------|
| **scrcpy** | Genymobile (rom1v) | [github.com/Genymobile/scrcpy](https://github.com/Genymobile/scrcpy) | Engine utama untuk mirroring layar & audio |
| **sndcpy** | rom1v | [github.com/rom1v/sndcpy](https://github.com/rom1v/sndcpy) | Audio mirroring untuk Android < 11 |
| **ADB** | Google / Android Open Source Project | [developer.android.com](https://developer.android.com/tools/adb) | Protokol komunikasi Android |
| **ScreenMirror Scripts** | **Xnuvers007** | [github.com/Xnuvers007/ScreenMirror](https://github.com/Xnuvers007/ScreenMirror) | Script & antarmuka interaktif ini |

---

## 📜 Lisensi

Proyek ini dilisensikan di bawah **MIT License** — artinya kamu bebas menggunakannya, memodifikasinya, dan mendistribusikannya, **selama tetap mencantumkan kredit kepada pembuatnya**.

Lihat file [LICENSE](LICENSE) untuk detail lengkapnya.

---

## 🐛 Laporan Bug & Saran Fitur

Menemukan masalah atau punya ide untuk fitur baru?

- 🐛 **Laporkan Bug:** [Buka Issue Baru](https://github.com/Xnuvers007/ScreenMirror/issues/new)
- 💡 **Usulkan Fitur:** [Diskusi di Issues](https://github.com/Xnuvers007/ScreenMirror/issues)
- 🤝 **Kontribusi Kode:** [Kirim Pull Request](https://github.com/Xnuvers007/ScreenMirror/pulls)

---

<div align="center">

**Dibuat dengan ❤️ oleh [Xnuvers007](https://github.com/Xnuvers007)**

Jika program ini bermanfaat, jangan lupa klik tombol ⭐ **Star** di pojok kanan atas halaman ini ya! Itu adalah cara terbaik untuk mendukung pengembang.

</div>
