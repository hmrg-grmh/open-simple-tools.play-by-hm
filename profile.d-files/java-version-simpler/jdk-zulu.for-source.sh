JAVA_HOME_NOVER=/opt/sdk/jdk/zulu &&
JAVA_HOME_11=$JAVA_HOME_NOVER/zulu11.45.27-ca-jdk11.0.10-linux_x64 &&
JAVA_HOME_8=$JAVA_HOME_NOVER/zulu8.52.0.23-ca-jdk8.0.282-linux_x64 &&

function javahome_ver_11 () { echo $JAVA_HOME_11 ; } &&
function javahome_ver_8 () { echo $JAVA_HOME_8 ; } &&
function javahome_by_ver () { javahome_ver_${1:-8} ; } &&

JAVA_VER_SET=${JAVA_VER:-11} &&

JAVA_HOME=$(javahome_by_ver $JAVA_VER_SET) &&
echo JAVA_VER_SET:$JAVA_VER_SET &&
echo JAVA_HOME:$JAVA_HOME &&
PATH="$(echo $PATH | tr : '\n' | awk 'BEGIN{ORS=":"}!/'${JAVA_HOME_NOVER//\//\\\/}'/{print}END{printf"'$HOME'/bin"}')" &&

export JAVA_HOME &&
export PATH=$PATH:$JAVA_HOME/bin &&

java -version ;



######### usage #########
# export JAVA_VER=8
# . /etc/profile
######### or #########
# export JAVA_VER=11
# . /etc/profile

### to change ver of jdk in use .
