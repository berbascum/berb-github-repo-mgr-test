#!/bin/bash

TOOL_NOM='berb-github-repo-mgr'
TOOL_VERSIO='0.0.1-1'
TOOL_BRANCA='development'

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

################
## Changelog: ##
################
  # v_0.0.1-1
    # Starting version
  # v_0.0.1
    # Starting version

START_DIR=$(pwd)
REPO_NAME=$(echo $START_DIR | awk -F'/' '{print $NF}')
REPO_ACCOUNT='berbascum'
DATA_HORA_JUNT=$(date +%y%m%d%H%M%S)

fn_precheck_repo_nom() {
	if [ "$REPO_NAME" == "kernel-xiaomi-lavender-4.4.192" ]; then
		REPO_NAME='kernel-xiaomi-lavender'
		REPO_ACCOUNT='droidian-lavender'
	elif [ "$REPO_NAME" == "linux-android-fxtec-pro1" ]; then
		REPO_ACCOUNT='droidian-devices'
	fi
	echo "" && echo "REPO_NAME = $REPO_NAME"
	echo "" && echo "REPO_ACCOUNT = $REPO_ACCOUNT"
	echo "" && read -p "Continuar?"
	echo ""
}

fn_create_repo() {
	git init
	fn_pull $@
}

fn_create_branch() {
	fn_check_param_2_branch $@
	git checkout -b "$BRANCA"
}

fn_tag_ver_last_commit() {
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
	git push --tags git@github.com:$REPO_ACCOUNT/$REPO_NAME
}

fn_commit-all() {
	git checkout $BRANCA
	git add --all
	commit -a -m 'Updated files'
	git push git@github.com:berbascum/$REPO_NAME
}

fn_pull() {
	CURRENT_BRANCH=$(git branch --show-current)
	echo && read -p "Baixar branca $CURRENT_BRANCH?"
	git pull git@github.com:$REPO_ACCOUNT/$REPO_NAME $CURRENT_BRANCH
	#git pull git@github.com:berbascum/$REPO_NAME
	#git pull git@github.com:droidian-lavender/kernel-xiaomi-lavender

}

fn_push() {
	CURRENT_BRANCH=$(git branch --show-current)
	echo && read -p "Pujar branca $CURRENT_BRANCH?"
	git push git@github.com:$REPO_ACCOUNT/$REPO_NAME $CURRENT_BRANCH
	#git push git@github.com:berbascum/$REPO_NAME
}

fn_check_param_2_branch() {
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
fn_precheck_repo_nom

if [ "$1" == "create-repo" ]; then
	fn_create_repo $@
elif [ "$1" == "create-branch" ]; then
	fn_create_branch $@
elif [ "$1" == "commit-all" ]; then
	fn_commit-all $@
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


