#Script Param

GIT_URL=$1
BRANCH=$2
BUILD_ID=$3
BUILD_MODE=$4
POD_COMMAND=$5
TOKEN=$6
PUBLIC_DIR=$7
APP_ID=$8
REPO_FOLDER_NAME=$9
XCPROJ_NAME=$10
XCPROJ_PATH=$11
SCHEME_NAME=$12




REPO_FULL_PATH="${PUBLIC_DIR}${REPO_FOLDER_NAME}/${APP_ID}/.git"
SCRIPT_DIRECTORY="${PUBLIC_DIR}scripts/"

SCRIPT_DEPENDENCY_IOS="${PUBLIC_DIR}scripts/dependencies_ios.sh"
SCRIPT_AWS="${PUBLIC_DIR}scripts/aws_build.sh"
SCRIPT_ARCHIVE="${PUBLIC_DIR}scripts/archive.sh"


function printMessage {
    printf '\n'
    echo "$(tput setaf 6)************************************  $1  ***********************************$(tput sgr0)"
    printf '\n'
}
function copyScript {
    SCRIPT=$1
    cp -R $SCRIPT .
}

clear
if [ -z "$BRANCH" ]; then
    printMessage "Please Enter Branch Name"
    exit
fi
mkdir $BUILD_ID

printMessage "Copying Already Checkout Repo"

cp -R $REPO_FULL_PATH $BUILD_ID

cd $BUILD_ID


git fetch
git checkout -f $BRANCH
git pull origin $BRANCH

printMessage "Copying Scripts"

copyScript $SCRIPT_DEPENDENCY_IOS
copyScript $SCRIPT_AWS
copyScript $SCRIPT_ARCHIVE

printMessage "Running Deployment"
chmod 777 ./dependencies_ios.sh
./dependencies_ios.sh $BUILD_ID $BUILD_MODE $POD_COMMAND $PUBLIC_DIR $TOKEN $XCPROJ_NAME $XCPROJ_PATH $SCHEME_NAME



#./checkout.sh https://github.com/syedqamara/QUGenderView.git master 123456789 enterprise install cVdxqTL71LpuxbEQr390/9nVq+cQb6Pxe9QICoM69q+ompa3NoGkhMFvb0AhwMF46/yJ2g== /Users/syedqamarabbas/Xtreme-Vapor/Xtreme-Vapor/Public

 
