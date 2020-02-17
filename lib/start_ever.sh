#!/bin/zsh


DIR=$(dirname $(cd $(dirname $0);pwd)) 
PID_FILE="$DIR"
LOG_FILE="$DIR/etc/log"

trap 'echo "" > etc/pid' 2

TARGET_DIR=$1
INTERVAL_TIME=$2
TARGET_BRANCH=$3
echo "====================================="
echo "Target Directory  : $TARGET_DIR"
echo "Target Git Branch : $TARGET_BRANCH"
echo "Interval Time     : $INTERVAL_TIME"
echo "====================================="
echo 
# =========================================

cd $TARGET_DIR

while [ "1" = "1" ];
do
CURRENT_BRANCH="$(git symbolic-ref --short HEAD)"
if [ "$CURRENT_BRANCH" = "$TARGET_BRANCH" ]; then
    git add .
    git commit -m "auto commit"
    git push origin $TARGET_BRANCH
    git pull origin $TARGET_BRANCH
    echo "Success"
else
    echo "Fail by different branch $CURRENT_BRANCH"
fi
sleep $INTERVAL_TIME
done

# =========================================

echo "Ended."
echo "" > $PID_FILE
exit 1
