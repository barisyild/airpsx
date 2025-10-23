![GitHub stars](https://img.shields.io/github/stars/barisyild/airpsx)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)
![GitHub release](https://img.shields.io/github/v/release/barisyild/airpsx)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/barisyild/airpsx)

---

## 💖 Support My Work

> I recently purchased a PlayStation 4 to work on the **AirPSX port**.  
Your donations help me cover these costs and continue developing projects like **AirPSX** and my **backend framework**. 
> 
>Thank you for supporting my open-source work!

# AirPSX

**AirPSX** is a payload similar to AirDroid. It enables you to manage many operations related to your PlayStation 5 console through a web-based desktop environment.

> ⚠️ **Disclaimer**
>
> I AM NOT RESPOSIBLE FOR ANY DAMAGE TO YOUR CONSOLE IF SOMETHING WILL GO WRONG!
> 
> I do not accept any responsiblity for misuse of the file manager, execution of malicious scripts, or any damage that may occur to the console in any case.

---

## 🚀 Getting Started

### elfldr
- Run elfldr payload
- Linux
  - socat -t 99999999 - TCP:PS5_HOST:9021 < "airpsx.elf"

### websrv
- Download airpsx.zip from the latest [release](https://github.com/barisyild/airpsx/releases)
- Unzip the contents to the /data/homebrew/ directory in a folder named airpsx (final path should be: /data/homebrew/airpsx/).
- Start websrv from PlayStation 5 and select the airpsx application

---

## 📦 Dependencies

* [hxcpp fork](https://github.com/barisyild/hxcpp/tree/ps5-payload)
* [hxwell](https://github.com/hxwell/hxwell)
* [rulescript](https://github.com/Kriptel/RuleScript)
* [linc_lua](https://github.com/kevinresol/linc_lua)
* [hxvm-lua](https://github.com/kevinresol/hxvm-lua)
* [uuid](https://github.com/flashultra/uuid)
* [haxe-crypto fork](https://github.com/barisyild/haxe-crypto)
* [haxe-concurrent](https://github.com/vegardit/haxe-concurrent)

---

## 🙏 Special Thanks

* [LightningMods](https://github.com/LightningMods) — [PS4-daemon-writeup](https://github.com/LightningMods/PS4-daemon-writeup)
* [Hugh Sanderson](https://github.com/hughsando) — [hxcpp](https://github.com/HaxeFoundation/hxcpp)
* [m0rkeulv](https://github.com/m0rkeulv) — [intellij-haxe](https://github.com/HaxeFoundation/intellij-haxe)
---

## 🧪 Testers

* [terex777](https://x.com/TeRex777_)
* SilverArrow5941
* [Feyzee61](https://github.com/Feyzee61)

---

## ⚙️ How It Works

This project uses [hxwell](https://github.com/hxwell/hxwell), a web framework written in Haxe. The Haxe code is transpiled to C++.

---

## 🎥 Video Overview

* **MODDED WARFARE** — [Watch here](https://www.youtube.com/watch?v=cH7Jx-7Mn4k)
* **TheWizWiki** — [Watch here](https://www.youtube.com/watch?v=ZxOezdneSHg)
