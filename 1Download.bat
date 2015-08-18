@ECHO OFF
SETLOCAL EnableDelayedExpansion 

CALL "%VS120COMNTOOLS%\vsvars32.bat"

set THIS=%CD%
set DOWNLOAD=%CD%\download
set TOOLS=%CD%\tools
set SRC=%CD%\src
set WGET=%TOOLS%\wget.exe
set UNTAR=%TOOLS%\7za.exe 
set SERVER_PATH=Public/xr-libs
set SERVER_HOSTNAME=ftp://xordi.noip.me
set WGET_FAILMSG=
set LF=^



IF %PROCESSOR_ARCHITECTURE%=="IA64" OR IF %PROCESSOR_ARCHITECTURE%=="AMD64" (
  SET WGET=%TOOLS%\wget64.exe
  SET UNTAR=%TOOLS%\x64\7za.exe 
  )
echo ---WGET found in %WGET%---

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
	%UNTAR% x %%G  -r
)

FOR /F "tokens=*" %%G IN ('dir /B "*.tar"') DO (
	%UNTAR% x %%G  -r -o%SRC%
)















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

