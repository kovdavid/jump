#!/bin/bash

__davsx_jump_complete() {
	local cur prev commands aliases

	JUMP_FILES=${DAVSX_JUMP_FILES:-~/.jump}

	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	commands="list get set remove help"

	aliases=""
	for JUMP_FILE in ${JUMP_FILES//,/ }; do
		if [ -f $JUMP_FILE ] ; then
			aliases="$aliases $(cut -f1 $JUMP_FILE | paste -sd ' ' -)"
		fi
	done

	if [ $COMP_CWORD == 1 ] ; then
		COMPREPLY=( $(compgen -W "${commands} ${aliases}" -- $cur) )
		return 0
	fi

	if [ $COMP_CWORD == 2 ] ; then
		case "$prev" in
			"get"|"remove")
				COMPREPLY=( $(compgen -W "${aliases}" -- $cur) )
				return 0
			;;
		esac
	fi
}

complete -F __davsx_jump_complete j
