@ECHO OFF
SETLOCAL EnableDelayedExpansion 

CALL "%VS120COMNTOOLS%\vsvars32.bat"

set THIS=%CD%
set THIS_INCLUDE=%THIS%\include
set THIS_BIN=%THIS%\bin
set THIS_LIB=%THIS%\lib


set DOWNLOAD=%CD%\download
set TOOLS=%CD%\tools
set SRC=%CD%\src
set WGET=%TOOLS%\wget.exe
set UNTAR=%TOOLS%\7za.exe 
set SED=%TOOLS%\sed.exe
set SERVER_PATH=Public/xr-libs
set SERVER_HOSTNAME=ftp://xordi-nas
set WGET_FAILMSG=
set LF=^



IF %PROCESSOR_ARCHITECTURE%=="IA64" OR IF %PROCESSOR_ARCHITECTURE%=="AMD64" (
  SET WGET=%TOOLS%\wget64.exe
  SET UNTAR=%TOOLS%\x64\7za.exe 
  )
echo ---WGET found in %WGET%---

IF NOT EXIST %THIS_BIN% mkdir %THIS_BIN%
IF NOT EXIST %THIS_INCLUDE% mkdir %THIS_INCLUDE%
IF NOT EXIST %THIS_LIB% mkdir %THIS_LIB%
IF NOT EXIST %DOWNLOAD% mkdir %DOWNLOAD%
IF NOT EXIST %SRC% mkdir %SRC%

ECHO --- Pobieranie listy plik坦w do pobrania ---
CALL %WGET% -nc -P %DOWNLOAD% %SERVER_HOSTNAME%/%SERVER_PATH%/list.txt

FOR /F "tokens=1 eol=;" %%G IN (%DOWNLOAD%\list.txt) DO (
	ECHO Checking for %%G....
	IF NOT EXIST %DOWNLOAD%\%%G (
	%WGET% -nc -P %DOWNLOAD% %SERVER_HOSTNAME%/%SERVER_PATH%/%%G
	echo %errorlevel%
	) ELSE (
		ECHO Already have %%G source tarball.
	)
	
	IF NOT EXIST %DOWNLOAD%\%%G (
		CALL :WGETFAIL %%G
	)
)
IF DEFINED WGET_FAILMSG goto :FAIL

echo 浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
echo � Extracting...                                                 �
echo 藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
cd %DOWNLOAD%

FOR /F "tokens=1 eol=;" %%G IN (list.txt) DO (
	%UNTAR% x %%G  -r -y
)

FOR /F "tokens=*" %%G IN ('dir /B "*.tar"') DO (
	%UNTAR% x %%G  -y -r -o%SRC%
)

echo %SED% -i "s/1\.2\.8/1\.2/" %THIS%\src\zlib-1.2.8\contrib\vstudio\vc11\zlibvc.def
%SED% -i "s/1\.2\.8/1\.2/" %THIS%\src\zlib-1.2.8\contrib\vstudio\vc11\zlibvc.def
xcopy %TOOLS%\msvc\* %SRC% /I /Y












CALL :END

:WGETFAIL
SETLOCAL
set NEWMSG=Failed to download %1 source tarball.
ENDLOCAL & SET WGET_FAILMSG=!WGET_FAILMSG!� %NEWMSG%!LF!
goto :eof

:FAIL
echo 浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
echo !WGET_FAILMSG!
echo 藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�

:END

