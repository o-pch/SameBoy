# SameBoy

SameBoy is an open source Game Boy (DMG) and Game Boy Color (CGB) emulator, written in portable C. It has a native Cocoa frontend for macOS, an SDL frontend for other operating systems, and a libretro core. It also includes a text-based debugger with an expression evaluator. Visit [the website](https://sameboy.github.io/).

## Note about this repository: 
this fork contains local customizations. See the [Customization from original SameBoy](#customization-from-original-sameboy) section later in this README for details on what has been changed.

## Features
Features common to both Cocoa and SDL versions:
 * Supports Game Boy (DMG) and Game Boy Color (CGB) emulation
 * Lets you choose the model you want to emulate regardless of ROM
 * High quality 96KHz audio
 * Battery save support
 * Save states
 * Includes open source DMG and CGB boot ROMs:
   * Complete support for (and documentation of) *all* game-specific palettes in the CGB boot ROM, for accurate emulation of Game Boy games on a Game Boy Color
   * Supports manual palette selection with key combinations, with 4 additional new palettes (A + B + direction)
   * Supports palette selection in a CGB game, forcing it to run in 'paletted' DMG mode, if ROM allows doing so.
   * Support for games with a non-Nintendo logo in the header
   * No long animation in the DMG boot
 * Advanced text-based debugger with an expression evaluator, disassembler, conditional breakpoints, conditional watchpoints, backtracing and other features
 * Extremely high accuracy
 * Emulates [PCM_12 and PCM_34 registers](https://github.com/LIJI32/GBVisualizer)
 * T-cycle accurate emulation of LCD timing effects, supporting the Demotronic trick, Prehistorik Man, [GBVideoPlayer](https://github.com/LIJI32/GBVideoPlayer) and other tech demos
 * Real time clock emulation
 * Retina/High DPI display support, allowing a wider range of scaling factors without artifacts
 * Optional frame blending (Requires OpenGL 3.2 or later)
 * Several [scaling algorithms](https://sameboy.github.io/scaling/) (Including exclusive algorithms like OmniScale and Anti-aliased Scale2x; Requires OpenGL 3.2 or later or Metal)

Features currently supported only with the Cocoa version:
 * Native Cocoa interface, with support for all system-wide features, such as drag-and-drop and smart titlebars
 * Game Boy Camera support
 
[Read more](https://sameboy.github.io/features/).

## Compatibility
SameBoy passes all of [blargg's test ROMs](http://gbdev.gg8.se/wiki/articles/Test_ROMs#Blargg.27s_tests), all of [mooneye-gb's](https://github.com/Gekkio/mooneye-gb) tests (Some tests require the original boot ROMs), and all of [Wilbert Pol's tests](https://github.com/wilbertpol/mooneye-gb/tree/master/tests/acceptance). SameBoy should work with most games and demos, please [report](https://github.com/LIJI32/SameBoy/issues/new) any broken ROM. The latest results for SameBoy's automatic tester are available [here](https://sameboy.github.io/automation/).

## Contributing
SameBoy is an open-source project licensed under the Expat license (with an additional exception for the iOS folder), and you're welcome to contribute by creating issues, implementing new features, improving emulation accuracy and fixing existing open issues. You can read the [contribution guidelines](CONTRIBUTING.md) to make sure your contributions are as effective as possible.

## Compilation
SameBoy requires the following tools and libraries to build:
 * clang (Recommended; required for macOS) or GCC
 * make
 * macOS Cocoa frontend: macOS SDK and Xcode (For command line tools and ibtool)
 * SDL frontend: libsdl2
 * [rgbds](https://github.com/gbdev/rgbds/releases/), for boot ROM compilation
 * [cppp](https://github.com/LIJI32/cppp), for cleaning up headers when compiling SameBoy as a library

On Windows, SameBoy also requires:
 * Visual Studio (For headers, etc.)
 * [Git Bash](https://git-scm.com/downloads/win) or another distribution of basic Unix utilities
   * Git Bash does not include make, you can get it [here](https://sourceforge.net/projects/ezwinports/files/make-4.4.1-without-guile-w32-bin.zip/download).
 * Running `vcvars64.bat` or `vcvarsx86_amd64.bat` before running make. Make sure all required tools, libraries, and headers are in %PATH%, %lib%, and %include%`, respectively. (see [Build FAQ](https://github.com/LIJI32/SameBoy/blob/master/build-faq.md) for more details on Windows compilation)

To compile, simply run `make`. The targets are:
 * `cocoa` (Default for macOS)
 * `sdl` (Default for everything else)
 * `lib` (Creates libsameboy.o and libsameboy.a for statically linking SameBoy, as well as a headers directory with corresponding headers; currently not supported on Windows due to linker limitations)
 * `ios` (Plain iOS .app bundle), `ios-ipa` (iOS IPA archive for side-loading), `ios-deb` (iOS deb package for jailbroken devices)
 * `libretro`
 * `bootroms`
 * `tester` 

You may also specify `CONF=debug` (default), `CONF=release`, `CONF=native_release` or `CONF=fat_release`  to control optimization, symbols and multi-architectures. `native_release` is faster than `release`, but is optimized to the host's CPU and therefore is not portable. `fat_release` is exclusive to macOS and builds x86-64 and ARM64 fat binaries; this requires using a recent enough `clang` and macOS SDK using `xcode-select`, or setting them explicitly with `CC=` and `SYSROOT=`, respectively. All other configurations will build to your host architecture, except for the iOS targets. You may set `BOOTROMS_DIR=...` to a directory containing precompiled boot ROM files, otherwise the build system will compile and use SameBoy's own boot ROMs.

The SDL port will look for resource files with a path relative to executable and inside the directory specified by the `DATA_DIR` variable. If you are packaging SameBoy, you may wish to override this by setting the `DATA_DIR` variable during compilation to the target path of the directory containing all files (apart from the executable, that's not necessary) from the `build/bin/SDL` directory in the source tree. Make sure the variable ends with a `/` character. On FreeDesktop environments, `DATA_DIR` will default to `/usr/local/share/sameboy/`. `PREFIX` and `DESTDIR` follow their standard usage and default to an empty string an `/usr/local`, respectively

Linux, BSD, and other FreeDesktop users can run `sudo make install` to install SameBoy as both a GUI app and a command line tool.

SameBoy is compiled and tested on macOS, Ubuntu and 64-bit Windows 10.

# Customization from original SameBoy
## Windows convenience: using the `External/` directory

If you'd like a self-contained Windows setup, you can place prebuilt tool binaries under an `External/` directory in the project root. For example:

 * `External/rgbds/` (rgbds binaries)
 * `External/make/` (make.exe and related files)
 * `External/sdl2/` (SDL2 development binaries and headers)

The repository includes `init_build_env.bat`, which will add those `External/` subdirectories to your `%PATH%` for the current command-prompt session. This makes it easier to build without installing those tools system-wide.

Important: `init_build_env.bat` only affects the current terminal session, so you must run it once in each new Command Prompt or PowerShell window before running `build.bat` (or invoking `make`) from that shell. Running `init_build_env.bat` sets up the environment for that session; if you open a new terminal window you will need to run it again there.

Example (from the repository root, one time per terminal session):

  `init_build_env.bat`

After running the script in your terminal you can run `build.bat` or `make sdl` as usual.

## Embedding a ROM into the executable

SameBoy supports embedding a Game Boy ROM into the built executable so that the emulator will automatically load that ROM on startup. This is useful when you want to distribute a single executable that immediately runs a bundled game.

- To embed a ROM at build time, set the `EMBED_ROM` make variable to the path of the ROM you want embedded. For example:

  `make sdl EMBED_ROM=path/to/your_game.gb`

- Alternatively, place a ROM named `embed.gb` in the project root and run the supplied `build.bat` on Windows; `build.bat` will call make with `EMBED_ROM=embed.gb` by default.

### Behavior and save files

- When a ROM is embedded the emulator will prefer it only when no ROM is supplied on the command line. If you run `sameboy.exe some_other.gb` the command-line ROM will take precedence.
- Battery/save files for embedded ROMs are stored in a writable preferences directory returned by `SDL_GetPrefPath` (for example on Windows this is typically `%APPDATA%\SameBoy`). The embedded ROM uses a fixed save filename (for example `embedded.sav` / `embedded.ram`) so progress is preserved between runs.
- Embedding a ROM increases the size of the resulting executable by the size of the ROM.

### Legal

Do not embed or distribute ROMs that you do not have the legal right to distribute. The SameBoy project and this repository do not grant any rights to redistribute commercial game ROMs.

