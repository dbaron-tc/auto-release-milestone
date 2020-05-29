FROM mcr.microsoft.com/dotnet/core/dsk:3.1

LABEL "com.github.actions.name"="Auto Release Milestone"
LABEL "com.github.actions.description"="Drafts a GitHub release based on a newly closed milestone"

LABEL version="0.1.0"
LABEL repository="https://github.com/dbaron-tc/auto-release-milestone"
LABEL maintainer="Daniela"

# Specify path to shell script to be run as soon as container starts up
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
