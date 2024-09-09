@echo off
SET JAVA=java
if defined JAVA_HOME (
  SET JAVA="%JAVA_HOME%\bin\java"
)
""%JAVA%"" -jar talend-re-helper.jar %*