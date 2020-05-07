
# A shared list of well known error codes
#   should be more useful than always returning 1
#   but also kind of hard to maintain and when printed
#   don't really mean anything to human readers
SUCCESS=0
UNSPECIFIED_ERROR=150
UNMET_VERSION_REQUIREMENT=151
COMMAND_NOT_FOUND=152
INVALID_FUNCTION_PARAMETERS=153

PRETTY_ERROR="\e[31m✘ \033\e[0m"
PRETTY_PASS="\e[32m✔ \033\e[0m"
function print_pass() {
  printf "${PRETTY_PASS}${1}"
}
function print_error() {
  printf "${PRETTY_ERROR}${1}"
}

# Exits shell, prints provided contextual details prior.
#   This should be the only function w/ an exit in it 
function exit_with_error()
{
  local USAGE="\nUsage: exit_with_error -c code -n name -m message -l line_number\n"
  local NAME=""
  local MESSAGE=""
  local CODE=$UNSPECIFIED_ERROR
  local LINE=
  OPTIND=1
  while getopts ":n:m:c:l:" opt; do
    case ${opt} in 
      n ) NAME=${OPTARG};;
      m ) MESSAGE=${OPTARG};;
      c ) CODE=${OPTARG};;
      l ) LINE=${OPTARG};;
      ? ) printf $USAGE;return 1;;
    esac
  done
  shift $((OPTIND-1))
  print_error "error ${CODE} occurred in ${NAME} at line $LINE\n\t${MESSAGE}\n"
  exit $CODE
}

# sample function to test error cases
function degenerate()
{
  # you're the worst degenerate function 
  return $UNSPECIFIED_ERROR 
}
