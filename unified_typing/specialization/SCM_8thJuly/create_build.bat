@echo off
setlocal EnableDelayedExpansion

REM Processing the input named paramters
REM Mandatory input : Branch name, Target tag
REM Optional  input : Origin tag, Source Directory path
REM create_build.bat --branchName=master --targetTag=202006160230 --originTag=202006081600 --sourceDir=<PATH>

goto :processInput

:setParam
REM EXTERNAL PROPERTY FILE IN ORDER TO OVERRIDE DEFAULT VALUES
set SERVER_BUILD_PROPERTIES_FILE=C:/Users/ANKUR/Desktop/build.properties
set repoBranchName=%--branchName%
set targetTag=%--targetTag%
set originTag=%--originTag%
set sourceDir=%--sourceDir%
set currentDir=%cd%
set fullBuildTargetDir=pwc.%repoBranchName%.build.%targetTag%/
set deltaBuildTargetDir=pwc.%repoBranchName%.build.%originTag%_%targetTag%/

REM CLEAN UP. TODO -- Create another batch file for cleanup purpose
REM IF EXIST "distrib" rmdir /Q /S "distrib"
REM IF EXIST "delta" rmdir /Q /S "delta"
REM IF EXIST %targetTag% rmdir /Q /S %targetTag%
REM IF EXIST %originTag% rmdir /Q /S %originTag%
REM IF EXIST %fullBuildTargetDir%  rmdir /Q /S %fullBuildTargetDir%
REM IF EXIST %deltaBuildTargetDir% rmdir /Q /S %deltaBuildTargetDir%
REM IF EXIST %sourceDir%/%targetTag% rmdir /Q /S %sourceDir%/%targetTag%
REM IF EXIST %sourceDir%/%originTag% rmdir /Q /S %sourceDir%/%originTag%

echo *************************************************************
echo ******************** SETTING UP PARAMETERS ******************
echo.

REM Branch name validation
if "%repoBranchName%"=="" (
	echo BRANCN Name IS MANDATORY
	echo ERROR : PLEASE PROVIDE THE BRANCH NAME. USE --branchName=value
	goto :done
) else (
	echo Repository brach name	: %repoBranchName%
)

REM Target tag validation
if "%targetTag%"=="" (
	echo TARGET TAG IS MANDATORY
	echo ERROR : PLEASE PROVIDE THE TARGET TAG. USE --targetTag=value
	goto :done
) else (
	echo Repository target tag	: %targetTag%
)

REM Target tag validation
echo Repository origin tag	: %originTag%

REM Source Directory validation
if "%sourceDir%"=="" (
	set sourceDir=%currentDir%
)

REM setting the source directory
echo Source Directory	: %sourceDir%

echo Full build target dir	: %fullBuildTargetDir%
echo Delta build target dir	: %deltaBuildTargetDir%

echo. 
echo *************************************************************
echo.

for /f "delims=" %%A in ( ' java -jar %~dp0/%targetTag%/buildscripts/build_engine/tools/lib/PWCTransformation.jar %repoBranchName% " " %targetTag% %sourceDir%/ ' ) do set retvalue=%%A
set %retvalue%
pause

REM Validating if origin tag is provided
if "%originTag%"=="" (

	echo *************************************************************
	echo ******************* FULL BUILD	: STARTS *********************
	echo.
	
	echo ############ GIT CHECKOUT : STARTS  #############

	REM git clone --branch %targetTag% https://github.com/ankurptl18/scm.git %sourceDir%/%targetTag%/
	
	REM deleting the .git directory
	IF EXIST "%sourceDir%/%targetTag%/.git" rmdir /Q /S "%sourceDir%/%targetTag%/.git"
	
	echo ############ GIT CHECKOUT : ENDS    #############
	echo.
	
	echo ############ PACKAGE TRANSFORMATION : STARTS ###########
		REM for /f "delims=" %%A in ( ' java -jar %~dp0/%targetTag%/buildscripts/build_engine/tools/lib/PWCTransformation.jar %repoBranchName% " " %targetTag% %sourceDir%/ ' ) do set retvalue=%%A
		REM set %retvalue%
	echo ############ PACKAGE TRANSFORMATION : END ###########
	
	echo ############ SOURCE CODE JAR CREATION BY ANT	    : STARTED ############
	echo.
	call ant -buildfile %~dp0/%targetTag%/buildscripts/build_engine/build.xml jar -DjarSrcCodeDir=%sourceDir%/%targetTag%/sourcecode/java -DjarDestDir=%sourceDir%/%fullBuildTargetDir%/server/enovia/WEB-INF/lib
	echo.
	echo ############ SOURCE CODE JAR CREATION BY ANT	    : ENDED   ############
	
	echo ******************* FULL BUILD	: ENDS ***********************
	goto :done
	
) else (

	echo *************************************************************
	echo ********************* DELTA BUILD STARTS ********************
	echo.
	
	echo ############ GIT CHECKOUT : STARTS  #############
	
	REM git clone --branch %originTag% https://github.com/ankurptl18/scm.git %sourceDir%/%originTag%/
	REM git clone --branch %targetTag% https://github.com/ankurptl18/scm.git %sourceDir%/%targetTag%/
	
	REM deleting the .git directory
	IF EXIST "%sourceDir%/%originTag%/.git" rmdir /Q /S "%sourceDir%/%originTag%/.git"
	IF EXIST "%sourceDir%/%targetTag%/.git" rmdir /Q /S "%sourceDir%/%targetTag%/.git"
	
	echo ############ GIT CHECKOUT : ENDS    #############
	echo.
	
	echo ############ BUILD PROCEDURE : STARTS ###########
		call %sourceDir%/%targetTag%/buildscripts/build_engine/build.bat %originTag% %targetTag% %sourceDir% %sourceDir%/%deltaBuildTargetDir%
	echo ############ BUILD PROCEDURE : ENDS   ###########   
		
	echo ********************* DELTA BUILD ENDS **********************
	goto :done
)

:processInput
set max_count=20
for /l %%# in (1,2,%max_count%) do (
	set /a next=%%#+1	
	set curr=%%#
	call set "%%~!curr!=%%~!next!" 2>nul
)
goto :setParam

:done
echo. 
echo *************************************************************

REM IF EXIST "distrib" rmdir /Q /S "distrib"