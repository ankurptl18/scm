@echo off
setlocal enabledelayedexpansion

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

REM Validating if origin tag is provided
if "%~2"=="" (
	echo **************************************************************
	echo ******************* FULL BUILD	: STARTS *********************
	
	echo.
	echo ############ PLEASE PROVIDE BELOW DETAILS #############
	echo.
		set /p repoUserName="Enter Repository User name : "
		set /p repoPassword="Enter Repository Password  : "
	echo.
	
	echo ############ TAKING FILES FROM REPOSITORY #############
		git clone --branch %targetTag% https://github.com/ankurptl18/scm.git %sourceDir%/%targetTag%/
	
	echo ############ ALL FILES HAS BEEN CHECKED OUT ###########
	echo.
	
	set targetStructureDirName=%sourceDir%/pwc.%repoBranchName%.%targetTag%/
	
	echo ############ PACKAGE TRANSFORMATION : STARTS ###########
		call %sourceDir%/%targetTag%/buildscripts/deploy.bat %originTag% %targetTag% %sourceDir% %targetStructureDirName%
	echo ############ PACKAGE TRANSFORMATION : END ###########
	
	echo ******************* FULL BUILD	: ENDS ***********************
	
) else (
	echo **************************************************************
	echo ********************* DELTA BUILD STARTS *********************
	
		set /p repoUserName="Enter Repository User name : "
		set /p repoPassword="Enter Repository Password  : "

	echo.
	echo ############ TAKING FILES FROM REPOSITORY #############
	
	REM git clone --branch %originTag% https://github.com/ankurptl18/scm.git %sourceDir%/%originTag%/
	REM git clone --branch %targetTag% https://github.com/ankurptl18/scm.git %sourceDir%/%targetTag%/
	
	echo ############ ALL FILES HAS BEEN CHECKED OUT ###########
	echo.
	
	set targetStructureDirName=%sourceDir%/pwc.%repoBranchName%.%originTag%_%targetTag%/
	echo %targetStructureDirName%
	echo ############ BUILD PROCEDURE : STARTS 		 ###########   
		call %sourceDir%/%targetTag%/buildscripts/build_engine/deploy.bat %originTag% %targetTag% %sourceDir% %targetStructureDirName%
	echo ############ BUILD PROCEDURE : ENDS 		 ###########   
		
	echo **************************************************************
)
