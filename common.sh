
function retry() {
    local -r -i max_wait="$1"; shift
    local -r cmd="$@"

    local -i sleep_interval=5
    local -i curr_wait=0

    until $cmd
    do
        if (( curr_wait >= max_wait ))
        then
            echo "ERROR: Failed after $curr_wait seconds. Please troubleshoot and run again."
            return 1
        else
            printf "."
            curr_wait=$((curr_wait+sleep_interval))
            sleep $sleep_interval
        fi
    done
    printf "\n"
}

# functions don't call exit, they return codes only
function check_jq_command() {
  command -v jq > /dev/null 2>&1 || return $COMMAND_NOT_FOUND
}

function check_grep_command() {
  command -v grep > /dev/null 2>&1 || return $COMMAND_NOT_FOUND
}

function version_gt() { 
  local USAGE="\nUsage: version_gt -v version -r required\n"
  local REQUIRED=""
  local VERSION=""

  OPTIND=1
  while getopts ":v:r:" opt; do
    case "${opt}" in 
      v) VERSION=${OPTARG};;
      r) REQUIRED=${OPTARG};;
      ? ) printf $USAGE;return 1;;
    esac
  done
  shift $((OPTIND-1))
  [ -z ${VERSION} ] || [ -z ${REQUIRED} ] && return $INVALID_FUNCTION_PARAMETERS
  
  [ "$(printf '%s\n' "$REQUIRED" "$VERSION" | sort -V | head -n1)" = "$REQUIRED" ] || return $UNMET_VERSION_REQUIREMENT
}

