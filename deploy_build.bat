@echo off
REM setlocal enabledelayedexpansion

echo **************************************************************
echo ******************** SETTING UP PARAMETERS *******************
echo[
set repoBranchName=%1
echo Repository Brach Name	: %repoBranchName%
set originTag=%2
echo Repository Origin Tag	: %originTag%
set targetTag=%3
echo Repository Origin Tag	: %targetTag%
set sourceDir=%4
echo Source Directory	: %sourceDir%
set currentDir=%cd%
echo Current Directory	: %currentDir%
set targetStructureDirName=%sourceDir%/pwc.%repoBranchName%.%targetTag%/server/enovia/web-inf/lib/
echo[ 
echo **************************************************************

REM Source Directory validation
if "%~4"=="" (
    echo Considering the current directory for the checkout source code
	set sourceDir=%currentDir%
) else (
REM Printing all parameters provided to debug, if required
	echo Parameters: %*
)

REM Validating if origin tag is provided
if "%~2"=="" (
	echo **************************************************************
	echo ******************* FULL BUILD	: STARTS *********************
	echo[
	echo ############ PLEASE PROVIDE BELOW DETAILS #############
	echo[
	REM set /p repoUserName="Enter Repository User name : "
	REM set /p repoPassword="Enter Repository Password  : "
	echo[
	echo ############ TAKING FILES FROM REPOSITORY #############
	REM git clone --branch %targetTag% https://github.com/ankurptl18/scm.git %sourceDir%/%targetTag%/
	echo ############ ALL FILES HAS BEEN CHECKED OUT ###########
	echo[
	echo ############ PACKAGE TRANSFORMATION : STARTS ###########
	REM call %sourceDir%/%targetTag%/buildscripts/deploy.bat %originTag% %targetTag% %sourceDir%
	echo ############ PACKAGE TRANSFORMATION : END ###########
	
	set targetStructureDirName=%sourceDir%/pwc.%repoBranchName%.%targetTag%/server/enovia/web-inf/lib/
	
	echo ******************* FULL BUILD	: ENDS ***********************
	
) else (
	echo **************************************************************
	echo ********************* DELTA BUILD STARTS *********************
	REM set /p repoUserName="Enter Repository User name : "
	REM set /p repoPassword="Enter Repository Password  : "
	REM git clone --branch %originTag% https://github.com/ankurptl18/scm.git %sourceDir%/%originTag%/
	REM git clone --branch %targetTag% https://github.com/ankurptl18/scm.git %sourceDir%/%targetTag%/
	
	set targetStructureDirName=%sourceDir%/pwc.%repoBranchName%.%originTag%_%targetTag%/server/enovia/web-inf/lib/
	echo **************************************************************
)

echo **************************************************************
echo %sourceDir%/%targetTag%/buildscripts/
echo **************************************************************
call ant -buildfile %sourceDir%/%targetTag%/buildscripts/build.xml jar -DjarSrcCodeDir=%sourceDir%/%targetTag%/sourcecode/java -DjarDestDir=%targetStructureDirName%