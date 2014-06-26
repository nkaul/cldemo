#!/bin/sh
HOME=`dirname $0`
cd $HOME
JAR="./lib/sflowrt.jar"
JVM_OPTS="-Dsflow.port=6343 -Xmx300M -Dscript.file=init.js,cumulus.js"
exec java ${JVM_OPTS} -jar ${JAR}

