#!/bin/bash

# tell bash to warn anytime an undeclared variable is used in script
set -u

# logging command for github action to set an output parameter
echo "::set-output name=release-url::http://example.com"

# tell workflow that action completed successfully by setting a 0 exit code
exit 0
