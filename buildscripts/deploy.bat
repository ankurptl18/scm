@echo off

set originTag=%1
set targetTag=%2
set sourceDir=%3

echo STARTED TRANSFORMING THE SOURCE PACKAGE
java -jar pwcSourceTransform.jar master %originTag% %targetTag% %sourceDir%/
echo ENDED TRANSFORMING THE SOURCE PACKAGE
echo STARTED JAR DEPENDENCY RESOLUTION
java -jar PWCJarDependencyResolution.jar %targetTag% %sourceDir%/
echo ENDED TRANSFORMING THE SOURCE PACKAGE