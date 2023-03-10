@echo off
title YTDL-Helper Updater
cd %~dp0
echo %* | findstr /I "ytdl-dwd"
if %errorlevel% == 0 goto :ytdl-dwd
echo %* | findstr /I "ytdl-upd"
if %errorlevel% == 0 goto :ytdl-upd
echo %* | findstr /I "ffmpeg-dwd"
if %errorlevel% == 0 goto :ffmpeg-dwd

:: ==================================================Obtain==================================================
curl --output releases.tmp -L https://api.github.com/repos/yuri010/youtube-dl-helper/releases
call :gver
call :gvercleanup
call :lver
goto :main
:: ==================================================Checks==================================================

:gver
for /F "tokens=2 delims= " %%a IN ('findstr /I "tag_name" releases.tmp') DO (
set gver=%%a
exit /b
)
:gvercleanup
for /F "tokens=1 delims=," %%b IN ("%gver%") DO (
set gver=%%b
exit /b
)

:lver
for /F "tokens=3 delims= " %%c IN ('findstr /I "version" ytdl-helper.bat') DO (
set lver=%%c
exit /b
)


:main
del releases.tmp
if /I "%lver%" GTR %gver% (
cls
echo Hey! Github isn't Up-to-Date!
echo.
echo Press any key to exit...
pause > nul
exit
)
if /I "%lver%" == %gver% (
cls
echo YTDL-Helper is Up-to-Date.
echo.
echo Press any key to exit...
pause > nul
exit
)
if "%lver%" LSS %gver% (
cls
echo An update is available, would you like to install it? [Y/N]
choice /c YN /N
if /I "%errorlevel%" EQU "2" exit
if /I "%errorlevel%" EQU "1" goto :update
)

:: ==================================================Update==================================================

:update
cls
echo Attempting to obtain the latest YTDL-Helper...
echo.
echo Log: ====================================================================================================
echo.
curl -0 -L https://raw.githubusercontent.com/Yuri010/Youtube-DL-Helper/main/ytdl-helper.bat -o ytdl-helper-new.bat
curl -0 -L https://raw.githubusercontent.com/Yuri010/Youtube-DL-Helper/main/Updater.bat -o updater-new.bat
echo.
echo =========================================================================================================
echo Updating to version %gver% over %lver%...
move ytdl-helper.bat ytdl-helper-old.bak
move ytdl-helper-new.bat ytdl-helper.bat
move updater.bat updater-old.bak
move updater-new.bat updater.bat
cls
echo Updating to version %gver% over %lver%... Done!
echo.
echo Update success!
timeout /t 3 /nobreak > nul
exit

:: ==================================================FFMPEG==================================================

:ffmpeg-dwd
    echo Attempting to obtain the latest FFmpeg release from https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip
    echo.
    echo Log: ====================================================================================================
    echo.
    curl --output ffmpeg.zip -L https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip > nul
    echo.
    echo =========================================================================================================
    tar -xf ffmpeg.zip
    timeout /t 1 /nobreak > nul
    del ffmpeg.zip
    cls
    echo FFMpeg Update Done.
    echo Restarting YTDL-Helper...
    timeout /t 2 /nobreak > nul
    start "" "%~dp0/ytdl-helper.bat"
exit

:: ==================================================YTDL==================================================

:ytdl-info
    curl --output releases.tmp -L https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest
    more releases.tmp | findstr /I "yt-dlp_min.exe" | findstr "browser_download_url" > link.tmp
    for /F "tokens=2 delims= " %%l IN ('more link.tmp') do (set link=%%l)
    call :gver
    call :gvercleanup
    del link.tmp
    del releases.tmp
exit/b

:ytdl-dwd
    cls
    call :ytdl-info
    cls
    echo Attempting to obtain the latest Youtube-DL...
    echo.
    echo Log: ====================================================================================================
    echo.
    curl -0 -L %link% -o youtube-dl.exe
    echo.
    echo =========================================================================================================
    timeout /t 1 /nobreak > nul
    cls
    echo Youtube-DL Update Done.
    echo Restarting YTDL-Helper...
    timeout /t 2 /nobreak > nul
    start "" "%~dp0/ytdl-helper.bat"
exit

:ytdl-upd
    cls
    call :ytdl-info
    for /f "tokens=* delims=" %%a IN ('youtube-dl --version') do (set lver="%%a")
    if /I "%lver%" == %gver% (
        cls
        echo YTDL-Helper is Up-to-Date.
        echo.
        echo Press any key to exit...
        pause > nul
        exit
    )
        if "%lver%" LSS %gver% (
        cls
        echo An update is available, would you like to install it? [Y/N]
        choice /c YN /N
        if /I "%errorlevel%" EQU "2" exit
        if /I "%errorlevel%" EQU "1" goto :ytdl-dwd
    )