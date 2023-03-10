:: version 2.2
@echo off
:start
cls
title Youtube-DL Helper
cd %~dp0
call :ytdlver
call :ffmpegver
goto :main

==============================FFMPEG CHECK==============================

:ffmpegver
cd ffmpeg*
if %errorlevel% NEQ 0 goto ffnotfound
cd bin
set ffmpeg=%cd%
cd %~dp0
for /F "tokens=3 delims= " %%a IN ('%ffmpeg%\ffmpeg.exe -version') DO (
    if %errorlevel% NEQ 0 goto ffnotfound
    set ffmpegver=%%a
    exit /b
)

:ffnotfound
title Youtube-DL Helper - ERROR
cls
echo ERROR: FFMPEG WAS NOT FOUND
echo.
echo Do you want the script to try and download it for you? [Y/N]
choice /c YN /N
if /I "%errorlevel%" == "2" (
    cls
    echo Script exiting with fatal code 3...
    timeout /t 3 /nobreak > nul
    exit
)
if /I "%errorlevel%" == "1" (
    cls
    start "" "%~dp0\Updater.bat" ffmpeg-dwd
    exit
)


==============================YTDL CHECK==============================

:ytdlver
for /F "tokens=* delims= " %%b IN ('youtube-dl.exe --version') DO (
    if %errorlevel% NEQ 0 goto ytdlnotfound
    set ytdlver=%%b
    exit /b
)

:ytdlnotfound
title Youtube-DL Helper - ERROR
cls
echo ERROR: YOUTUBE-DL WAS NOT FOUND
echo.
echo Do you want the script to try and download it for you? [Y/N]
choice /c YN /N
if /I "%errorlevel%" == "2" (
    cls
    echo Script exiting with fatal code 2...
    timeout /t 3 /nobreak > nul
    exit
)
if /I "%errorlevel%" == "1" (
    cls
    start "" "%~dp0/Updater.bat" ytdl-dwd
    exit
)


========================================MAIN========================================

:main
cls
echo ==================================================
echo Youtube-DL Helper 2.2
echo Youtube-DL Version %ytdlver%
echo FFmpeg Version %ffmpegver%
echo ==================================================
echo.
echo Select an option...
echo. Download a (V)ideo (.mp4 output)
echo. Download (A)udio (.mp3 output)
echo.
echo ==================================================
choice /c VA /N
if /I "%errorlevel%" == "2" goto :audio
if /I "%errorlevel%" == "1" goto :video

========================================AUDIO DOWNLOAD========================================

:audio
title Youtube-DL Helper - Audio Download
cls
echo ==================================================
echo.
echo Audio Download Selected
echo.
echo Please enter a link to a Youtube or Soundcloud
echo Video or Playlist
echo.
set /p link=Input: 
echo.
echo ==================================================
echo.
echo Download Started...
youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 --add-metadata --ffmpeg-location "%ffmpeg%" %link%
echo.
echo ==================================================
echo.
echo Download Complete...
echo Would you like to download another file? [Y/N]
choice /c YN /N
if %errorlevel% == 2 exit
if %errorlevel% == 1 goto :main

========================================VIDEO DOWNLOAD========================================

:video
title Youtube-DL Helper - Video Download
cls
echo ==================================================
echo.
echo Video Download Selected
echo.
echo Please enter a link to a Youtube or Soundcloud
echo Video or Playlist
echo.
set /p link=Input: 
echo.
echo ==================================================
echo.
echo Download Started...
youtube-dl -F %link%
echo.
echo Please select one of the listed formats
echo (or type "best" for the best quality (might not always work properly))
set /p format=Format: 
echo.
echo Continueing download with format %format%...
youtube-dl --format %format% --embed-thumbnail --add-metadata --ffmpeg-location "%ffmpeg%" %link%
echo.
echo ==================================================
echo.
echo Download Complete...
echo Would you like to download another file? [Y/N]
choice /c YN /N
if %errorlevel% == 2 exit
if %errorlevel% == 1 goto :main
