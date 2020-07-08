@echo off

set originTag=%1
set targetTag=%2
set sourceDir=%3

REM TARGET DIR NAME BASED ON FULL BUILD OR DELTA BUILD
set targetStructureDirName=%4

REM CURREN DIRECTORY LOCATION OF DEPLOY.BAT
set currentDirLocation=%~dp0

REM DIRECTORY OF JAR FILES
set jarFilesLocation=%~dp0/tools/lib/

echo.
call ant -buildfile %currentDirLocation%/build.xml copy
echo.

echo.
echo ############ SOURCE STRUCTURE TRANSFORMATION 		: STARTED ############
java -jar %jarFilesLocation%/PWCDeltaExtractor.jar master %originTag% %targetTag% %sourceDir%/
echo ############ SOURCE STRUCTURE TRANSFORMATION 		: END     ############

echo.
echo ############ PROCESS FOR JAR DEPENDENCY RESOLUTION	: STARTED ############
	for /f "delims=" %%A in ( ' java -jar %jarFilesLocation%/PWCTransformation.jar %repoBranchName% %originTag% %targetTag% %sourceDir%/ ' ) do set retvalue=%%A
	set %retvalue%
echo ############ PROCESS FOR JAR DEPENDENCY RESOLUTION	: ENDED   ############
echo.

REM echo ############ SOURCE CODE MODULES JAR CREATION BY ANT	    : STARTED ############
REM echo.
call ant -buildfile %currentDirLocation%/build.xml jar -DjarSrcCodeDir=%sourceDir%/distrib/%targetTag%/sourcecode/java -DjarDestDir=%targetStructureDirName%/server/enovia/WEB-INF/lib
REM echo.
REM echo ############ SOURCE CODE MODULES JAR CREATION BY ANT	    : ENDED   ############