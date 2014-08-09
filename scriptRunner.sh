#! /bin/bash

#-------------------------------------#
#            scriptRunner             #
#-------------------------------------#
#                                     #
#      scriptRunner will run all      #
#     scripts within a folder that    #
#             you specify             #
#                                     #
#             Yvan Godard             #
#        godardyvan@gmail.com         #
#                                     #
#    Version 0.1 -- august, 8 2014    #
#         Tool licenced under         #
#   Creative Commons 4.0 BY NC SA     #
#                                     #
#        http://goo.gl/cBqSdY         #
#                                     #
#-------------------------------------#

# Variables initialisation
VERSION="scriptRunner v 0.1 by Yvan Godard - 2014 - http://goo.gl/cBqSdY"
help="no"
SCRIPT_DIR=$(dirname $0)
SCRIPT_NAME=$(basename $0)
LOG_FILE="/var/log/scriptRunner.log"
LOG_ACTIVE=0
DIR_RUN_ONCE=${SCRIPT_DIR}/runOnce
DIR_RUN_EVERY=${SCRIPT_DIR}/runEvery
RUN_ONCE=0
RUN_EVERY=0
NUMBER_RUN_ONCE=0
NUMBER_RUN_EVERY=0
FORCE_ONCE=0

help () {
	echo -e "$VERSION\n"
	echo -e "This tool is designed to run all scripts within a folder that you specify."
	echo -e "It's useful for LaunchAgents and running multiple scripts at user login."
	echo -e "It works both with scripts to be executed each time and with those that may only be executed once."
	echo -e "This tool is licensed under the Creative Commons 4.0 BY NC SA licence."
	echo -e "\nDisclamer:"
	echo -e "This tool is provide without any support and guarantee."
	echo -e "\nSynopsis:"
	echo -e "./scriptRunner.sh [-h] | -o <directory once> -e <directory every time>"
	echo -e "                  [-l <log file>] [-f]"
	echo -e "\n  -h:                       Prints this help then exit"
	echo -e "\nMandatory option (one or both of the following):"
	echo -e "  -o <directory once>:        The directory of scripts to run only one time."
	echo -e "                              Could be 'default' for '${DIR_RUN_ONCE}'"
	echo -e "  -e <directory every time>:  The directory of scripts to run each time."
	echo -e "                              Could be 'default' for '${DIR_RUN_EVERY}'"
	echo -e "\nOptional options:"
	echo -e "  -l <log file>:              Enables logging instead of standard output."
	echo -e "                              Specify an argument for the full path to the log file"
	echo -e "                              (i.e.: '${LOG_FILE}') or use 'default' (${LOG_FILE})"
	echo -e "  -f                          This option forces to run any scripts in the directory"
	echo -e "                              containing scripts to run only once."
	echo -e "                              This option must be use with option '-o <directory once>'"
	exit 0
}

error () {
	echo -e "\n*** Error ***"
	echo -e ${1}
	echo -e "\n"${VERSION}
	alldone 1
}

alldone () {
	if [[ ${LOG_ACTIVE} = "1" ]]
		then
		exec 1>&6 6>&-
	fi
	exit ${1}
}

optsCount=0

while getopts "he:o:l:f" OPTION
do
	case "$OPTION" in
		h)	help="yes"
						;;
		e)	[ $OPTARG != "default" ] && DIR_RUN_EVERY=${OPTARG}
			RUN_EVERY=1
			let optsCount=$optsCount+1
						;;
		o)	[ $OPTARG != "default" ] && DIR_RUN_ONCE=${OPTARG}
			RUN_ONCE=1
			let optsCount=$optsCount+1
						;;
        l)	[ $OPTARG != "default" ] && LOG_FILE=${OPTARG}
			LOG_ACTIVE=1
                        ;;
		f)	FORCE_ONCE=1
						;;
	esac
done

if [[ ! ${optsCount} -gt "0" ]]
	then
        help
        alldone 1
fi

if [[ ${help} = "yes" ]]
	then
	help
fi

if [[ ${LOG_ACTIVE} = "1" ]]
	then
	if [[ ! -e "${LOG_FILE}" ]] 
		then
		[[ ! -e $(dirname ${LOG_FILE}) ]] && mkdir -p $(dirname ${LOG_FILE})
		touch ${LOG_FILE}
		[[ $? -ne 0 ]] && echo "Trying to use '-l' option but '${LOG_FILE} seems to be incorrect. Process will continue without writing log file." && LOG_ACTIVE=0
	fi
fi

if [[ ${LOG_ACTIVE} = "1" ]]
	then
	# Redirect standard outpout to temp file
	exec 6>&1
	exec >> ${LOG_FILE}
fi

