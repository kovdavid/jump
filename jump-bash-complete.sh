#!/bin/bash

__davsx_jump_complete() {
	local cur prev commands aliases JUMP_FILES
	local target_dir alias_name is_command cmd

	JUMP_FILES=${DAVSX_JUMP_FILES:-~/.jump}

	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	commands="list get set remove help"

	aliases=""
	for JUMP_FILE in ${JUMP_FILES//,/ }; do
		if [ -f "$JUMP_FILE" ] ; then
			aliases="$aliases $(cut -f1 "$JUMP_FILE" | paste -sd ' ' -)"
		fi
	done

	if [ "$COMP_CWORD" -eq 1 ] ; then
		COMPREPLY=( $(compgen -W "${commands} ${aliases}" -- "$cur") )
		return 0
	fi

	if [ "$COMP_CWORD" -eq 2 ] ; then
		# Handle existing subcommand exceptions
		case "$prev" in
			"get"|"remove")
				COMPREPLY=( $(compgen -W "${aliases}" -- "$cur") )
				return 0
			;;
		esac

		# Check if COMP_WORDS[1] is a built-in command
		is_command=0
		for cmd in ${commands}; do
			if [ "${COMP_WORDS[1]}" == "$cmd" ]; then
				is_command=1
				break
			fi
		done

		# If it's not a command, treat COMP_WORDS[1] as an alias
		if [ "$is_command" -eq 0 ]; then
			alias_name="${COMP_WORDS[1]}"
			target_dir=""

			for JUMP_FILE in ${JUMP_FILES//,/ }; do
				if [ -f "$JUMP_FILE" ] ; then
					target_dir=$(awk -v al="$alias_name" '$1 == al {print $2; exit}' "$JUMP_FILE")
					if [ -n "$target_dir" ] ; then
						break
					fi
				fi
			done

			# If the alias points to a valid directory, autocomplete files/folders inside it recursively
			if [ -d "$target_dir" ] ; then
				local IFS=$'\n'
				COMPREPLY=( $(cd "$target_dir" && compgen -S "/" -d -- "$cur") )
				compopt -o nospace
				return 0
			fi
		fi
	fi
}

complete -F __davsx_jump_complete j
