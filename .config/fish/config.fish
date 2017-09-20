# ================ VARIABLES ================

if not set -q fish_user_paths
	set -U fish_user_paths $HOME/.local/bin /usr/sbin
	if test -d $HOME/.cargo/bin
		set -U fish_user_paths $fish_user_paths $HOME/.cargo/bin
	end
end

# other path-like variables with colon separator are handled differently
# we need to append manually
function append
	if set -q argv[2]
		if set -q $argv[1]
			set -xg $argv[1] "$$argv[1]":$argv[2]
		else
			set -xg $argv[1] $argv[2]; true
		end
	end
end

# .local is where it's at
append LD_LIBRARY_PATH ~/.local/lib
append PKG_CONFIG_PATH $HOME/.local/lib/pkgconfig
append CMAKE_PREFIX_PATH $HOME/.local

set -xg GOROOT $HOME/bin/go
set -xg FPP_EDITOR subl

# Will print "No module called virtualfish" if not installed
if type -q pip
	eval (python -m virtualfish)
end

# for machine-specific configuration
if test -f $HOME/.config/fish/local_machine.fish
	source $HOME/.config/fish/local_machine.fish
end

# ================ FUNCTIONS ================

function ::
	ag "$argv ::" | fpp
end

function data
	ag -A10 "(data|newtype|type) $argv"
end

# ================= PROMPT ==================

function fish_virtualenv_prompt
	if set -q VIRTUAL_ENV
		echo -n -s " (" (basename "$VIRTUAL_ENV") ")"
	end
end

# Looks nice with e.g.
# fish_color_autosuggestion '555'  'yellow'
# fish_color_command 00d700
# fish_color_comment 9e9e9e
# fish_color_cwd 87afff
# fish_color_cwd_root red
# fish_color_error 'red'  '--bold'
# fish_color_escape cyan
# fish_color_history_current cyan
# fish_color_host '-o'  'cyan'
# fish_color_match cyan
# fish_color_normal normal
# fish_color_operator cyan
# fish_color_param '00afff'  'cyan'
# fish_color_quote ffd75f
# fish_color_redirection normal
# fish_color_search_match --background=purple
# fish_color_status d70000

if not set -q fish_color_git
	set -g fish_color_git cyan
end

function fish_prompt --description 'Write out the prompt'
	set -l last_status $status
	# The fish_color_X vars are universal
	# The __fish_prompt_X vars are all set in here, some are colors
	# Just calculate these once, to save a few cycles when displaying the prompt
	if not set -q __fish_prompt_hostname
		set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
	end

	if not set -q __fish_prompt_color_normal
		set -g __fish_prompt_color_normal (set_color normal)
	end

	if not set -q -g __fish_classic_git_butchered_functions_defined
		set -g __fish_classic_git_butchered_functions_defined

		function __fish_repaint_status --on-variable fish_color_status --description "Event handler; repaint when fish_color_status changes"
			if status --is-interactive
				set -e __fish_prompt_status
				commandline -f repaint ^/dev/null
			end
		end
	end


	switch $USER

	case root

		if not set -q __fish_prompt_color_cwd
			if set -q fish_color_cwd_root
				set -g __fish_prompt_color_cwd (set_color $fish_color_cwd_root)
			else
				set -g __fish_prompt_color_cwd (set_color $fish_color_cwd)
			end
		end

	case '*'

		if not set -q __fish_prompt_color_cwd
			set -g __fish_prompt_color_cwd (set_color $fish_color_cwd)
		end
	end

	set -l prompt_status
	if test $last_status -ne 0
		if not set -q __fish_prompt_status
			set -g __fish_prompt_status (set_color $fish_color_status)
		end
		set prompt_status "$__fish_prompt_status [$last_status]$__fish_prompt_color_normal"
	end

	set -l delim "$__fish_prompt_color_cwd>"

	set -l __fish_prompt_color_git (set_color $fish_color_git)

	echo -n -s "$__fish_prompt_color_cwd" (prompt_pwd) $__fish_prompt_color_git (__fish_git_prompt) (fish_virtualenv_prompt) "$__fish_prompt_color_normal" "$prompt_status" "$delim" ' '
end
