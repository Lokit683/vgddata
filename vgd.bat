@echo off
SETLOCAL EnableDelayedExpansion
set bootlist=vqazwsxedcrftgbyhnujmikolp1234567890
set bootver=1_0
set ver=1_1

set Colbackground=7
set Coltext=8

if not exist SysConfig.yml set bootkey=105
if exist SysConfig.yml set /p bootkey=<SysConfig.yml
if "%1"=="get" echo !%2!&exit /b
:boot
color %Colbackground%%Coltext%
cls
for /f "tokens=* delims=" %%a in ('call vgd.bat get bootver') do set return=%%a
title  
echo.           ^|
echo.   \    /  ^| Boot version: %return%
echo.    \/\/   ^|
echo.___________^|
echo.
echo.  "Press 'boot key' to open boot menu."
choice /c:!bootlist! /t 1 /d r > nul
if "!errorlevel!"=="!bootkey!" echo 1
cls
echo.           ^|
echo.    \  /   ^|
echo.     \/    ^|
echo.___________^|
echo.
echo.
call :color %Colbackground%9
echo.
call :echo "                                       Cheking intenet connecting."
echo.
call :echo "               #################                                                                      @"
curl https://github.com/Lokit683/vgddata > nul
echo.
if "!errorlevel!"=="0" (
	call :color %Colbackground%a
	call :echo "                                                    OK."
	) else (
	call :color %Colbackground%c
	call :echo "                                                   ERROR."
	)
timeout 3 > nul
cls
echo.           ^|
echo.    \  /   ^|
echo.     \/    ^|
echo.___________^|
echo.
echo.
call :color %Colbackground%9
echo.
call :echo "                                     Checking OS updating on server."
echo.
call :echo "               #####################################                                                  @"
if exist data\temp\upd\ rd /s /q data\temp\upd
if not exist data\temp\upd md data\temp\upd\
powershell -command "Invoke-WebRequest https://codeload.github.com/Lokit683/VGD/zip/refs/heads/main -OutFile data\temp\upd\vgd.zip"
cd /d data\temp\upd
tar.exe -xf vgd.zip

cd ..\..\..
pause






exit /b

:: --------- UTILITS

:color
 set "c=%1"
exit /b
 
:echo
 for /f %%i in ('"prompt $h& for %%i in (.) do rem"') do (
  pushd "%~dp0"
   <nul>"%~1_" set /p="%%i%%i  "
   findstr /a:%c% . "%~1_*"
   if "%~2" neq "/" echo.
   del "%~1_"
  popd
 )
exit /b
