#!/bin/bash
set -e
source dev-container-features-test-lib
# check "validate favorite color" color | grep 'my favorite color is red'
check "execute command" bash -c "echo 'hi' | grep 'hi'"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
