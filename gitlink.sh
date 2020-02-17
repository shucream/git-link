#!/bin/zsh

DIR=$(cd $(dirname $0);pwd) 
PID_FILE="$DIR/etc/pid"
LOG_FILE="$DIR/etc/log"

usage_exit() {
    echo "Usage: $0 [-a] [-a 1000] [-d] [-b branch_name]" 1>&2
    echo "Options:"
    echo "  -h -> help"
    echo "  -a -> auto"
    echo "  -d -> daemon"
    echo "  -b -> branch"
    echo
    exit 1
}

nohup_func() {
    sleep 20
    echo "done"
}

# 時間ごとにadd commit push pullを行う
start_ever() {
    echo "Start ever "
    CURRENT_DIR=`pwd`
    DAEMON=$1
    touch $LOG_FILE
    touch $PID_FILE
    if [ "$DAEMON" = "true" ]; then
        "$DIR/start_ever.sh" $CURRENT_DIR $2 $3 > $LOG_FILE 2>&1 &
    else
        "$DIR/start_ever.sh" $CURRENT_DIR $2 $3
    fi
    echo $! > $PID_FILE
}

# git add にフックしてcommit push pullを行う
start_hock() {
    echo "Start hock"
}

start() {
    echo "Running check ..."
    status

    FLAG_A="false"
    FLAG_B="false"
    FLAG_D="false"
    VALUE_A=3000
    VALUE_B="$(git symbolic-ref --short HEAD)"
    shift
    while (( $# > 0 ))
    do
        case $1 in
            *)
                if [[ ! "$1" =~ ^-[adbh]$ ]]; then
                        usage_exit
                fi
                if [[ "$1" = '-a' ]]; then
                    FLAG_A="true"
                    if [[ "$2" =~ ^[0-9]+$ ]]; then
                        VALUE_A=$2
                        shift
                    fi
                fi
                if [[ "$1" = '-d' ]]; then
                    FLAG_D="true"
                fi
                if [[ "$1" = '-b' ]]; then
                    FLAG_B="true"
                    if [[ "$2" =~ ^.+$ ]]; then
                        VALUE_B=$2
                        shift
                    fi
                fi
                shift
                ;;
        esac
    done
    echo "----------------------------------------"
    echo "auto   | $FLAG_A"
    echo "daemon | $FLAG_D"
    echo "time   | ${VALUE_A}(s)"
    echo "branch | $VALUE_B"
    echo "----------------------------------------"
    if [ "$FLAG_A" = "true" ]; then
        start_ever $FLAG_D $VALUE_A $VALUE_B
    else
        start_hock $FLAG_D $VALUE_B
    fi
}

# pidを元にkill
stop() {
    echo "Stop"
    kill -9 $(cat $PID_FILE)
    echo "" > $PID_FILE
}

# pidの確認
status() {
    PID=$(cat $PID_FILE)
    if [ ! "$PID" = "0" ] && [ ! "$PID" = "" ]; then
        echo "Aleady Runnning at $PID"
        head -5 $LOG_FILE
        exit 0
    else
        echo "Not Running"
    fi
}

case "$1" in
    start)
    start $@
    ;;
    status)
    status
    ;;
    stop)
    stop
    ;;
    *)
    usage_exit
    ;;
esac