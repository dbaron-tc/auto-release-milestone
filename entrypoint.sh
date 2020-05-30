#!/bin/bash

# tell bash to warn anytime an undeclared variable is used in script
set -u

# save value of repo token into a variable (its first param passed to script as per action metadata args)
repo_token=$1

# verify this action got trigerred by a milestone event
# use of debug logging command means this will only show in build log when debug is enabled
if [ "$GITHUB_EVENT_NAME" != "milestone" ]; then
  echo "::info::The event name was '$GITHUB_EVENT_NAME'"
  exit 0
fi

# check event payload with jq, `action` is at top level of event json
# json strings are surrounded by quotes, use raw-output option to get just value
event_type=$(jq --raw-output .action $GITHUB_EVENT_PATH)

# check for closed milestone
if [ $event_type != "closed" ]; then
  echo "::info::The event type was '$event_type'"
  exit 0
fi

# get the closed milestone's name
milestone_name=$(jq --raw-output .milestone.title $GITHUB_EVENT_PATH)

# Github action exports env var $GITHUB_REPOSITORY which contains: owner/repository
# Parse this info for gitreleasemanager using bash tool IFS (internal field separator)
# <<< is Here-string Redirection Operator - send string content to standard input stream of a command line program
# in this case, value of $GITHUB_REPOSITORY is sent to read command
IFS='/' read owner repository <<< "$GITHUB_REPOSITORY"

# determine the release_url by invoking gitreleasemanager with some arguments:
# 1. milestone from which to extract the closed issues (this becomes the release notes)
# 2. tag to be associated with release - $GITHUB_SHA contains id of latest commit in default branch
# 3. valid token to authenticate to Github REST API
# 4. which repo to create release in as specfied by repo owner and name
release_url=$(dotnet gitreleasemanager create \
--milestone $milestone_name \
--targetcommitish $GITHUB_SHA \
--token $repo_token \
--owner $owner \
--repository $repository)

# If anything went wrong with gitreleasemanager, use `error` logging command to output an error message,
# and tell workflow that this action has failed by exiting with a non-zero return code.
if [ $? -ne 0 ]; then
  echo "::error::Failed to create the release draft"
  exit 1
fi

# logging command for github action to set an output parameter - use value of release-url constructed above
echo "::set-output name=release-url::$release_url"

# tell workflow that action completed successfully by setting a 0 exit code
exit 0
