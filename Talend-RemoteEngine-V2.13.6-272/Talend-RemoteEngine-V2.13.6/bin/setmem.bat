@echo off

rem retrieve/check java version
for /f tokens^=2-5^ delims^=.-_+^" %%j in ('"%JAVA%" -fullversion 2^>^&1') do (
    if %%j==1 (set JAVA_VERSION=%%k) else (set JAVA_VERSION=%%j)
)
if %JAVA_VERSION% LSS 17 (
    echo "JVM must be version 17 or greater for Remote Engine"
    exit /b 1
)

rem determine whether we use a 64-bit java version

set java_version_file=%time::=%
set /a java_version_file=java_version_file
set java_version_file=__JVER%java_version_file%%random%.tmp
"%JAVA%" -version 2> %java_version_file%
for /f %%G IN ('findstr "64-Bit" %java_version_file%') DO set sixtyfour=true
rem Check minor java version number in string like 'java/openjdk version "1.7.0_80"'
for /f "tokens=3" %%g in ('findstr /i /c:" version " %java_version_file%') do (
    set JAVAVER=%%g
)
set JAVAVER=%JAVAVER:"=%
set JAVAVER_MINOR=7
for /f "delims=. tokens=2" %%v in ("%JAVAVER%") do (
    set JAVAVER_MINOR=%%v
)
del %java_version_file%

rem Check/Set up some easily accessible MIN/MAX params for JVM mem usage

if "%JAVA_MIN_MEM%" == "" (
    if "%sixtyfour%" == "" (
        set JAVA_MIN_MEM=128M
    ) else (
        set JAVA_MIN_MEM=256M
    )
)

if "%JAVA_MAX_MEM%" == "" (
    if "%sixtyfour%" == "" (
        set JAVA_MAX_MEM=512M
    ) else (
        set JAVA_MAX_MEM=1024M
    )
)
