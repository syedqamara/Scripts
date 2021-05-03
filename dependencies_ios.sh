#POD_NAME=$1
#VERSION=$2
#BRANCH=$3

BUILD_ID=$1
BUILD_MODE=$2
POD_COMMAND=$3
BUILD_TEMP_FOLDER=$4
TOKEN=$5
XCPROJ_NAME=$6
XCPROJ_PATH=$7
SCHEME_NAME=$8

function printMessage {
    printf '\n'
    echo "$(tput setaf 6)************************************  $1  ***********************************$(tput sgr0)"
    printf '\n'
}
function byeMessage {
    printf '\n'
    echo "$(tput setaf 6)************************************  $1  ***********************************$(tput sgr0)"
    printf '\n'
}

POD_LOCK="Podfile.Lock"
PODS="Pods"

cd Example

function pod_reset {
    printMessage "Removing Previous Pods"
    rm -Rf $POD_LOCK
    rm -Rf $PODS
}
function pod_install {
    printMessage "Installing Cocoapods...\n"
    if pod install --verbose; then
        echo "Pod installed"
    else
        byeMessage "Failed to install Pods"
        exit
    fi
}
function pod_update {
    printMessage "Updating Cocoapods...\n"
    if pod update --verbose; then
        echo "Pod updated"
    else
        byeMessage "Failed to Update Pods"
        exit
    fi
}
function pod_repo_update {
    printMessage "Updating Cocoapods Repo...\n"
    if pod repo update --verbose; then
        echo "Pod updated"
        pod_update
    else
        byeMessage "Failed to Update Pods"
        exit
    fi
}
function archive {
    BUILD_ID=$1
    BUILD_MODE=$2
    PUBLIC_FOLDER=$3
    TOKEN=$4
    XCPROJ_NAME=$5
    XCPROJ_PATH=$6
    SCHEME_NAME=$7
    
    BUILD_TEMP_FOLDER="${PUBLIC_FOLDER}/Temp/builds"
    
    printMessage "Archieving Project..."
    cd ..
    chmod 777 archive.sh
    ./archive.sh $XCPROJ_NAME $SCHEME_NAME $BUILD_ID $BUILD_MODE $XCPROJ_PATH $BUILD_TEMP_FOLDER
    printMessage "Uploading Build..."
    chmod 777 aws_build.sh
    ./aws_build.sh $BUILD_ID $BUILD_TEMP_FOLDER $XCPROJ_NAME $TOKEN
    rm -Rf "${PUBLIC_FOLDER}/scripts/${BUILD_ID}"
}




if [[ "$POD_COMMAND" = "reset" ]]; then
    pod_reset
    pod_install
elif [[ "$POD_COMMAND" = "install" ]]; then
    pod_install
elif [[ "$POD_COMMAND" = "update" ]]; then
    pod_update
elif [[ "$POD_COMMAND" = "repo-update" ]]; then
    pod_repo_update
else
    echo "...."
fi
archive $BUILD_ID $BUILD_MODE $BUILD_TEMP_FOLDER $TOKEN $XCPROJ_NAME $XCPROJ_PATH $SCHEME_NAME
