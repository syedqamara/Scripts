PUBLIC_DIR=$1
GIT_URL=$2
APP_ID=$3
REPO_FOLDER_NAME=$4
function printMessage {
    printf '\n'
    echo "$(tput setaf 6)************************************  $1  ***********************************$(tput sgr0)"
    printf '\n'
}
REPO_FULL_PATH="${PUBLIC_DIR}${REPO_FOLDER_NAME}/${APP_ID}"
REPO_TEMP_PATH="${PUBLIC_DIR}${REPO_FOLDER_NAME}/${APP_ID}/Temp"
REPO_GIT_PATH="${PUBLIC_DIR}${REPO_FOLDER_NAME}/${APP_ID}/Temp/.git"
rm -Rf $REPO_FULL_PATH
mkdir $REPO_FULL_PATH
mkdir $REPO_TEMP_PATH
git clone $GIT_URL $REPO_TEMP_PATH --verbose

cp -R $REPO_GIT_PATH $REPO_FULL_PATH

rm -Rf $REPO_TEMP_PATH
