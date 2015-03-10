#!/bin/bash

function include(){
    curr_dir=$(cd $(dirname "$0") && pwd)
    inc_file_path=$curr_dir/$1
    if [ -f "$inc_file_path" ]; then
        . $inc_file_path
    else
        echo -e "$inc_file_path not found!"
        exit 1
    fi
}
include "common.sh"

get_os
[[ $? -ne 0 ]] && exit 1
if [[ "$DistroBasedOn" != "redhat" ]]; then
    DEBUGLVL=4
    log "ERROR: We are sorry, only \"redhat\" based distribution of Linux supported for this service type, exiting!"
    exit 1
fi

bash installer.sh -p sys -i "java-devel"

/usr/share/tomcat/bin/shutdown.sh
cd /usr/share/tomcat/webapps

rm -rf petclinic*

wget $1

mkdir petclinic
cd petclinic

jar -xvf ../petclinic.war
cd ..
rm petclinic.war

sed -e "s/PET_DB/pet_db/" -i /usr/share/tomcat/webapps/petclinic/WEB-INF/classes/db/mysql/initDB.sql


#  return installApp('{0} {1} {2} {3} {4}'.format(args.warLocation, args.username, args.password, args.driverName, args.connectionStr)).stdout

export JAVA_OPTS="$JAVA_OPTS -Djdbc.driverClassName=$4"
export JAVA_OPTS="$JAVA_OPTS -Djdbc.url=$5"
export JAVA_OPTS="$JAVA_OPTS -Djdbc.username=$2"
export JAVA_OPTS="$JAVA_OPTS -Djdbc.password=$3"


if [[ $string == *"mysql"* ]]
then
  export JAVA_OPTS="$JAVA_OPTS -Djdbc.initLocation=classpath:db/mysql/initDB.sql"
  export JAVA_OPTS="$JAVA_OPTS -Djdbc.dataLocation=classpath:db/mysql/populateDB.sql"

  export JAVA_OPTS="$JAVA_OPTS -Dhibernate.dialect=org.hibernate.dialect.MySQLDialect"
  export JAVA_OPTS="$JAVA_OPTS -Djpa.database=MYSQL"

fi

/usr/share/tomcat/bin/startup.sh

