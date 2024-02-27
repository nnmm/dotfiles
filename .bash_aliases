
prompt_directories() {
	fd . --type d | sed 's|.$||' | fzf --multi
}

bind '"\er": redraw-current-line'
bind '"\C-f\C-d": "$(prompt_directories)\e\C-e\er"'

if [ -f ~/.bash_aliases_colcon ]; then
    . ~/.bash_aliases_colcon
fi
###############################################################
# git
###############################################################

# Git aliases with completions
# https://brbsix.github.io/2015/11/23/perform-tab-completion-for-aliases-in-bash/
_completion_loader git

alias gco='git checkout'
__git_complete gco _git_checkout

alias gcp='git cherry-pick'
__git_complete gcp _git_cherry_pick

alias ga='git add'
__git_complete ga _git_add

alias gb='git branch'
__git_complete gb _git_branch

alias gd='git diff'
__git_complete gd _git_diff

alias gs='git status'
__git_complete gs _git_status

alias gp='git push --set-upstream dev $(git symbolic-ref --short HEAD)'
__git_complete gp _git_push

alias gr='git restore'
__git_complete gr _git_restore

alias grs='git restore --staged'
__git_complete grs _git_restore

alias grh='git reset --hard origin/$(git symbolic-ref --short HEAD)'

# ✝
function amen {
    local do_continue=false
    if [[ ${1:-nope} == "co" ]]; then
        do_continue=true
        shift
    fi
	if (yes | git commit -a --amen --no-edit $@); then
        if [[ $do_continue = true ]]; then
            git rebase --continue
        fi
	fi
}
bind '"\C-g\C-g": "git rebase -i master"\e\C-e\C-m"'
bind '"\C-g\C-a": "git rebase --abort"\e\C-e\C-m"'

# Fuzzy search unmerged files with Ctrl-F Ctrl-F
# https://junegunn.kr/2016/07/fzf-git/
prompt_unmerged_files() {
	git diff --name-status  | sort -u | fzf --multi
}
bind '"\C-f\C-f": " :/$(prompt_unmerged_files | cut -f2)\e\C-e\er"'

fix_lfs_pngs() {
 sed -E -i 's@^\*\*/\*\.png@#&@' ~/ade-home/gc/.gitattributes
 git -C ~/gc status >/dev/null 2>&1
 sed -E -i 's@^#(\*\*/\*\.png)@\1@' ~/ade-home/gc/.gitattributes
}

###############################################################
# bazel
###############################################################

alias bb='bazel build'
alias bt='bazel test'
alias br='bazel run'
alias bq='bazel query'
alias bnb='bazel build --nobuild //...'
function bp() {
	echo "bazel cquery --output starlark $@ --starlark:expr='providers(target).keys()'"
	bazel cquery --output starlark $@ --starlark:expr='providers(target).keys()'
}
function bf() {
	echo "bazel cquery --output starlark $@ --starlark:expr='target.files'"
	bazel cquery --output starlark $@ --starlark:expr='target.files'
}

alias brep='bazelization_report'

# Build everything in a directory
bind '"\C-f\C-b": "bazel build //$(prompt_directories)/...\e\C-e\er"'

# Copy label into clipboard
bind '"\C-f\C-l": "echo \\\\\\\"@apex//$(prompt_directories)\\\\\\\", | xsel -ib\e\C-e\C-m"'

###############################################################
# misc
###############################################################

alias ll='ls -lh'
alias la='ls -A'

alias nano='micro'
alias readelf='readelf --wide'

alias dotfiles='/usr/bin/git --git-dir=$HOME/ade-home/dotfiles/ --work-tree=$HOME/ade-home'

function dis {
	gdb -batch -ex 'file '"$1" -ex 'set disassembly-flavor intel' -ex 'disassemble '"$2" | bat --language asm
}

function flamegraph {
	perf script -i ${1:-perf.data} | inferno-collapse-perf | inferno-flamegraph
}


function ctid {
	if [ $# -eq 0 ]; then
		echo "No arguments supplied"
	else
		clang-tidy -p build/compile_commands.json "$@"
	fi
}

###############################################################
# Work
###############################################################

alias sinst='source install/setup.bash'
alias scert='source install_cert/setup.bash'
alias sdebug='source install_rel/setup.bash'
alias sfoxy='source /opt/ros/foxy/setup.bash'
alias sgala='source /opt/ros/galactic/setup.bash'
alias shumb='source /opt/ros/humble/setup.bash'
alias sroll='source /opt/ros/rolling/setup.bash'
alias sapex='source /opt/ApexOS/setup.bash'

alias repo.check='bazel run --noshow_progress --ui_event_filters=-info --run_under="cd $(pwd) &&" //tools/repo:repo.check --'
alias repo.fix='bazel run --noshow_progress --ui_event_filters=-info --run_under="cd $(pwd) &&" //tools/repo:repo.fix --'
alias repo.sca='bazel run --noshow_progress --ui_event_filters=-info //apex_internal/tools/sca_check --'

function si {
	if [ $# -eq 0 ]; then
		echo "No arguments supplied"
	else
		local suffix=$1
		shift
		(source install_${suffix}/setup.bash && $@)
	fi
}
