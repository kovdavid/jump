#!/bin/bash

JUMP_FILE=${DAVSX_JUMP_FILE:-~/.jump}

__davsx_jump_complete() {
	local cur prev commands aliases

	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	commands="list get set remove help"
	aliases=$(cut -f1 $JUMP_FILE | paste -sd " " -)

	if [ $COMP_CWORD == 1 ] ; then
		COMPREPLY=()
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
