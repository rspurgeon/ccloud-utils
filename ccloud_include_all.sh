# CCLOUD_UTILS_HOME is a required variable which must be set
# to the location of the ccloud-utils repository so that it
# can source files relatively to that path without all the issues
# surrounding BASH_SOURCE, PWD, etc...  This allows your
# calling script to run anywhere
[ -z ${CCLOUD_UTILS_HOME} ] && { printf "\nCCLOUD_UTILS_HOME is required to be set to use this library\n";exit 1; }

# TODO Consider how bash files could be sourced multiple times and
#   any repercussions of that.  I tried using some "include guards" but
#   that has it's own downsides to discuss.  Might be a better way to 
#   prevent redundant sourcing of the same file per top level scripts
source $CCLOUD_UTILS_HOME/ccloud_cli_helpers.sh
# source $CCLOUD_UTILS_HOME/next_helper_we_want.sh
