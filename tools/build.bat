@ECHO OFF
REM Docker simple build
REM %1 - Docker image
REM %2 - (Optional) Additional build options (ex. --no-cache)
MD %TEMP%\docker-build
XCOPY /E /Y ..\*.* %TEMP%\docker-build
docker build %2 -t %1 %TEMP%\docker-build
RD /S /Q %TEMP%\docker-build