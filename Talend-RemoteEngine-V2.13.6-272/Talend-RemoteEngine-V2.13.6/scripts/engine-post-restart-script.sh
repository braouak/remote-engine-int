#!/bin/sh

ENGINE_DIRECTORY="`pwd`"

JOB_SERVER_DIRECTORY="${ENGINE_DIRECTORY}/TalendJobServersFiles"
if [ ! -d $JOB_SERVER_DIRECTORY ];
then
  echo "warn: engine job server directory does not exist"
  exit 0
fi

ENGINE_CURRENT_PID_FILE="${ENGINE_DIRECTORY}/karaf.pid"
if [ ! -f $ENGINE_CURRENT_PID_FILE ];
then
  echo "warn: engine current process id file does not exist"
  exit 0
fi

ENGINE_PREVIOUS_PID_FILE="${ENGINE_DIRECTORY}/karaf.pid.bak"
if [ ! -f $ENGINE_PREVIOUS_PID_FILE ];
then
  echo "warn: engine previous process id file does not exist"
  exit 0
fi

collect_subjobs_pids ()
{
  local subjobs_pids="$(ps -o pid= --ppid $1)"

  for subjob_pid in ${subjobs_pids}
  do
    collect_subjobs_pids "${subjob_pid}"
  done

  echo "${subjobs_pids}"
}

ENGINE_CURRENT_PID="`head -1 ${ENGINE_CURRENT_PID_FILE}`"

LOG_FILE="${ENGINE_DIRECTORY}/data/log/engine-post-restart-script.log"

echo "--------------------------------------------------" >> $LOG_FILE
echo "`date` - engine restart detected" >> $LOG_FILE
echo "current engine process id - ${ENGINE_CURRENT_PID}" >> $LOG_FILE

ps -eo pid,ppid,ruser,etime,comm,args |
  grep 'java' |
#  grep '\-Dtalend\.component\.manager\.m2\.repository\=' | # -Dtalend.component.manager.m2.repository=
  grep '\-Dipaas\.reject\.file\=' |                        # -Dipaas.reject.file=
  grep '\-\-pid\=20' |                                     # --pid=yyyyMMddHHmmss_<salt-5-symbols>
  grep '\-\-context\=' |                                   # --context=
  grep '\-\-log4jLevel\=' |                                # --log4jLevel=
  while read JOB_PID JOB_PPID USER TIME COMM ARGS;
do
  JS_JOB_PID=$(echo "${ARGS}" | sed 's/.* --pid=\([A-Za-z0-9_]*\) .*/\1/g')
  echo """
found job execution:
    PID: $JOB_PID
    PPID: $JOB_PPID
    USER: $USER
    COMMAND LINE: $ARGS
    JS JOB PID: $JS_JOB_PID
    TIME ELAPSED: $TIME""" >> $LOG_FILE

  if [ "${ENGINE_CURRENT_PID}" = "${JOB_PPID}" ];
  then
    echo "  - the job execution belongs to the current engine process - ignoring it." >> $LOG_FILE
  else
    JOB_LOG_FILE="${JOB_SERVER_DIRECTORY}/jobexecutions/logs/${JS_JOB_PID}/stdOutErr_${JS_JOB_PID}.log"
    if [ ! -f $JOB_LOG_FILE ];
    then
      echo "  - the job execution has no corresponding 'stdOutErr_*.log' file - ignoring it." >> $LOG_FILE
    else
      JOBS_OPEN_FILES=`lsof -w -p ${JOB_PID} | grep ${JOB_SERVER_DIRECTORY}`
      if [ -z "$JOBS_OPEN_FILES" ];
      then
        echo "  - the job execution has no files open inside engine job server directory - ignoring it." >> $LOG_FILE
      else
        echo "  - the job execution is orphan from the engine previous start - ${JOB_PID} - killing it..." >> $LOG_FILE
        SUB_JOBS_PIDS=$(collect_subjobs_pids "${JOB_PID}")
        kill -9 $JOB_PID

        if [ "" != "$SUB_JOBS_PIDS" ];
        then
          echo "    - killing found sub jobs processes as well -" ${SUB_JOBS_PIDS} >> $LOG_FILE
          kill -9 $SUB_JOBS_PIDS
        fi
      fi
    fi
  fi

done

echo >> $LOG_FILE
