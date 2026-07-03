# 📱 ScreenMirror — Display & Control Your Android Screen on Your Laptop

<div align="center">

**See and control your Android phone screen live on your laptop — via USB cable or wirelessly (WiFi)!**

Supports Windows & Linux | USB / WiFi / Wireless Debugging | With Audio | Free & Open Source

[![GitHub Stars](https://img.shields.io/github/stars/Xnuvers007/ScreenMirror?style=for-the-badge&logo=github)](https://github.com/Xnuvers007/ScreenMirror/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/Xnuvers007/ScreenMirror?style=for-the-badge&logo=github)](https://github.com/Xnuvers007/ScreenMirror/network)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux-blue?style=for-the-badge)](https://github.com/Xnuvers007/ScreenMirror)

</div>

---

> 📘 **This guide is written for everyone, including those with no IT background.**
> Follow each step slowly and carefully. If anything is confusing, read the 💡 tips below each step.

---

## 📖 Table of Contents

| No | Section |
|----|---------|
| 1 | [What is ScreenMirror?](#-what-is-screenmirror) |
| 2 | [What Can You Use It For?](#-what-can-you-use-it-for) |
| 3 | [What You Need to Prepare](#-what-you-need-to-prepare) |
| 4 | [Device Compatibility](#-device-compatibility) |
| 5 | [STEP 1: Download & Extract the Program](#-step-1-download--extract-the-program) |
| 6 | [STEP 2: Enable USB Debugging on Your Phone (REQUIRED)](#-step-2-enable-usb-debugging-on-your-phone-required) |
| 7 | [STEP 3: Install Required Tools (One-Time Setup)](#-step-3-install-required-tools-one-time-setup) |
| 8 | [STEP 4: Connect Your Phone to Laptop](#-step-4-connect-your-phone-to-laptop) |
| 9 | [Tutorial: USB Cable Connection](#-tutorial-usb-cable-connection) |
| 10 | [Tutorial: WiFi Connection (Wireless)](#-tutorial-wifi-connection-wireless) |
| 11 | [Tutorial: Wireless Debugging (Android 11+)](#-tutorial-wireless-debugging-android-11) |
| 12 | [Tutorial: Linux Usage](#-tutorial-linux-usage) |
| 13 | [Key Features](#-key-features) |
| 14 | [Keyboard Shortcuts While Mirroring](#-keyboard-shortcuts-while-mirroring) |
| 15 | [Tips to Fix Stuttering / Lag](#-tips-to-fix-stuttering--lag) |
| 16 | [Security: Is This Safe?](#-security-is-this-safe) |
| 17 | [Troubleshooting Common Issues](#-troubleshooting-common-issues) |
| 18 | [Frequently Asked Questions (FAQ)](#-frequently-asked-questions-faq) |
| 19 | [Project Folder Structure](#-project-folder-structure) |
| 20 | [Credits & Acknowledgements](#-credits--acknowledgements) |

---

## 🤔 What is ScreenMirror?

**ScreenMirror** is a program made by [Xnuvers007](https://github.com/Xnuvers007) that lets you **display your Android phone's screen live on your laptop or desktop computer**.

Think of it like this: everything that appears on your phone screen will **also appear on your laptop screen** in real-time (instantly, with no delay). Not only that, you can also **click, type, and scroll** on your phone using your laptop's mouse and keyboard.

This program uses a technology called **ADB (Android Debug Bridge)**, which is an official tool from Google/Android. It is very safe and requires absolutely no modification to your phone.

> ✅ No root required  
> ✅ No special app to install on your phone  
> ✅ Completely free  
> ✅ High-quality output, up to 60 FPS  

---

## 🎯 What Can You Use It For?

| Use Case | Description |
|----------|-------------|
| 🎮 **Play Games on a Big Screen** | Enjoy mobile games on a larger monitor with keyboard & mouse control |
| 📊 **Presentations** | Display your phone screen to an audience via laptop or projector |
| 📹 **Screen Recording** | Save your phone screen as a high-quality MP4 video directly on your laptop |
| 💻 **Productivity** | Reply to chats, open apps, transfer files — all from your laptop |
| 🛠️ **App Development** | Test and debug Android apps quickly from your computer |
| 📚 **Online Classes** | Share your phone screen on your laptop for Zoom/Google Meet screen sharing |

---

## 📦 What You Need to Prepare

Before you start, make sure you have everything on this list:

| Component | Minimum Requirement | Notes |
|-----------|--------------------|----|
| **Android Phone** | Android 5.0 or newer | Android 9+ recommended for best performance |
| **Windows Laptop/PC** | Windows 7/8/10/11 (64-bit) | 32-bit works too, but 64-bit is recommended |
| **Linux Laptop/PC** | Ubuntu 18.04+ / Debian / Mint / Kali | Debian-based distributions |
| **USB Cable** | Data cable (not charge-only) | A cable that can transfer photos to a computer ✓ |
| **Internet Connection** | Minimum for initial download | Only needed once to download `scrcpy` |
| **WiFi (optional)** | Phone & Laptop on the same network | For wireless connection |

> ⚠️ **Important Note About USB Cable:** Make sure you use a cable that can **transfer data**, not just one that charges. Easy test: plug your phone into the computer. If you see an option like "File Transfer" on your phone, the cable works!

---

## ✅ Device Compatibility

### By Android Version

| Android Version | Name | Features Available |
|----------------|------|-------------------|
| Android 5.0 – 8.1 | Lollipop – Oreo | ⚠️ Basic only (USB screen mirror) |
| Android 9 – 10 | Pie – Q | ✅ Full (USB + WiFi + audio) |
| Android 11 – 12 | R – S | ✅ Full + cable-free Wireless Debugging |
| Android 13 – 15+ | T – and above | ✅ Full + latest video codecs (AV1) |

### By Phone Brand (How to Find "Build Number")

| Phone Brand | Path to "Build Number" |
|------------|------------------------|
| **Samsung** | Settings → About Phone → Software Information → Build Number |
| **Xiaomi / MIUI / HyperOS** | Settings → About Phone → All Specs → MIUI/HyperOS Version |
| **Poco** | Settings → About Phone → MIUI Version |
| **Oppo / ColorOS** | Settings → About Phone → Build Version |
| **Realme / Realme UI** | Settings → About Phone → Build Version |
| **Vivo / FunTouch** | Settings → About Phone → Build Version |
| **OnePlus / OxygenOS** | Settings → About Phone → Build Number |
| **Google Pixel / Stock Android** | Settings → About Phone → Build Number |
| **TECNO / Infinix / itel** | Settings → About Phone → Build Number |

---

## 📥 STEP 1: Download & Extract the Program

**This step only needs to be done once.**

### Option A: Direct Download (Easiest for Beginners)

1. Open the main page of this repository: **https://github.com/Xnuvers007/ScreenMirror**

2. Find and click the green button that says **`<> Code`** (usually in the upper-right area of the page).

3. From the menu that appears, click **`Download ZIP`**.

4. Once the download is complete, open your laptop's **`Downloads`** folder.

5. Find the file named `ScreenMirror-main.zip`. **Right-click** on it.

6. Choose **`Extract All...`**.

7. Click the **`Extract`** button. A new folder called `ScreenMirror-main` will appear.

8. Open that folder. This is where the `run.bat` (Windows) or `run.sh` (Linux) file lives.

> 💡 **Do NOT run the program directly from inside the ZIP file!** You must extract it (unzip it) into a regular folder first, then run it from there.

### Option B: Using Git (For those familiar with it)

```bash
git clone https://github.com/Xnuvers007/ScreenMirror.git
cd ScreenMirror
```

---

## 🔓 STEP 2: Enable USB Debugging on Your Phone (REQUIRED)

> 🗣️ **What is USB Debugging?**  
> USB Debugging is a hidden feature in Android phones designed for developers. Enabling it allows your laptop to "communicate" with your phone via USB cable or WiFi. **It is completely safe** and does not harm your phone. You can disable it again anytime you want.

### Part A: Unlock the Hidden Menu (Developer Options)

Developer Options is a hidden menu that needs to be "unlocked" first.

1. Open the **Settings** app (⚙️) on your phone.

2. Scroll all the way down and tap **"About Phone"**.

3. Look for **"Build Number"**. Refer to the table above for your specific phone brand.

4. **Tap "Build Number" 7 times in a row** quickly.
   - If asked for your PIN/Pattern, enter it first.
   - You'll see a countdown: *"You are 3 steps away from being a developer..."*

5. ✅ Done! You'll see: **"You are now a developer!"**

### Part B: Enable USB Debugging

Now that Developer Mode is on, enable USB Debugging inside it.

1. Go back to the main **Settings** screen.

2. Find **"Developer Options"**. It's usually:
   - At the very bottom of the Settings list, **OR**
   - Inside "System" or "Additional Settings"

3. Open **Developer Options**. Make sure the toggle at the top is **ON** (blue or green).

4. Scroll down, find **"USB Debugging"**.

5. Tap the toggle to turn it on. A warning popup will appear.

6. Tap **"OK"** or **"Allow"** to confirm.

> 💡 **Tip:** On Samsung devices: Settings → Developer Options → Debugging → USB Debugging

### Part C: Authorize Your Laptop (First Time Connection)

1. Plug your phone into your laptop using a USB cable.

2. A popup will appear on your phone: **"Allow USB Debugging?"**

3. **Important:** Check the box that says **"Always allow from this computer"**.

4. Tap **"Allow"**.

> ❓ **No popup appeared?** Try: Settings → Developer Options → Revoke USB Debugging Authorizations → then unplug and reconnect the cable.

---

## 🛠️ STEP 3: Install Required Tools (One-Time Setup)

This program needs a small application called **scrcpy** (pronounced "screen copy") to work. We'll download and install it automatically through the script.

**Make sure your laptop is connected to the internet before starting this step.**

1. Open the folder from Step 1.

2. Find the file named **`run.bat`** and **double-click** it to run it.

3. If a Windows warning appears (Windows Defender / UAC) saying *"Windows protected your PC..."*, click **"More info"** and then **"Run anyway"**.
   > 💡 This warning appears because the `.bat` file hasn't been run on your laptop before. This is normal and safe.

4. A black window (Command Prompt) will open. Type **`2`** to choose English, then press `Enter`.

5. The main menu will appear. Type **`8`** (Download & Install Dependencies), then press `Enter`.

6. The script will automatically check for the latest `scrcpy` version online. Once checked, type:
   - **`1`** if your laptop is 64-bit (almost all modern laptops are 64-bit)
   - **`2`** if your laptop is 32-bit

   > 💡 **How to check 32 or 64-bit:** Right-click "This PC" → Properties → look for "System type". If it says "64-bit operating system", type `1`.

7. The download will begin. Wait until it finishes (usually 1–5 minutes depending on your internet speed).

8. Once done, press any key to return to the Main Menu.

> 🌟 **Smart Feature:** The downloaded `scrcpy` folder will be **automatically registered to Windows Environment PATH permanently**. This means your laptop can now run `scrcpy` from anywhere without any additional configuration!

---

## 🔌 STEP 4: Connect Your Phone to Laptop

Once all preparations are complete, it's time to connect your phone!

There are **3 connection methods** to choose from:

| Method | Best For | Quality |
|--------|----------|---------|
| 🔌 **USB Cable** | All Android phones, most stable | ⭐⭐⭐⭐⭐ |
| 📡 **WiFi (TCP/IP)** | All Android phones, USB needed once | ⭐⭐⭐⭐ |
| 📶 **Wireless Debugging** | Android 11+ only, 100% cable-free | ⭐⭐⭐⭐ |

---

## 🔌 Tutorial: USB Cable Connection

This is the **easiest and most stable** method. Highly recommended for beginners!

**Prerequisites:** Phone connected to laptop via USB cable, and USB Debugging enabled.

1. In the ScreenMirror folder, **double-click `run.bat`**.

2. Type **`2`** (English) and press `Enter`.

3. In the Main Menu, type **`1`** (USB Connection) and press `Enter`.

4. The script will automatically detect your phone and display its info (phone name, Android version, etc.).

5. You'll be asked a few configuration questions:
   - **Video Codec:** Press `Enter` to use H.264 (default, most compatible).
   - **Bitrate (Video Quality):** Press `Enter` for 8M (default). Higher = better quality but uses more bandwidth.
   - **Max FPS:** Press `Enter` for 60 FPS (default). Smoother motion.
   - **Max Resolution:** Press `Enter` for 1080p (default). Lower to 720 if you experience lag.
   - **Video Buffer:** Press `Enter` (default 50ms is already optimized).
   - **Stay Awake (Keep phone screen on):** Type `y` then `Enter` (highly recommended!).
   - **Record Screen to File:** Type `n` then `Enter` if you don't need recording.
   - **View-Only Mode (No Control):** Type `n` then `Enter` to allow laptop control of phone.
   - **Turn Phone Screen Off:** Type `n` then `Enter` (choose `y` if you want the phone screen off while mirroring continues).

6. ✅ **Done!** A new window will appear showing your phone's screen. You can now control it with your mouse and keyboard!

---

## 📡 Tutorial: WiFi Connection (Wireless)

This method lets you **move freely** without any cable in the way. Your phone and laptop must be on the **same WiFi network**.

> ⚠️ **Important Note:** For the very first time, you STILL need a USB cable for the initial setup. After that, you can unplug it.

### Steps:

**Step 1: Find Your Phone's IP Address**

An IP address is like your phone's "home address" on your WiFi network. Here's how to find it:
- Open **Settings** → **WiFi** → Tap the name of your active WiFi → Look for **"IP Address"**
- Example: `192.168.1.105` (the numbers will be different for each phone)

**Step 2: Run the Script**

1. Connect your phone to the laptop with a USB cable (only for this step).
2. **Double-click `run.bat`** and choose English.
3. In the Main Menu, type **`2`** (WiFi Connection) and press `Enter`.
4. The script will activate TCP/IP mode on your phone.
5. When asked for "Enter Android phone IP address:", type the IP you found in Step 1 and press `Enter`. Example: `192.168.1.105`
6. The script will attempt to connect.

**Step 3: Unplug the Cable & Enjoy**

7. Once connection is successful, **unplug the USB cable** from your laptop.
8. Follow the configuration questions just like the USB method.
9. ✅ **Done!** Your phone is now connected to your laptop wirelessly!

> 💡 **Important:** Every time your phone restarts or disconnects from WiFi, you'll need to repeat this process (because the IP address can change). Save the configuration so you don't have to retype it each time.

---

## 📶 Tutorial: Wireless Debugging (Android 11+)

This is the **most advanced** method — 100% cable-free from start to finish! However, it only works on phones with Android 11 or newer.

### Part A: Enable Wireless Debugging on Phone

1. Open **Settings** → **Developer Options**.
2. Scroll down, find **"Wireless Debugging"** (may also appear as "Wi-Fi Debugging").
3. Enable the toggle. Tap **"Allow"** on the confirmation popup.
4. Tap on the text **"Wireless Debugging"** (not the toggle, but the text itself) to enter its sub-menu.
5. Note the **IP address and Port** shown at the top (example: `192.168.1.5:39465`). **This port is for connecting.**

### Part B: Pair Your Laptop (First Time Only)

Before connecting, your laptop and phone need to "introduce themselves" to each other:

1. Inside the Wireless Debugging menu on your phone, tap **"Pair device with pairing code"**.
2. Your phone will display:
   - **IP:Port for pairing** (example: `192.168.1.5:43521`) — this is DIFFERENT from the port above!
   - **6-digit code** (example: `123456`)
3. On your laptop, **double-click `run.bat`** → choose English → type **`3`** (Wireless Debugging).
4. When prompted, choose the **pairing** option and enter the pairing IP:Port and 6-digit code from your phone.
5. ✅ You'll see: **"Successfully paired"**. Pairing complete!

> 💡 **Pairing only needs to be done once!** After pairing, next time you can connect directly without pairing again — as long as you're using the same laptop.

### Part C: Connect

1. Run `run.bat` → English → **`3`** (Wireless Debugging).
2. Enter the **connection IP and Port** (not the pairing port!) shown at the top of the Wireless Debugging screen on your phone.
3. ✅ **Done!** The mirror window will appear!

---

## 🐧 Tutorial: Linux Usage

For Linux users, the process is slightly different since it uses the Terminal.

### Step 1: Install Dependencies

Open a Terminal and run the following commands:

```bash
# Update package list
sudo apt-get update

# Install adb and scrcpy
sudo apt-get install -y adb scrcpy

# Optional: install the latest scrcpy via snap
sudo snap install scrcpy

# Add yourself to the plugdev group (important for USB recognition)
sudo usermod -aG plugdev $USER

# Log out and log back in for group changes to take effect
```

### Step 2: Run the Script

```bash
# Navigate to the ScreenMirror folder
cd ScreenMirror

# Give all scripts execute permission
chmod +x *.sh Linux-ID/*.sh

# Run English version
./run.sh

# --- OR run Indonesian version ---
# cd Linux-ID && ./run.sh
```

### Step 3: Follow On-Screen Instructions

The Terminal menu will appear just like on Windows (you will be asked to choose a language first). Simply follow the prompts!

> 💡 **Linux Tip:** If your phone isn't detected, try running `adb kill-server && adb start-server` first, then reconnect the USB cable.

---

## 🚀 Run from Anywhere (Global Shortcut)

No need to navigate to the `ScreenMirror` folder every time you want to cast your screen! This program features **Auto-Path** injection and built-in **Shortcuts**.

### 🪟 For Windows Users
1. After you run `run.bat` for the first time, the program's folder is automatically added to your Windows **Environment PATH**.
2. Next time, simply press **`Windows + R`** on your keyboard, type **`mulaism`** or **`run`**, and hit Enter.
3. The ScreenMirror program will launch instantly! (You can also type `mulaism` in any CMD window).

### 🐧 For Linux Users
1. Run `run.sh` for the first time. The script will automatically add the folder to your `~/.bashrc` and `~/.zshrc`.
2. After restarting your terminal (or opening a new tab), you can type **`mulaism`** or **`run.sh`** from any directory to launch it!
3. **Alternative System Install:** From the main Linux menu (Option 10), you can select **Install Shortcut**. This will create global `screenmirror` and `mulaism` commands inside `/usr/local/bin`, making it accessible for all users on your computer.

---

## ✨ Key Features

ScreenMirror comes with many powerful features you can enable from its interactive menu:

### Core Features

| Feature | Description | How to Access |
|---------|------------|---------------|
| **🔗 USB Connection** | Mirror via cable, highest quality | Menu → `1` |
| **📡 WiFi Connection** | Wireless mirror for all Android | Menu → `2` |
| **📶 Wireless Debug** | Fully wireless for Android 11+ | Menu → `3` |
| **📸 Screenshot** | Capture phone screen directly to laptop | Menu → `7` |
| **⬇️ Auto Install** | Download latest scrcpy version automatically | Menu → `8` |
| **💾 Save Configuration** | Save settings so you don't have to redo them | Saved automatically |

### During Mirroring

| Feature | Description |
|---------|-------------|
| **🌙 Stay Awake** | Prevents phone screen from turning off while mirroring |
| **🎬 Record Screen** | Record phone display as an `.mp4` file saved to your laptop |
| **🖥️ No Control Mode** | View-only — keyboard & mouse can't control the phone (great for presentations) |
| **🌑 Turn Screen Off** | Physical phone screen turns off, but mirror continues (saves phone battery) |
| **🔊 Audio Mirroring** | Phone audio streams to laptop speakers (requires sndcpy + VLC for Android < 11) |
| **🔲 Fullscreen** | Mirror window goes fullscreen on your laptop |

### Adjustable Video Settings

| Parameter | Default Value | Options | Description |
|-----------|--------------|---------|-------------|
| **Codec** | H.264 | H.264, H.265, AV1 | Video compression format |
| **Bitrate** | 8M | 2M – 50M | Video quality (higher = clearer) |
| **FPS** | 60 | 15, 30, 60 | Frames per second (smoothness) |
| **Resolution** | 1080p | 480, 720, 1080, 1440, custom | Streamed image size |
| **Buffer** | 50ms | Custom | Buffer delay for stable connection |

---

## ⌨️ Keyboard Shortcuts While Mirroring

When the mirror window is active, you can use these keyboard shortcuts:

| Keyboard Shortcut | Function |
|------------------|----------|
| `Ctrl` + `H` | Press the **Home** button on phone |
| `Ctrl` + `B` | Press the **Back** button on phone |
| `Ctrl` + `M` | Press the **Menu / Overview** button |
| `Ctrl` + `S` | **Take Screenshot** (saved to the folder where the script was run) |
| `Ctrl` + `R` | **Rotate** the screen orientation (portrait/landscape) |
| `Ctrl` + `F` | Toggle **Fullscreen** mode |
| `Ctrl` + `W` | **Close** the mirror window |
| `Ctrl` + `N` | **Turn off** phone screen (mirror continues) |
| `Ctrl` + `Shift` + `N` | **Turn on** phone screen |
| `MOD` + `↑` | **Increase volume** on phone |
| `MOD` + `↓` | **Decrease volume** on phone |
| `MOD` + `P` | **Toggle phone screen** on/off |
| `F11` | **Fullscreen** (alternative shortcut) |
| `MOD` + `Q` | **Quit** scrcpy |

> 💡 **Note:** `MOD` is usually the left `Alt` key on a Windows keyboard. scrcpy also supports multi-finger gestures: hold `Ctrl` while clicking to simulate pinch-to-zoom.

---

## ⚡ Tips to Fix Stuttering / Lag

If the screen on your laptop looks choppy or isn't smooth, follow this guide:

### Quick Ways to Reduce Lag

| Step | What to Change | Recommended Value |
|------|---------------|-------------------|
| 1️⃣ | Lower **Resolution** | From 1080p → try **720p** |
| 2️⃣ | Lower **Bitrate** | From 8M → try **4M** or **6M** |
| 3️⃣ | Lower **FPS** | From 60 → try **30** |
| 4️⃣ | Change **Codec** | From H.265 → try **H.264** |
| 5️⃣ | Change **Connection** | From WiFi → use **USB cable** |

### Common Causes & Solutions

| Problem | Likely Cause | Solution |
|---------|-------------|----------|
| Stuttering screen | Weak WiFi signal | Move closer to router, or use USB |
| Unnatural colors | Codec mismatch | Switch codec to H.264 |
| Connection keeps dropping | Bad USB port | Try a different USB port, prefer USB 3.0 |
| Black screen | Phone locked / screen off | Unlock phone, enable Stay Awake |
| Audio delay | Buffer too small | Increase video buffer value |

---

## 🔒 Security: Is This Safe?

A very reasonable question! Let's discuss it honestly and transparently:

### How It Works

When ScreenMirror is active, the laptop sends **virtual signals** (touches, keyboard keystrokes) to the phone through the ADB protocol. This is called *Input Event Injection*. ADB is an official technology from Google, used by millions of Android developers worldwide.

### When Is It 100% Safe?

| ✅ Safe when... | ⚠️ Be careful when... |
|----------------|----------------------|
| You're using your own laptop | Using someone else's or a public computer |
| Connected via direct USB cable | Using public WiFi (cafe, mall, airport) |
| On your private/home WiFi network | Your laptop can be accessed remotely by others |
| The phone only contains your data | The phone contains sensitive data from others |

### Safe Mode for Presentations: "No Control"

If you only want to **display** your phone screen without the risk of someone controlling it from the laptop, enable **No Control** mode when prompted during setup. In this mode:

- ✅ Phone screen is still visible on the laptop
- ❌ Laptop mouse and keyboard **cannot** control the phone at all

```bash
# Manual scrcpy command for this mode:
scrcpy --no-control
```

---

## 🔧 Troubleshooting Common Issues

### ❌ "No device detected" or "No devices/emulators found"

```
✔ Make sure USB cable is properly connected (try unplugging and replugging)
✔ Ensure USB Debugging is enabled on the phone (see Step 2)
✔ Watch your phone screen — tap "Allow" if a popup appears
✔ Restart ADB server: open Command Prompt, type: adb kill-server && adb start-server
✔ Try a different USB port on your laptop (USB 3.0 is better than USB 2.0)
✔ Try a different USB cable (the cable itself might be the issue)
✔ Reset authorization: Settings → Developer Options → Revoke USB Debugging Authorizations → reconnect
```

### ❌ Mirror Window Closes by Itself Suddenly

```
✔ Check USB cable connection (may be loose)
✔ Make sure phone isn't locked/screen isn't off when mirroring starts
✔ Try lowering bitrate and resolution to reduce processor load
✔ Check if phone is showing a notification requiring confirmation
✔ Try restarting the script from the beginning
```

### ❌ Screen is Very Laggy / Stuttering

```
✔ Use USB connection instead of WiFi (far more stable)
✔ Lower the resolution (use 720p)
✔ Lower the bitrate (use 4M)
✔ Lower the FPS (use 30)
✔ Switch codec to H.264 (most compatible)
✔ Close heavy applications running in the background on your laptop
```

### ❌ "scrcpy not found" / "'scrcpy' is not recognized"

```
✔ Run menu "8. Download & Install Dependencies" in the script to auto-install
✔ Or download manually from: https://github.com/Genymobile/scrcpy/releases/latest
✔ Extract the ZIP to: C:\scrcpy-win64-vX.X\
✔ Restart the script (run.bat) after installation
```

### ❌ WiFi Connection Fails / Timeout

```
✔ Make sure phone and laptop are on the SAME WiFi network (not different hotspots)
✔ Temporarily disable Windows Defender Firewall to test
✔ Check that port 5555 isn't blocked by antivirus or firewall
✔ Try reconnecting the phone to WiFi, then check the IP again
```

### ❌ "The system cannot find the path specified"

```
✔ Run menu "8. Download & Install Dependencies" to reinstall
✔ Make sure scrcpy is installed and the path is registered
✔ Try restarting your laptop after installation so PATH is refreshed
```

### ❌ Phone Screen Shows as Black (Black Screen)

```
✔ Unlock your phone first, then try again
✔ Disable "Don't Keep Activities" in Developer Options
✔ Some banking/secure apps block screenshots — this is normal
✔ Try switching the codec
```

### ❌ Phone Audio Doesn't Come Out of Laptop Speakers

```
✔ Audio auto-forwarding works on Android 11+ (using latest scrcpy)
✔ For Android 10 and below: install VLC and use sndcpy (separate menu)
✔ Check that laptop volume isn't muted
✔ Make sure laptop audio drivers are working normally
```

---

## ❓ Frequently Asked Questions (FAQ)

**Q: Does my phone need to be rooted?**  
A: **No, not at all.** ScreenMirror uses ADB, an official debugging tool from Google. No phone modifications are required.

**Q: Can this be used on an iPhone or iPad?**  
A: **No.** This program is specifically for Android phones and tablets only. iPhones and iPads don't support ADB.

**Q: Is ScreenMirror free?**  
A: **Yes, 100% free and open source.** The source code is available directly on this GitHub page.

**Q: Is my phone data safe?**  
A: **Yes**, as long as you use it on your own device and your private network. Never enable USB Debugging on someone else's computer or on an untrusted public WiFi network.

**Q: Can it be used while the phone is locked?**  
A: **No.** The phone screen must be active (unlocked) for mirroring to work. Enable the **Stay Awake** feature to prevent the phone screen from turning off automatically while mirror is active.

**Q: Can it be used with the phone's own hotspot?**  
A: **Yes!** Enable hotspot on your phone, connect your laptop to that hotspot, then use the WiFi connection method. Useful when there's no home WiFi available.

**Q: What's the difference between WiFi mode and Wireless Debugging?**  
A: **WiFi (TCP/IP) mode** works on all Android versions (5+) but requires a USB cable for the first-time setup. **Wireless Debugging** requires no cable at all from the start, but is only available on Android 11 and above.

**Q: The screen appears but there are black borders on the sides (letterboxing)?**  
A: This happens because the phone's aspect ratio differs from the laptop's mirror window. Press `Ctrl+R` to rotate the display, or manually resize the mirror window.

**Q: Can I mirror more than one phone at the same time?**  
A: Yes, technically possible, but only through manual Terminal commands using the `-s [device-serial]` argument. This feature is not available in ScreenMirror's interactive menu.

**Q: Can I use it to stream to YouTube/Twitch?**  
A: ScreenMirror itself only displays the phone screen on your laptop. For streaming, you need to use streaming software like OBS Studio to capture the ScreenMirror window as a video source.

---

## 🗂️ Project Folder Structure

Here's what's inside the ScreenMirror folder you downloaded:

```
ScreenMirror/
│
├── 📄 run.bat                  ← [WINDOWS] MAIN FILE — Double-click to start!
├── 📄 run.sh                   ← [LINUX/MAC] Main file English version
│
├── 📁 Windows-ID/              ← Windows scripts in Indonesian language
│   ├── 📄 scrcpy.bat           ← Main mirroring script (ID version)
│   └── 📄 sndcpy.bat           ← Audio mirroring script (ID version)
│
├── 📁 windows/                 ← Windows scripts in English language
│   ├── 📄 scrcpy.bat           ← Main mirroring script (EN version)
│   └── 📄 sndcpy.bat           ← Audio mirroring script (EN version)
│
├── 📁 Linux-ID/                ← Linux scripts in Indonesian language
│   ├── 📄 run.sh               ← Linux Indonesia entry point
│   ├── 📄 screenmirror.sh      ← Main mirroring script
│   ├── 📄 info.sh              ← System information
│   └── 📄 sndcpy.sh            ← Audio mirroring
│
├── 📄 screenmirror.sh          ← Linux English main script
├── 📄 sndcpy.sh                ← Linux English audio mirroring
├── 📄 README.md                ← This guide (English version)
├── 📄 README-ID.md             ← This guide (Indonesian version)
└── 📄 LICENSE                  ← MIT License
```

### Where Are Settings Saved?

The script automatically remembers your last settings:

- **Windows:** `C:\Users\[YourName]\AppData\Roaming\screenmirror_config.ini`
- **Linux:** `~/.screenmirror.conf`

Settings that are saved:
- Last IP address and Port
- FPS, bitrate, resolution, and codec
- Feature toggles (Stay Awake, No Control, etc.)

To view or delete saved configuration, use menu **`9`** (View/Delete Saved Configuration) in the main menu.

---

## 📝 Credits & Acknowledgements

This program uses several great technologies from other developers:

| Technology | Creator | Link | Description |
|------------|---------|------|-------------|
| **scrcpy** | Genymobile (rom1v) | [github.com/Genymobile/scrcpy](https://github.com/Genymobile/scrcpy) | Core engine for screen & audio mirroring |
| **sndcpy** | rom1v | [github.com/rom1v/sndcpy](https://github.com/rom1v/sndcpy) | Audio mirroring for Android < 11 |
| **ADB** | Google / Android Open Source | [developer.android.com](https://developer.android.com/tools/adb) | Official Android communication protocol |
| **ScreenMirror Scripts** | **Xnuvers007** | [github.com/Xnuvers007/ScreenMirror](https://github.com/Xnuvers007/ScreenMirror) | These interactive scripts & interface |

---

## 📜 License

This project is licensed under the **MIT License** — meaning you're free to use it, modify it, and distribute it, **as long as you keep credit to the original creator**.

See the [LICENSE](LICENSE) file for full details.

---

## 🐛 Bug Reports & Feature Requests

Found a problem or have an idea for a new feature?

- 🐛 **Report a Bug:** [Open a New Issue](https://github.com/Xnuvers007/ScreenMirror/issues/new)
- 💡 **Suggest a Feature:** [Discuss in Issues](https://github.com/Xnuvers007/ScreenMirror/issues)
- 🤝 **Contribute Code:** [Send a Pull Request](https://github.com/Xnuvers007/ScreenMirror/pulls)

---

<div align="center">

**Made with ❤️ by [Xnuvers007](https://github.com/Xnuvers007)**

If this program helped you, please click the ⭐ **Star** button in the top right corner of this page! That's the best way to support the developer.

</div>
