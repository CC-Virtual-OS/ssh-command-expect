#!/bin/bash
#test Paolo Fruci
check_telnet()
{
    MYPID=$$
    SERVER=$1
    PORT=$2
    TMP_LOG_TEL=/tmp/tmp_log_tel.tmp
    
    #eseguo il test di telnet
    ( echo open $SERVER $PORT ; sleep 2 ; echo ^] ;sleep 2; echo ^C ) | telnet  2>&1 > $TMP_LOG_TEL &
    
    #verifico se dopo 3 secondi è ancora appeso il telnet
    sleep 2
    TELPID=`ps -ef | grep telnet | grep ${MYPID} | grep -v grep |  awk '{print $2}'`
    if [ "${TELPID}" = "" ]
            then
                    LIVETEL=0
            else
                    LIVETEL=`ps -ef | grep telnet | grep ${TELPID} | grep -v grep |  wc -l`
    fi
    #se sono ancora presenti pid telnet li killo
    if [ ${LIVETEL} -ne 0 ]
    then
            kill -9 ${TELPID}
    fi
    #cerco nel log la stringa Connected
    cat ${TMP_LOG_TEL} | grep -i Connected &> /dev/null
    
    if [ $? -ne 0 ]
    then
            return 99
    else
            return 0
    fi
    #rimuovo il file di log temporaneo
    rm -f ${TMP_LOG_TEL}
}
check_telnet $1 $2  &> /dev/null
if [ $? -ne 0 ]
then
	echo "KO"
else
    echo "OK"
fi
