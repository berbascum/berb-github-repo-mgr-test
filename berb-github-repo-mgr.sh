#!/bin/bash

TOOL_NOM='berb-github-repo-mgr'
TOOL_VERSIO='0.0.2'
TOOL_BRANCA='devel'

# Not used yet by this script:
# VERSIO_SCRIPTS_SHARED_FUNCS="0.2.1"

# Upstream-Name: berb-github-repo-mgr
# Source: https://github.com/berbascum/berb-github-repo-mgr
  ## Script to manage git repos from GitHub

# Copyright (C) 2022 Berbascum <berbascum@ticv.cat>
# All rights reserved.

# BSD 3-Clause License
#
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#    * Neither the name of the <organization> nor the
#      names of its contributors may be used to endorse or promote products
#      derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


fn_get_repo_info() {
	START_DIR=$(pwd)
	DATA_HORA_JUNT=$(date +%y%m%d%H%M%S)
	ORG_NAME=$(echo $START_DIR | awk -F'/' '{print $(NF-1)}')
	PROJECT_NAME=$(echo $START_DIR | awk -F'/' '{print $NF}')
	CURRENT_BRANCH=$(git branch --show-current)
#	echo && echo -p "Organization detected: \"$ORG_NAME"\"
#	echo && echo -p "Project detected: \"$PROJECT_NAME\""
#	echo && echo "Branch detected: \"$CURRENT_BRANCH\""
}

fn_msg_branch_confirm() {
	echo && read -p "$MSG1 branch \"$CURRENT_BRANCH\" $MSG2 $MSG3 \"$ORG_NAME/$PROJECT_NAME\"? [ yes | <any_word> ]: " ANSWER
	if [ "$ANSWER" != 'y' ]; then
		echo && echo "Aborting as your choice..."
		exit 2
	fi
}

fn_create_repo() {  # TODO
	git init
	fn_pull $@
}

fn_create_branch() { # TODO
	fn_check_param_2_branch $@
	git checkout -b "$BRANCA"
}

fn_tag_ver_last_commit() { # NEED REVISION
	COMMIT_ID_LAST=$(git log --oneline | head -n 1 | awk '{print $1}')
	GIT_VER_SUFIX="+git"$DATA_HORA_JUNT"."$COMMIT_ID_LAST".halium.9.0"
	echo && echo 'A version number is required!'
	echo && echo 'Samples:'
	echo '- Kernel: 4.4.160-1'
	echo '- Script; 0.0.1 | 0.0.1-1'
	echo && read -p "Type a version number: " VERSION_LOCAL
	VERSION_GIT="$VERSION_LOCAL""$GIT_VER_SUFIX"
	echo && read -p "Versió = $VERSION_GIT"

	git tag -a $VERSION_GIT -m "Release creation: $VERSION_GIT"
	git push --tags git@github.com:$ORG_NAME/$PROJECT_NAME
}

fn_commit_all() {
	MSG1='COMMIT' MSG2='to' MSG3='git local repo' fn_msg_branch_confirm
	git add --all
	vim /tmp/tmp.txt
	git commit -m "$(cat /tmp/tmp.txt)"
	rm /tmp/tmp.txt
}

fn_pull() {
	MSG1='PULL' MSG2='from' MSG3='github remote repo' fn_msg_branch_confirm
	git pull git@github.com:$ORG_NAME/$PROJECT_NAME $CURRENT_BRANCH

}

fn_push() {
	MSG1='PUSH' MSG2='to' MSG3='github remote repo' fn_msg_branch_confirm
	git push git@github.com:$ORG_NAME/$PROJECT_NAME $CURRENT_BRANCH
}

fn_check_param_2_branch() { # NEED REVISION
	echo "Params = $@"
	if [ "$2" == "" ]; then
		echo "" && echo "Cal nom de branca com a param 2"
		echo ""
		exit 1
	else
		BRANCA="$2"
	fi
}

##################
## inici script ##
##################
fn_get_repo_info
if [ "$1" == "create-repo" ]; then
	fn_create_repo $@
elif [ "$1" == "create-branch" ]; then
	fn_create_branch $@
elif [ "$1" == "commit-all" ]; then
	fn_commit_all $@
elif [ "$1" == "pull" ]; then
	fn_pull $@
elif [ "$1" == "push" ]; then
	fn_push $@
elif [ "$1" == "tag-ver-last-commit" ]; then
	fn_tag_ver_last_commit $@
else
	echo "" && echo "Opció no implementada"
	echo "Utilitzar:"
	echo "- create-repo"
	echo "- commit-all"
	echo "- create-branch"
	echo "- tag-version"
	echo "- pull"
	echo "- push"
fi


