#!/bin/sh

[ -f /usr/bin/tar ] && [ -z "$TAR" ] && TAR="/usr/bin/tar --warning=no-file-unchanged" 
[ -f /usr/local/bin/tar ] && [ -z "$TAR" ] && TAR="/usr/local/bin/tar --warning=no-file-unchanged"
[ -f /bin/tar ] && [ -z "$TAR" ] && TAR=/bin/tar
[ -f /usr/bin/gzip ] && [ -z "$GZIP" ] && GZIP="/usr/bin/gzip" 
[ -f /usr/local/bin/gzip ] && [ -z "$GZIP" ] && TAR="/usr/local/bin/gzip"
[ -f /bin/gzip ] && [ -z "$GZIP" ] && GZIP=/bin/gzip
[ -f /usr/bin/wol ] && [ -z "$WOL" ] && WOL=/usr/bin/wol
[ -f /usr/sbin/ether-wake ] && [ -z "$WOL" ] && WOL=/usr/sbin/ether-wake

# source settings
. /mod/etc/conf/tar.cfg

if [ "${TAR_ENABLED}" != "yes" ]; then
  exit
elif [ -z "${TAR_TO_BE_BACKUPED_DIRECTORY}" ]; then
  echo "backup directory not set" 1>&2
  exit 1
elif [ -z "${TAR_ARCHIVE_STORAGE_LOCATION}" ]; then
  TAR_ARCHIVE_STORAGE_LOCATION=${TAR_TO_BE_BACKUPED_DIRECTORY}/backups
fi

# with verify
if [ "/bin/tar" = "$TAR" ]; then 
OPTS="-cvpf"   # use busybox tar without verify
else
OPTS="-cvlWpf" # with check links and verify of archive
fi
DEVICE=$(uname -n)

if [ ! -d "$TAR_ARCHIVE_STORAGE_LOCATION" ] ; then mkdir -p $TAR_ARCHIVE_STORAGE_LOCATION; fi
BASENAME=$(echo $TAR_ARCHIVE_STORAGE_LOCATION/$(uname -n)_backup)
ERROR_LOG=$TAR_ARCHIVE_STORAGE_LOCATION/error_$(date +%Y-%m-%d).log
LOG_FILE=$TAR_ARCHIVE_STORAGE_LOCATION/files_$(date +%Y-%m-%d).log

DIR="--directory=$TAR_TO_BE_BACKUPED_DIRECTORY"

EXCLUDES="--exclude=*.o --exclude=.deps --exclude=.libs --exclude=external --exclude=backups"
for ex in ${TAR_EXCLUDES}; do
  EXCLUDES=" ${EXCLUDES} --exclude=$ex"
done

INCLUDES=
for inc in ${TAR_INCLUDES}; do
  [ -e $inc ] || continue
  INCLUDES=" ${INCLUDES} $inc"
done

PART=full

HAS_GETOPT=1
getopt . 2> /dev/null
ret=$?
if [ $ret -ne 0 ] ; then
    HAS_GETOPT=0
fi

if [ $HAS_GETOPT -eq 1 ] ; then
    set -- `getopt "if" "$@"`

    while [ ! -z "$1" ] ; do
    case "$1" in
	-f)
	NEWER=
	PART=full
	;;
	-i)
	NEWER=--newer
	PART=incr
	;;
	*) break;;
    esac
      
    shift
    done
else
    PART=full
    echo "$@" | grep -qs '\-f' && PART=full
    echo "$@" | grep -qs '\-i' && PART=incr
fi

if [ -n "$NEWER" ] ; then
    #LAST_BACKUP_DATE=$(ls $(echo $BASENAME* | sed 's~/tmp~~') | sort | sed 's/.tar.*//' | awk -F _ '{ date=$4 } END {print date}')
    LAST_BACKUP_DATE=$(date +%Y-%m-01)
    NEWER="$NEWER=${LAST_BACKUP_DATE}T00:00:00"
fi
FILE=${BASENAME}_${PART}_$(date +%Y-%m-%d).tar

for service in ${TAR_SERVICESSTART_STOP}; do
  if [ -e $service ]; then
    $service stop  2>> $ERROR_LOG
  elif [ -e /mod/etc/init.d/rc.$service ]; then
    /mod/etc/init.d/rc.$service stop 2>> $ERROR_LOG
  elif [ -e /mod/etc/init.d/$service ]; then
    /mod/etc/init.d/$service stop 2>> $ERROR_LOG
  elif [ -e /etc/init.d/rc.$service ]; then
    /etc/init.d/rc.$service stop 2>> $ERROR_LOG
  else
    /etc/init.d/$service stop 2>> $ERROR_LOG
  fi
done
sleep 60

TZ=$(echo $TZ | cut -d- -f1-2)
[ -n $TZ ] && export TZ || export TZ="Europe/Paris"
$TAR $NEWER $OPTS $FILE $DIR $EXCLUDES . $INCLUDES 2>> $ERROR_LOG >> $LOG_FILE
return=$?

tar_error=$return
if [ $return -ne 0 ] ; then
   #cat $ERROR_LOG | logger -t TAR
   echo "tar return: $return" >> $ERROR_LOG
   cat $ERROR_LOG
else
   rm -f $ERROR_LOG
fi

