# K Skee

## Dependencies

* Haxe 4.2.3
* HashLink 1.11.0
* haxelib libraries:
  * heaps 1.9.1
  * format 3.5.0
  * hashlink 0.1.0
  * hldx 1.10.0
  * hlsdl 1.10.0 (this is the SDL alternative to hldx's DirectX)
  * hlopenal 1.5.0
  * oimophysics 1.2.2 w/ mods from synkarius Github fork
  * tweenxcore 1.0.4
  * utest 1.13.2
* Build Tools for Visual Studio (2019)

## Setup

### Prerequisites

1. Install Haxe.
2. Install HashLink.
3. Set the environmental variable `HASHLINK_PATH` to the directory containing `hl.exe`.
4. Install haxelib libraries via `setup-dependencies.bat`.
5. Install [Build Tools for Visual Studio](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2019) and [set up](https://docs.microsoft.com/en-us/cpp/build/walkthrough-compile-a-c-program-on-the-command-line?view=msvc-160). You don't need Visual Studio itself, just the command line tools.
6. Set the environmental variable `VCVARS_PATH` to the directory containing `vcvars64.bat`. This might be:
```
C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build
```

### Compilation

Run `c_compile.bat`. This will produce `main.exe`. The process is explained in comments in the batch file.

### Distribution

1. Copy `file.pak`, `main.exe`, and everything in `/dist-reqs` into the dist zip.
2. You can switch between DirectX and SDL/OpenGL. SDL may be more stable. Do this by changing the following:

**libs.hxml**:
```
# -lib hldx
-lib hlsdl
```

**c_compile.bat**: delete
```
    "%HASHLINK_PATH%\directx.lib" ^
```
and add
```
    "%HASHLINK_PATH%\sdl.lib" ^
```

3. Can (must) distribute `mscvr120.dll` for Windows builds, per [this](https://docs.microsoft.com/en-us/visualstudio/releases/2013/2013-redistribution-vs).

### Running Unit Tests

Run the following command to run the test suite.

```
haxe test.hxml
```

## Notes

### Haxe/Hashlink Compatibility

Lots of libraries appear to be incompatible with either Haxe 4.x.x (this was the case with Oimophysics) or Hashlink (this was the case with polygonal-ds). For this reason, minimizing the amount of libraries used seems optimal.