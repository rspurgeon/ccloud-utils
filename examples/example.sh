#!/bin/bash

# An example of how you might use the ccloud_utils library

# CCLOUD_UTILS_HOME is required to be set to use the repository to make calling
#   scripts runnable from anywhere they want to be.
#   Another project using this repository would set this variable some other way, maybe
#   by git cloning ccloud-utils locally and then setting it to that folder, or letting a user override it, etc...
CCLOUD_UTILS_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/..

# ccloud_include_all will bring it all the 'libraries', but they
#   could also be sourced individually if desired
source $CCLOUD_UTILS_HOME/ccloud_include_all.env

NAME=`basename "$0"`

# This example runs an imported helper command 
#   and on error will call the exit_with_error function, forwarding along the 
#   return code from the previous failure in the -c parameter and other contextual details
check_ccloud_command \
  && print_pass "ccloud available\n" \
  || exit_with_error -c $? -n $NAME -l $LINENO -m "ccloud command not found. Install Confluent Cloud CLI (https://docs.confluent.io/current/quickstart/cloud-quickstart/index.html#step-2-install-the-ccloud-cli) and try again"

REQUIRED_CCLOUD_VERSION=1.0.0
# I like this program flow of this...
#   perform_function \ 
#     on_success \
#     on_failure
validate_ccloud_version -r $REQUIRED_CCLOUD_VERSION \
  && print_pass "ccloud version check $REQUIRED_CCLOUD_VERSION\n" \
  || exit_with_error -c $? -n $NAME -m testmsg -l $LINENO  

# A sample function that always fails
degenerate \
  && print_pass "Waaahahah??" \
  || exit_with_error -c $? -n $NAME -l $LINENO -m "degenerate function always fails" 