# Start
echo -e "\n****************************** `date` ******************************\n"
echo -e "$0 started with options:"
[[ ${RUN_ONCE} = "1" ]] && echo -e "\t-o ${DIR_RUN_ONCE}"
[[ ${RUN_EVERY} = "1" ]] && echo -e "\t-e ${DIR_RUN_EVERY}"
[[ ${FORCE_ONCE} = "1" ]] && echo -e "\t-f"
[[ ${LOG_ACTIVE} = "1" ]] && echo -e "\t-l ${LOG_FILE}"

# Preparing directory for sripts runned one time
DIR_RUN_ONCE_RUNNED=${DIR_RUN_ONCE}AlreadyRunned
[[ ! -d ${DIR_RUN_ONCE_RUNNED} ]] && mkdir -p ${DIR_RUN_ONCE_RUNNED}

if [[ ${FORCE_ONCE} = "1" ]]
	then
	echo -e "\n#################################\nRESET SCRIPTS ALREADY RUNNED ONCE\n#################################"
	OLDIFS=$IFS
	IFS=$'\n'
	for FILE in $(find ${DIR_RUN_ONCE_RUNNED} -type f -maxdepth 1)
	do
		echo -e "\n### Moving '${FILE}' to '${DIR_RUN_ONCE}/'"
		mv "${FILE}" ${DIR_RUN_ONCE}/
		[[ $? -ne 0 ]] && echo ">>> Problem when moving '${FILE}' to '${DIR_RUN_ONCE}/'"
	done
	IFS=$OLDIFS
fi	

if [[ ${RUN_ONCE} = "1" ]]
	then
	echo -e "\n#########################\nSTARTING ONCE RUN SCRIPTS\n#########################"
	# Test if directory exists
	[[ ! -d ${DIR_RUN_ONCE} ]] && echo "Trying to use '-o' option but '{DIR_RUN_ONCE}' seems to be incorrect. Interruption of this part of the process." && RUN_ONCE=0
fi
if [[ ${RUN_ONCE} = "1" ]]
	then
	# Test if directory contain one script
	NUMBER_RUN_ONCE=$(find ${DIR_RUN_ONCE} -type f -maxdepth 1 | wc -l)
	if [[ ${NUMBER_RUN_ONCE} -eq "0" ]]
		then
		echo "No script in directory '${DIR_RUN_ONCE}'. Interruption of this part of the process."
	elif [[ ${NUMBER_RUN_ONCE} -gt "0" ]]
		then
		# List all scripts in directory
		OLDIFS=$IFS
		IFS=$'\n'
		for FILE in $(find ${DIR_RUN_ONCE} -type f -maxdepth 1)
		do
			echo -e "\n### $(date) ### BEGIN ${FILE}"
			if [[ -x ${FILE} ]]
				then
				"${FILE}"
				if [[ $? -ne 0 ]] 
					then
					echo ">>> Problem when trying to launch '${FILE}'"
				else
					mv "${FILE}" ${DIR_RUN_ONCE_RUNNED}/
					[[ $? -ne 0 ]] && echo ">>> Problem when moving '${FILE}' to the directory of scripts already launched (${DIR_RUN_ONCE_RUNNED})."
				fi
			elif [[ ! -x ${FILE} ]]
				then
				echo -e ">>> Problem when trying to launch '${FILE}': is not executable or has bad permissions."
			fi
			echo "### $(date) ### END   ${FILE}"
		done
		IFS=$OLDIFS
	fi
fi

if [[ ${RUN_EVERY} = "1" ]]
	then
	echo -e "\n###########################\nSTARTING EVERY TIME SCRIPTS\n###########################"
	# Test if directory exists
	[[ ! -d ${DIR_RUN_EVERY} ]] && echo "Trying to use '-e' option but '{DIR_RUN_EVERY}' seems to be incorrect. Interruption of this part of the process." && RUN_EVERY=0
fi
if [[ ${RUN_EVERY} = "1" ]]
	then
	# Test if directory contain one script
	NUMBER_RUN_EVERY=$(find ${DIR_RUN_EVERY} -type f -maxdepth 1 | wc -l)
	if [[ ${NUMBER_RUN_EVERY} -eq "0" ]]
		then
		echo "No script in directory '${DIR_RUN_EVERY}'. Interruption of this part of the process."
	elif [[ ${NUMBER_RUN_EVERY} -gt "0" ]]
		then
		# List all scripts in directory
		OLDIFS=$IFS
		IFS=$'\n'
		for FILE in $(find ${DIR_RUN_EVERY} -type f -maxdepth 1)
		do
			echo -e "\n### $(date) ### BEGIN ${FILE}"
			if [[ -x ${FILE} ]]
				then
				"${FILE}"
				[[ $? -ne 0 ]] && echo ">>> Problem when trying to launch '${FILE}'"
			elif [[ ! -x ${FILE} ]]
				then
				echo -e ">>> Problem when trying to launch '${FILE}': is not executable or has bad permissions."
			fi
			echo "### $(date) ### END   ${FILE}"
		done
		IFS=$OLDIFS
	fi
fi

echo -e "\n********************************* ${SCRIPT_NAME} finished *********************************"
alldone 0