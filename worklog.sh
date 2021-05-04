#!/bin/bash
CURL='/usr/bin/curl'
JIRA_TICKET_NUMBER=$1
TIME=$2
DATE=$3
COMMENT=$4
function check_and_create_credential {
	USER_NAME=$1
	USER_PASSWORD=$2
	U_KEY="JIRA_EMAIL"
	P_KEY="JIRA_TOKEN"
	if [[ -z "$USER_NAME" ]]; then
		printf "Enter Jira Email: "
		read USER_NAME
		security add-generic-password -a ${U_KEY} -s Jira_Scripting -w ${USER_NAME}
	fi

	if [[ -z "$USER_PASSWORD" ]]; then
		echo "Enter Jira Api Token: "
		read USER_PASSWORD
		security add-generic-password -a ${P_KEY} -s Jira_Scripting -w ${USER_PASSWORD}
	fi
	API_TOKEN="$USER_NAME:$USER_PASSWORD"
}
function api_token {
	U_KEY="JIRA_EMAIL"
	P_KEY="JIRA_TOKEN"
	USER_NAME=$(security find-generic-password -a ${U_KEY} -s Jira_Scripting -w)
	USER_PASSWORD=$(security find-generic-password -a ${P_KEY} -s Jira_Scripting -w)
	check_and_create_credential $USER_NAME $USER_PASSWORD
}
function http_api {
    URL=$1
    JSON=$2
    api_token
    
    echo "Token is $API_TOKEN"
    echo "JSON is $JSON"

    if [[ -z "$API_TOKEN" ]]; then
		echo "Unable to Find Basic Auth Token"
	else
		API_RESPONSE=$(curl --request POST --url "$URL" --user ${API_TOKEN} --header "Content-Type: application/json" --header "cache-control: no-cache" --data "$JSON")
    	echo $API_RESPONSE
	fi
}
JIRA_API_URL="https://entertainerproducts.atlassian.net/rest/api/2/issue/${JIRA_TICKET_NUMBER}/worklog"
JIRA_WORKLOG_JSON_TEMPLATE='{"timeSpentSeconds":"%s","started":"%s","comment":"%s"}'
JIRA_WORKLOG_JSON=$(printf "$JIRA_WORKLOG_JSON_TEMPLATE" "$TIME" "$DATE" "$COMMENT")
http_api $JIRA_API_URL "$JIRA_WORKLOG_JSON"
