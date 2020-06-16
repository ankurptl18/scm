@echo off

set originTag=%1
set targetTag=%2
set sourceDir=%3

REM TARGET DIR NAME BASED ON FULL BUILD OR DELTA BUILD
set targetStructureDirName=%4

REM CURREN DIRECTORY LOCATION OF DEPLOY.BAT
set currentDirLocation=%~dp0

REM DIRECTORY OF JAR FILES
set jarFilesLocation=%~dp0/tools

echo.
echo ############ SOURCE STRUCTURE TRANSFORMATION 	: STARTED ############
	java -jar %jarFilesLocation%/pwcSourceTransform.jar master %originTag% %targetTag% %sourceDir%/
echo ############ SOURCE STRUCTURE TRANSFORMATION 	: END     ############

echo.
echo ############ PROCESS FOR JAR DEPENDENCY RESOLUTION	: STARTED ############
	java -jar %jarFilesLocation%/PWCJarDependencyResolution.jar %targetTag% %sourceDir%/
echo ############ PROCESS FOR JAR DEPENDENCY RESOLUTION	: ENDED   ############
echo.

echo ############ SOURCE CODE JAR CREATION BY ANT	: STARTED ############
echo.
	call ant -buildfile %currentDirLocation%/build.xml jar -DjarSrcCodeDir=%sourceDir%/%targetTag%/sourcecode/java -DjarDestDir=%targetStructureDirName%
echo.
echo ############ SOURCE CODE JAR CREATION BY ANT	: ENDED   ############
