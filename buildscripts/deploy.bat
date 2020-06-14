@echo off

set originTag=%1
set targetTag=%2
set sourceDir=%3

echo ############ SOURCE STRUCTURE TRANSFORMATION 		: STARTED ############
java -jar %sourceDir%/%targetTag%/buildscripts/build_engine/tools/pwcSourceTransform.jar master %originTag% %targetTag% %sourceDir%/
echo ############ SOURCE STRUCTURE TRANSFORMATION 		: END     ############
echo ############ PROCESS FOR JAR DEPENDENCY RESOLUTION	: STARTED ############
java -jar %sourceDir%/%targetTag%/buildscripts/build_engine/tools/PWCJarDependencyResolution.jar %targetTag% %sourceDir%/
echo ############ PROCESS FOR JAR DEPENDENCY RESOLUTION	: ENDED   ############
