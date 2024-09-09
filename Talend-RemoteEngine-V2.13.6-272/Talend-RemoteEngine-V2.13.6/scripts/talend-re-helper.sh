#!/bin/bash
JAVA="java"
if test -n "$JAVA_HOME"; then
    JAVA="$JAVA_HOME/bin/java"
fi
exec "$JAVA" -jar talend-re-helper.jar "$@"