for service in ${TAR_SERVICESSTART_STOP}; do
  if [ -e $service ]; then
    $service start  2>> $ERROR_LOG
  elif [ -e /mod/etc/init.d/rc.$service ]; then
    /mod/etc/init.d/rc.$service start 2>> $ERROR_LOG
  elif [ -e /mod/etc/init.d/$service ]; then
    /mod/etc/init.d/$service start 2>> $ERROR_LOG
  elif [ -e /etc/init.d/rc.$service ]; then
    /etc/init.d/rc.$service start 2>> $ERROR_LOG
  else
    /etc/init.d/$service start 2>> $ERROR_LOG
  fi
  sleep 3
done

gzip_error=0
EXT=".gz"
if [ -f $FILE ]; then
  $GZIP $FILE 2>> $ERROR_LOG
  if [ $? -eq 0 ] && [ "/bin/gzip" != "$GZIP" ]; then
    $GZIP -t $FILE 2>> $ERROR_LOG
    if [ $? -eq 0 ]; then
      [ -e $FILE ] && rm $FILE
    else
      gzip_error=1
      EXT=""
      [ -e $FILE.gz ] && rm $FILE.gz
    fi
  elif [ $? -ne 0 ]; then
     gzip_error=1
     EXT=""
     [ -e $FILE.gz ] && rm $FILE.gz
  fi
fi

if [ -n "${TAR_WOL_TRANSFER_STATION_MAC}" ]; then
  STATION_MAC=$(echo ${TAR_WOL_TRANSFER_STATION_MAC} | tr -s '-' ':')
  if [ "$(basename ${WOL})" == "wol" ]; then
    WOL_OPT="-w 5000 -h"
    # finds all broadcast ip addresses
    ADDRESSES=$(for f in $(ifconfig | sed 's/ \+/\t/g' | cut -f1 | tr -s "\n" | tr -c "\n"); do set -- $(ifconfig ${f} | grep Bcast:); echo ${3#*:}; done | tr -s "\n" " ")
  else
    WOL_OPT="-b -i"
    # finds all interface names with broadcast ip addresses
    ADDRESSES=$(for f in $(ifconfig | sed 's/ \+/\t/g' | cut -f1 | tr -s "\n" | tr -c "\n"); do ifconfig ${f} | grep -qs Bcast || echo ${f}; done | tr -s "\n" " ")
  fi
  WOL_BCAST=
  for addr in $ADDRESSES; do
    $WOL $WOL_OPT $addr $STATION_MAC >> $ERROR_LOG 2>&1; sleep 3
    $WOL $WOL_OPT $addr $STATION_MAC >> $ERROR_LOG 2>&1; sleep 3
    $WOL $WOL_OPT $addr $STATION_MAC >> $ERROR_LOG 2>&1; sleep 3
  done
fi
if [ -n "${TAR_TRANSFER_CMD}" ] && [ -n "${TAR_REMOTE_DIRNAME}" ]; then
  if [ "${TAR_PREPEND_REMOTE_FILENAME}" = "yes" ]; then
    PREPEND_FILE=${TAR_REMOTE_DIRNAME}/$(basename $FILE)$EXT
    POSTPEND_FILE=
    PREPEND_LOG=${TAR_REMOTE_DIRNAME}/$(basename $LOG_FILE)
    POSTPEND_LOG=
    PREPEND_ERR=${TAR_REMOTE_DIRNAME}/$(basename $ERROR_LOG)
    POSTPEND_ERR=
  else
    PREPEND_FILE=
    POSTPEND_FILE=${TAR_REMOTE_DIRNAME}/$(basename $FILE)$EXT
    PREPEND_LOG=
    POSTPEND_LOG=${TAR_REMOTE_DIRNAME}/$(basename $LOG_FILE)
    PREPEND_ERR=
    POSTPEND_ERR=${TAR_REMOTE_DIRNAME}/$(basename $ERROR_LOG)
  fi
  ${TAR_TRANSFER_CMD} $PREPEND_FILE $FILE$EXT $POSTPEND_FILE >> $ERROR_LOG 2>&1 || \
  ${TAR_TRANSFER_CMD} $PREPEND_FILE $FILE$EXT $POSTPEND_FILE >> $ERROR_LOG 2>&1
  ret=$?
  ${TAR_TRANSFER_CMD} $PREPEND_LOG $LOG_FILE $POSTPEND_LOG >> $ERROR_LOG 2>&1
  if [ $ret -ne 0 ] || [ $gzip_error -ne 0 ] || [ $tar_error -ne 0 ]; then
    ${TAR_TRANSFER_CMD} $PREPEND_ERR $ERROR_LOG $POSTPEND_ERR >> $ERROR_LOG 2>&1
  fi
fi
if [ $ret -ne 0 ] || [ $gzip_error -ne 0 ] || [ $tar_error -ne 0 ]; then
  #cat logger -t TAR
  cat $ERROR_LOG
  return=100
fi
if [ $ret -eq 0 ]; then
  rm $ERROR_LOG
  [ -f "$FILE$EXT" ] && rm -f $FILE$EXT
  [ -f "$LOG_FILE" ] && rm -f $LOG_FILE
fi
find . -name "*[(error_|files_|backup_)]*.[(log|tar)]*" -mtime 30 -exec rm {} \;

exit $return
