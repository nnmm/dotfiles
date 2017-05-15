function ::
	ag "$argv ::" | fpp
end

function data
	ag -A10 "[data|newtype] $argv"
end

eval (python -m virtualfish)

function fish_virtualenv_prompt
	if set -q VIRTUAL_ENV
    	echo -n -s " (" (basename "$VIRTUAL_ENV") ")"
    end
end

if not set -q fish_user_paths
	set -U fish_user_paths /home/internet/.local/bin /home/internet/miniconda3/bin
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