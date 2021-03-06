# CCLOUD_UTILS_HOME is a required variable which must be set
# to the location of the ccloud-utils repository so that it
# can source files relatively without all the issues
# surrounding BASH_SOURCE, PWD, etc...  This allows your
# calling script to run anywhere as long as you set it properly
[ -z ${CCLOUD_UTILS_HOME} ] && { printf "\nCCLOUD_UTILS_HOME is required to be set to use this library\n";exit 1; }

source $CCLOUD_UTILS_HOME/error-handling.sh
source $CCLOUD_UTILS_HOME/common.sh

function check_ccloud_command() {
  command -v ccloud > /dev/null 2>&1 || return $COMMAND_NOT_FOUND # dont exit, return code.  It's up to caller to decide to exit
}

# Here is an example of how this function might be tested indepdendently of any parent script:
#   $ test CCLOUD_UTILS_HOME=.;source ccloud_cli_helpers.sh;validate_ccloud_version -r 1.1.0 || { printf "\nERROR! Wake up Yeva Byzek, but let Rick sleep\n" }
#     ERROR! Wake up Yeva Byzek, but let Rick sleep
#
# We could look to automate testing of functions which themselves excercise platform behaviors to
#   look to automate validation
# 
# Here is how you can see the function's usage:
#   $ CCLOUD_UTILS_HOME=.;source ccloud_cli_helpers.sh;validate_ccloud_version -h
#     Usage: validate_ccloud_version -r required_version
#
function validate_ccloud_version() {
  check_grep_command || return $?
  check_ccloud_command || return $? 

  local USAGE="\nUsage: validate_ccloud_version -r required_version\n"
  local REQUIRED_VERSION=""

  OPTIND=1
  while getopts ":r:" opt; do
    case "${opt}" in 
      r)  REQUIRED_VERSION=${OPTARG};;
      ?) printf "$USAGE";return $INVALID_FUNCTION_PARAMETERS;;
    esac
  done
  shift $((OPTIND-1))
  [ -z ${REQUIRED_VERSION} ] && return $INVALID_FUNCTION_PARAMETERS
  
  ACTUAL_VERSION=$(ccloud version | grep "^Version:" | cut -d':' -f2 | cut -d'v' -f2)
  version_gt -r $REQUIRED_VERSION -v $ACTUAL_VERSION 
}

function get_ccloud_kafka_cluster_create_command() {
	check_ccloud_command || return $?	

	# this might be better as a heredoc somewhere
  local USAGE="\nUsage: ccloud_kafka_cluster_create -n cluster_name -c cloud_provider -r region \n\n\tcloud_provider = [ aws, gcp, az ]"
  local CLUSTER_NAME=""
	local CLUSTER_CLOUD=""
	local CLUSTER_REGION=""

  OPTIND=1
  while getopts ":n:c:r:" opt; do
    case "${opt}" in 
			n)  CLUSTER_NAME=${OPTARG};;
			c)  CLUSTER_CLOUD=${OPTARG};;
      r)  CLUSTER_REGION=${OPTARG};;
      ?) printf "$USAGE";return $INVALID_FUNCTION_PARAMETERS;;
    esac
  done
  shift $((OPTIND-1))
  [ -z ${CLUSTER_NAME} ] || [ -z ${CLUSTER_CLOUD} ] || [ -z ${CLUSTER_REGION} ] && return $INVALID_FUNCTION_PARAMETERS

	printf "ccloud kafka cluster create $CLUSTER_NAME --cloud $CLUSTER_CLOUD --region $CLUSTER_REGION"	
}
