@echo off
SETLOCAL EnableDelayedExpansion
set bootlist=vqazwsxedcrftgbyhnujmikolp1234567890
set bootver=1_1
set ver=1_3

set Vtemp=data/temp
set VApp=data/temp
set VAppCache=data/AppCache
set VAppRuning=.bat;.vgd;

set Colbackground=7
set Coltext=8

if "%1"=="api" goto apimode
if not exist SysConfig.yml set bootkey=105
if exist SysConfig.yml set /p bootkey=<SysConfig.yml
if "%1"=="get" echo !%2!&exit /b
:boot
color %Colbackground%%Coltext%
cls
for /f "tokens=* delims=" %%a in ('call vgd.bat get bootver') do set return=%%a
if not exist data\ (
	md data\
	md data\temp
	md data\App
	md data\AppCache
	)
title  
echo.           ^|
echo.   \    /  ^| Boot version: %return%
echo.    \/\/   ^|
echo.___________^|
echo.
echo.  "Press 'boot key' to open boot menu."
choice /c:!bootlist! /t 1 /d r > nul
if "!errorlevel!"=="!bootkey!" echo 1
:module1
cls
echo.           ^|
echo.    \  /   ^|
echo.     \/    ^|
echo.___________^|
echo.
echo.
call :color %Colbackground%9
echo.
call :echo "                                Cheking intenet connecting. Or server powered."
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
:module2
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
powershell -command "Invoke-WebRequest https://codeload.github.com/Lokit683/vgddata/zip/refs/heads/main -OutFile data\temp\upd\vgd.zip"
cd /d data\temp\upd
tar.exe -xf vgd.zip
cd ..\..\..
for /f "tokens=* delims=" %%a in ('call data\temp\upd\vgddata-main\vgd.bat get ver') do set return=%%a
if !return!==!ver! goto module4
:module3
:: --- UPDATING
cls
echo.           ^|
echo.    \  /   ^|
echo.     \/    ^|
echo.___________^|
echo.
echo.
call :color %Colbackground%9
echo.
call :echo "                                               Coping files..."
echo.
call :echo "               ###############################################                                        @"
echo.
echo.  /-----------------------------------\
echo.  ^| I`m can coping updated files on   ^|   This version: !ver!
echo.  ^| this OS. Update? [Y\yes] [N\no]   ^| Server version: !return!
echo.  \-----------------------------------/
echo.
choice /c:yn > nul
if %errorlevel%==1 copy data\temp\upd\vgddata-main\vgd.bat vgd.bat /y > nul& goto boot

:module4
:: --- Loading all files and user settings
cls
echo.           ^|
echo.    \  /   ^|
echo.     \/    ^|
echo.___________^|
echo.
echo.
call :color %Colbackground%8
echo.
call :echo "                                           Loading files and user settings.."
echo.
call :echo "               #####################################################                                  @"
if not exist data\user call :usercreator
echo. [%time%] Loading "username"..
set /p name=<data\user\name.txt
echo. [%time%] Loaded "username".
echo. [%time%] Loading "custom-color".
(
	set /p Colbackground=
	set /p Coltext=
	) < data\user\color.txt
echo. [%time%] Loaded "custom-color".
color %Colbackground%%Coltext%
echo. [%time%] Set theme to "custom-color".
echo. [%time%] Start "explorer.exe".
:module5

:: --- DESKTOP
cls
goto apimode
goto module5


exit /b

:usercreator
cls
echo.           ^|
echo.    \  /   ^| Registering new user.
echo.     \/    ^|
echo.___________^|
echo.
echo.
echo. Enter the name:
set /p name=^> 
cls
echo.           ^|
echo.    \  /   ^| Registering new user.
echo.     \/    ^|
echo.___________^|
echo.
echo.
echo. Name "%name%" is correct?
echo.   [Y]   [N]
choice /c:yn > nul
if %errorlevel%==2 goto usercreator
md data\user\

echo.%name%>> data\user\name.txt
echo.7>> data\user\color.txt
echo.8>> data\user\color.txt
md data\user\files


exit /b

:apimode
cls
echo.        __    __
echo. \  /  ^| _   ^|  \
echo.  \/   ^|__^|  ^|__/  api mode.
echo.
:ApiModeCms
set ApiModeCms=
set /p ApiModeCms=^>
if not "%ApiModeCms%"=="" call :ApiModeListCms %ApiModeCms%
if not "%ApiModeCms%"=="" if "!errorlevel!"=="1" echo. Command "%ApiModeCms%" not exist in VGD-api.
goto ApiModeCms

:ApiModeListCms
set all=%*
if "%all:~0,4%"=="exit" ( goto boot)
if "%all:~0,4%"=="help" (
	echo.
	echo. exit
	echo. send ^<text^>
	echo. use ^<value^>
	echo.
	exit /b 2
	)
if "%all:~0,4%"=="send" (
	echo.%all:~-4%
	exit /b 2
	)
if "%all:~0,3%"=="use" (
	echo.
	echo. Goto "%all:~4%"? Api-mode not saved.
	echo.   [Y\yes] [N\no]
	choice /c:yn
	if !errorlevel!==1 goto %all:~4%
	exit /bat
	)

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
