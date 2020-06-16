@echo off
setlocal EnableDelayedExpansion

set SERVER_BUILD_PROPERTIES_FILE=C:/Users/ANKUR/Desktop/build.properties

echo **************************************************************
echo ******************** SETTING UP PARAMETERS *******************
echo.
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

echo. 
echo **************************************************************

REM Source Directory validation
if "%~4"=="" (
    echo Considering the current directory for the checkout source code
	set sourceDir=%currentDir%
) else (
REM Printing all parameters provided to debug, if required
	echo Parameters: %*
)

set deltaBuildTargetStrDirName=%sourceDir%/pwc.%repoBranchName%.%originTag%_%targetTag%/
set fullTargetStrDirName=%sourceDir%/pwc.%repoBranchName%.%targetTag%/

REM rmdir /Q /S "%sourceDir%/%originTag%/.git"
REM rmdir /Q /S "%sourceDir%/%targetTag%/.git"

echo.
echo ############ PLEASE PROVIDE BELOW DETAILS #############
echo.
	set /p repoUserName="Enter Repository User name : "
	set /p repoPassword="Enter Repository Password  : "
echo.

REM Validating if origin tag is provided
if "%~2"=="" (
	echo **************************************************************
	echo ******************* FULL BUILD	: STARTS *********************
		
	echo ############ TAKING FILES FROM REPOSITORY #############
	git clone --branch %targetTag% https://github.com/ankurptl18/scm.git %sourceDir%/%targetTag%/
	
	rmdir /Q /S "%sourceDir%/%targetTag%/.git"
	
	echo ############ ALL FILES HAS BEEN CHECKED OUT ###########
	echo.
	
	echo ############ PACKAGE TRANSFORMATION : STARTS ###########
		call %sourceDir%/%targetTag%/buildscripts/build_engine/deploy.bat %originTag% %targetTag% %sourceDir% %fullBuildTargetStrDirName%
	echo ############ PACKAGE TRANSFORMATION : END ###########
	
	echo ******************* FULL BUILD	: ENDS ***********************
	
) else (
	echo **************************************************************
	echo ********************* DELTA BUILD STARTS *********************
	
	git clone --branch %originTag% https://github.com/ankurptl18/scm.git %sourceDir%/%originTag%/
	git clone --branch %targetTag% https://github.com/ankurptl18/scm.git %sourceDir%/%targetTag%/
	
	rmdir /Q /S "%sourceDir%/%originTag%/.git"
	rmdir /Q /S "%sourceDir%/%targetTag%/.git"
	
	echo ############ ALL FILES HAS BEEN CHECKED OUT ###########
	echo.
	
	echo ############ BUILD PROCEDURE : STARTS 		 ###########   
		call %sourceDir%/%targetTag%/buildscripts/build_engine/deploy.bat %originTag% %targetTag% %sourceDir% %deltaBuildTargetStrDirName%
	echo ############ BUILD PROCEDURE : ENDS 		 ###########   
		
	echo ********************* DELTA BUILD ENDS *********************
)
