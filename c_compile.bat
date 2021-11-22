@REM create pak file
call create_pak.bat

@REM change compile targets
copy /y "config\compile-targets\compile-c.hxml" compile.hxml

@REM do hashlink to C transpile
haxe compile.hxml

@REM fix hashlink C code
powershell -Command "(gc out\hl\init.c) -replace 'inf\.;', 'INFINITY;' | Out-File -encoding UTF8 out\hl\init.c"
powershell -Command "(gc out\oimo\dynamics\constraint\joint\Joint.c) -replace 'inf\.;', 'INFINITY;' | Out-File -encoding UTF8 out\oimo\dynamics\constraint\joint\Joint.c"
powershell -Command "(gc out\oimo\collision\narrowphase\detector\gjkepa\GjkEpa.c) -replace 'inf\.;', 'INFINITY;' | Out-File -encoding UTF8 out\oimo\collision\narrowphase\detector\gjkepa\GjkEpa.c"
powershell -Command "(gc out\oimo\collision\narrowphase\detector\_BoxBoxDetector\FaceClipper.c) -replace 'inf\.;', 'INFINITY;' | Out-File -encoding UTF8 out\oimo\collision\narrowphase\detector\_BoxBoxDetector\FaceClipper.c"
powershell -Command "(gc out\oimo\collision\narrowphase\detector\BoxBoxDetector.c) -replace 'inf\.;', 'INFINITY;' | Out-File -encoding UTF8 out\oimo\collision\narrowphase\detector\BoxBoxDetector.c"
powershell -Command "(gc out\oimo\dynamics\constraint\joint\RevoluteJoint.c) -replace 'inf\.;', 'INFINITY;' | Out-File -encoding UTF8 out\oimo\dynamics\constraint\joint\RevoluteJoint.c"
powershell -Command "(gc out\oimo\dynamics\constraint\joint\CylindricalJoint.c) -replace 'inf\.;', 'INFINITY;' | Out-File -encoding UTF8 out\oimo\dynamics\constraint\joint\CylindricalJoint.c"
powershell -Command "(gc out\oimo\dynamics\constraint\joint\PrismaticJoint.c) -replace 'inf\.;', 'INFINITY;' | Out-File -encoding UTF8 out\oimo\dynamics\constraint\joint\PrismaticJoint.c"
powershell -Command "(gc out\oimo\dynamics\constraint\joint\UniversalJoint.c) -replace 'inf\.;', 'INFINITY;' | Out-File -encoding UTF8 out\oimo\dynamics\constraint\joint\UniversalJoint.c"
powershell -Command "(gc out\oimo\dynamics\constraint\joint\RagdollJoint.c) -replace 'inf\.;', 'INFINITY;' | Out-File -encoding UTF8 out\oimo\dynamics\constraint\joint\RagdollJoint.c"
powershell -Command "(gc out\oimo\dynamics\constraint\solver\direct\BoundaryBuilder.c) -replace 'inf\.;', 'INFINITY;' | Out-File -encoding UTF8 out\oimo\dynamics\constraint\solver\direct\BoundaryBuilder.c"
@REM powershell -Command "(gc PATH.c) -replace 'inf\.;', 'INFINITY;' | Out-File -encoding UTF8 PATH.c"

@REM set up environment for C compilation
call "%VCVARS_PATH%\vcvars64.bat"

@REM compile
cl.exe /Ox ^
    -I "%HASHLINK_PATH%\include" ^
    -I "out" "out\main.c" ^
    "%HASHLINK_PATH%\libhl.lib" ^
    "%HASHLINK_PATH%\ui.lib" ^
    "%HASHLINK_PATH%\directx.lib" ^
    "%HASHLINK_PATH%\openal.lib" ^
    "%HASHLINK_PATH%\fmt.lib"

@REM clean up
del main.obj
del /s /f /q out\*.*
for /f %%f in ('dir /ad /b out') do rd /s /q out\%%f
rmdir out
copy /y "config\compile-targets\compile-hashlink.hxml" compile.hxml

@REM done
echo .
echo .
echo .
echo Produced executable main.exe. Distribution requires the /assets directory.