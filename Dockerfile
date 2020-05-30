FROM mcr.microsoft.com/dotnet/core/sdk:3.1

LABEL "com.github.actions.name"="Auto Release Milestone"
LABEL "com.github.actions.description"="Drafts a GitHub release based on a newly closed milestone"

LABEL version="0.1.0"
LABEL repository="https://github.com/dbaron-tc/auto-release-milestone"
LABEL maintainer="Daniela"

# Install jq for json parsing at command line
RUN apt-get update && apt-get install -y jq

# Install GitReleaseManager globally it can be invoked from anywhere
RUN dotnet tool install -g GitReleaseManager.Tool

# Update PATH to include GitReleaseManager
ENV PATH /root/.dotnet/tools:$PATH

# Specify path to shell script to be run as soon as container starts up
# args to entrypoint.sh are passed in via args property of action metadata: action.yml
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
