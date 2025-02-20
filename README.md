### AirPSX
AirPSX is a payload similar to AirDroid; It allows you to manage many operations related to your console via the web-based desktop environment.

> [!WARNING]
> I DO NOT RESPOSIBLE FOR ANY DAMAGE TO YOUR CONSOLE IF SOMETHING WILL GO WRONG!
>
> I do not accept any responsible for misuse of the file manager, execution of malicious scripts, or any damage that may occur to the console in any case.

## Build

- Run install.sh
- Locate the project folder and execute the following command:
```sh
export PS5_PAYLOAD_SDK=/opt/ps5-payload-sdk && haxe release.hxml --cmd "mv out/HxWell out/airpsx.elf"
```

## Dependencies
- [hxcpp fork](https://github.com/barisyild/hxcpp)
- [hxwell](https://github.com/barisyild/hxwell)
- [rulescript](https://github.com/Kriptel/RuleScript)

## Special Thanks
- [John Törnblom](https://github.com/john-tornblom)
    - Contributions to the [PS5 SDK](https://github.com/ps5-payload-dev/sdk) and [ELF Loader](https://github.com/ps5-payload-dev/elfldr).
- [LightningMods](https://github.com/LightningMods)
    - Contributions to the [PS4-daemon-writeup](https://github.com/LightningMods/PS4-daemon-writeup).
- [Hugh Sanderson](https://github.com/hughsando)
    - Haxe's [hxcpp](https://github.com/HaxeFoundation/hxcpp) target would not have been possible without him!
- [m0rkeulv](https://github.com/m0rkeulv)
    - If it wasn't for [intellij-haxe](https://github.com/HaxeFoundation/intellij-haxe), maybe I would never have write any haxe project :(

## Testers
- [terex777](https://x.com/TeRex777_)

## How it works
This web project is built using my web framework, [hxwell](https://github.com/barisyild/hxwell). Leveraging the power of Haxe, all source code is transpiled to C++ and compiled using the PS5 Payload SDK.
