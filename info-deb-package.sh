#!/bin/bash

# berb-github-repo-mgr
# PACKAGING_VERSION="0.0.3"
# UTIL_VERSION="0.0.2"

fn_set_deb_package_vars() {
	MANTAINER='Berbascum'
	MAIL_MANTAINER='berbascum@ticv.cat'
	GIT_URL="https\:\/\/github\.com\/berbascum\/berb\-github\-repo\-mgr"
	REMOVE_SCRIPTS_COMMENTS="n"
	YEAR=$(date '+%Y')
	DATE=$(date '+%Y-%m-%d')
	BIN_EXTENSION=".sh"
	LIB_EXTENSION=".so"
	CONF_EXTENSION=".conf"
	CONF_ETC_DIR='berb-linux-tools'
	HAVE_BIN="y"
	HAVE_LIB="n"
	HAVE_CONF="n"
	HAVE_TEMPLATES="n"
	HAVE_DESKTOP_LAUNCHER="n"
	IS_SERVICE="n"
	ARCHITECTURE='all'
	UTIL_TYPE='utils'
	DEPENDS="gettext(>=0.21-8), bash(>=4.1), sed(>=4.4-1), gawk(>=4.1.4), coreutils(>=8.26-3) vim"
	UTIL_SHORT_DESC='Tool in bash script to manage git repos.'
	UTIL_EXT_DESC='Is designed for linux command line. It can manage local git remote github reepos.'

	## Vars form man page
	MAN_CAT="1"
	MAN_NAME_SHORT_DESC="$UTIL_SHORT_DESC"
	SYNOPSYS_1_DESC='berb-github-repo-mgr <command> [<option>]'
	CMD_OPTION1="commit-all"
	CMD_DESC_OPTION1='Adds all changes to local repo and create a commit.
}
