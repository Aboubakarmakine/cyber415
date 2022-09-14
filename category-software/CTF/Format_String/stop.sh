#!/bin/bash

if [ -n "$(sudo docker ps -f ancestor=easy_ctf_fmt_str_server -q)" ]
then
   echo "STOPPING CONTAINERS..."
   echo
   sudo docker stop $(sudo docker ps -f ancestor=easy_ctf_fmt_str_server -q)
   echo 
fi

if [ -z "$(sudo docker ps --quiet --filter name=fmt_str)" ]
then
   echo "ENABLING ASLR..."
   echo
   sudo sysctl -w kernel.randomize_va_space=2
else
   echo
   echo "LEAVING ASLR DISABLED BECAUSE ANOTHER 'Format String' CTF IS STILL RUNNING..."
   echo
fi

ASLR=$(cat /proc/sys/kernel/randomize_va_space)

if [ $ASLR -ne 2 ]
then
   ecdown
   echo "  █████   ███   █████   █████████   ███████████   ██████   █████ █████ ██████   █████   █████████  ███"
   echo " ░░███   ░███  ░░███   ███░░░░░███ ░░███░░░░░███ ░░██████ ░░███ ░░███ ░░██████ ░░███   ███░░░░░███░███"
   echo "  ░███   ░███   ░███  ░███    ░███  ░███    ░███  ░███░███ ░███  ░███  ░███░███ ░███  ███     ░░░ ░███"
   echo "  ░███   ░███   ░███  ░███████████  ░██████████   ░███░░███░███  ░███  ░███░░███░███ ░███         ░███"
   echo "  ░░███  █████  ███   ░███░░░░░███  ░███░░░░░███  ░███ ░░██████  ░███  ░███ ░░██████ ░███    █████░███"
   echo "   ░░░█████░█████░    ░███    ░███  ░███    ░███  ░███  ░░█████  ░███  ░███  ░░█████ ░░███  ░░███ ░░░ "
   echo "     ░░███ ░░███      █████   █████ █████   █████ █████  ░░█████ █████ █████  ░░█████ ░░█████████  ███"
   echo "      ░░░   ░░░      ░░░░░   ░░░░░ ░░░░░   ░░░░░ ░░░░░    ░░░░░ ░░░░░ ░░░░░    ░░░░░   ░░░░░░░░░  ░░░ "
   echo 
   echo "ADDRESS SPACE LAYOUT RANDOMIZATION (ASLR) IS DISABLED ON THE HOST."
   echo "THIS IS A SERIOUS SECURITY VULNERABILITY THAT WILL PERSIST BEYOND RUNNING THIS CHALLENGE!"
   echo 
   echo "ENABLE ASLR VIA 'sudo sysctl -w kernel.randomize_va_space=2'"
else
   echo
   echo "ASLR IS ENABLED, YOUR HOST SYSTEM IS SAFE AGAIN!"
fi


























getConsent() {
   while true; do
      read -p "DO YOU CONSENT TO ENABLING ASLR ON YOUR HOST? [Y|N] " yn
      case $yn in
         [Yy]* )
            return 0
            ;;
         [Nn]* )
            echo
            echo "IT IS STRONGLY ENCOURAGED TO ENABLE ASLR!"
            return 1
            ;;
         * )
            echo
            echo "PLEASE ANSWER YES OR NO!"
            ;;
      esac
   done
}

printHelp() {
   echo
   echo "Usage: stop.sh [OPTION]"
   echo "Stop the CTF Format String Docker application."
   echo
   echo "Options:"
   echo "   -h                               show this help dialogue"
   echo "   -c [easy_server | hard_server]   stop one of the challenge containers"
   echo
   echo "Examples:"
   echo "   stop.sh                  stop all of the containers"
   echo "   stop.sh -c easy_server   stop just the container hosting the easy verion"
   echo "   stop.sh -h               print the help dialogue"
}

while getopts 'hc:' OPTION; do
   case "$OPTION" in
      h)
         printHelp >&2
         exit 1
         ;;
      c)
         ARG=$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]')
         if [[ "$ARG" == "easy_server" ]]; then
            CONTAINER=$ARG
         elif [[ "$ARG" == "hard_server" ]]; then
            CONTAINER=$ARG
         else
            echo
            echo "Usage: $(basename $0) -c [easy_server | hard_server]" >&2
            exit 1
         fi
         ;;
      ?)
         echo
         echo "Usage: $(basename $0) [-h] [-c container]" >&2
         exit 1
         ;;
   esac
done

printWarning

if getConsent -eq 0 ; then

   if disableASLR -eq 0 ; then

      startContainers $CONTAINER

      exit 0
   fi
fi

exit 1







