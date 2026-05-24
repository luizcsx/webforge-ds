# WebForge DS

![GitHub repo size](https://img.shields.io/github/repo-size/luizcsx/webforge-ds?style=flat-square)
![GitHub license](https://img.shields.io/github/license/luizcsx/webforge-ds?style=flat-square)

A custom operating system and lightweight web ecosystem designed specifically for the **Nintendo DS**.

## Overview

WebForge DS is an alternative textual and graphical environment built to transform the Nintendo DS into a portable web-like ecosystem. Instead of relying on heavy modern web standards, WebForge DS implements its own highly optimized, lightweight rendering engine and interpreter to run custom web pages directly on bare-metal hardware.

## Core Features

* **Netwarper Browser:** A custom web browser featuring web connectivity via Wiimmfi, capable of interpreting standalone lightweight web files.
* **Calculator:** A built-in touch-driven application for quick mathematical calculations.
* **Internet Signal Test:** A real-time utility to monitor, test, and display Wi-Fi signal strength and ping status.
* **System Information & Settings:** A control panel to configure date, time, and system preferences (supporting international DD/MM/YYYY and US MM/DD/YYYY formats).
* **Hardware Information:** A diagnostic utility to display detailed specs of the DS architecture and memory status.
* **Theme Packs:** A built-in personalization engine supporting custom visual themes made by the creator and the community.

## The WebForge Web Ecosystem

To circumvent the hardware limitations of the Nintendo DS (67 MHz CPU and 4 MB RAM), Netwarper does not use standard HTML5/CSS3. Instead, it parses a custom, hyper-lightweight syntax split into three files:

### 1. Document Structure (`.PER`)
Equivalent to HTML5, used to define elements and positioning on the DS screens ($256 \times 192$ px).
```text
[MT:"TITLE HERE"]
[P:"Paragraph" POS:"48, 50" CLS:"class"]
[MBP:"Featured here!"]
[USE_STYLE: style.sty]
[LOAD: script.dsjs]
```

### 2. Styling (`.STY`)
Equivalent to CSS3, mapped directly to hardware properties and colors.
```text
B_YELLOW:BG=#FFCC00,TXT=#000000,BRD=2,PAD=4
B_RESET:BG=#FF0000,TXT=#FFFFFF,BRD=1,PAD=2
MBP_PRG:TXT=#FFFFFF,SIZ=12,FNT=AURA
```

### 3. Scripting (`.DSJS`)
A trigger-based scripting syntax equivalent to JavaScript, processed via an optimized C++ switch-case interpreter.
```text
VAR:clicking=0
ON:read_mode
INC:clicking,1
OS:PLAY=sound_data.sdat
OS:REFRESH
IF:clicking==10,OS:ALERT="Hello, world!"
```

## Protocol Standards
- ``wscs://`` (WebSite Certified Secure): For secure remote connections.
- ``wscns://``(WebSite Certified Not Secure): For unencrypted connections.
- ``example.per``: Serves as the default documentation and local test standard.

## Compilation
This project is configured to compile automatically using GitHub Actions via devkitPro's official devkitARM container. The workflow generates the final ``.nds`` executable on every push.

## License
This project is licensed under the MIT License - see the **[LICENSE](/LICENSE)** file for details.
