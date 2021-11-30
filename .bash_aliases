alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gs='git status'
alias gp='git push --set-upstream dev $(git symbolic-ref --short HEAD)'

alias ll='ls -lh'
alias la='ls -A'

alias nano='micro'
alias readelf='readelf --wide'

alias dotfiles='/usr/bin/git --git-dir=$HOME/ade-home/dotfiles/ --work-tree=$HOME/ade-home'

# And it would be nice to have completions
# https://brbsix.github.io/2015/11/23/perform-tab-completion-for-aliases-in-bash/
_completion_loader git
__git_complete gco _git_checkout
__git_complete gb _git_branch
__git_complete gd _git_diff
__git_complete gs _git_status

function dis {
	gdb -batch -ex 'file '"$1" -ex 'set disassembly-flavor intel' -ex 'disassemble '"$2" | bat --language asm
}

function flamegraph {
	perf script -i ${1:-perf.data} | inferno-collapse-perf | inferno-flamegraph
}

function colcon {
	if [ "$(pwd)" != "/home/nikolai.morin/gc/apex_ws" ]; then
		echo "colcon must be run from apex_ws"
	fi
	command colcon "$@"
}

function colcon_build_in {
	local suffix=$1
	shift
	colcon build --build-base build_"$suffix" --install-base install_"$suffix" "$@"
}

function colcon_build_cert {
	colcon_build_in cert --mixin certifiable "$@"
}

function colcon_build_asan {
	colcon_build_in asan --cmake-args '-DCMAKE_CXX_FLAGS="-fsanitize=address"' '-DCMAKE_C_FLAGS="-fsanitize=address"' "$@"
}

function colcon_build_ubsan {
	colcon_build_in ubsan --cmake-args '-DCMAKE_CXX_FLAGS="-fsanitize=undefined"' '-DCMAKE_C_FLAGS="-fsanitize=undefined"' "$@"
}

function colcon_build_prof {
	colcon_build_in prof --cmake-args '-DBUILD_TESTING=OFF' '-DCMAKE_CXX_FLAGS="-fno-omit-frame-pointer"' '-DCMAKE_C_FLAGS="-fno-omit-frame-pointer"' "$@"
}

function cbu {
	colcon build --packages-up-to "$@"
}

function cbu_cert {
	colcon_build_cert --packages-up-to "$@"
}

function cbu_asan {
	colcon_build_asan --packages-up-to "$@"
}

function cbu_ubsan {
	colcon_build_ubsan --packages-up-to "$@"
}

function cbu_prof {
	colcon_build_prof --packages-up-to "$@"
}

function cbs {
	colcon build --packages-select "$@"
}

function cbs_cert {
	colcon_build_cert --packages-select "$@"
}

function cbs_asan {
	colcon_build_asan --packages-select "$@"
}

function cbs_ubsan {
	colcon_build_ubsan --packages-select "$@"
}

function cbs_prof {
	colcon_build_prof --packages-select "$@"
}

function colcon_test_in {
	local suffix=$1
	shift
	colcon test --build-base build_"$suffix" --install-base install_"$suffix" "$@"
}

function retest {
	rm -r {build,install}/"$1"
	cbs "$1"
	colcon test-result --delete-yes
	(unset ROS_DOMAIN_ID; source /opt/ApexOS/setup.bash; colcon test --packages-select $1 && colcon test-result --verbose | bat)
}

function retest_cert {
	rm -r {build,install}_cert/"$1"
	cbs_cert "$1"
	colcon test-result --test-result-base build_cert --delete-yes
	(export APEX_CERT=ON; unset ROS_DOMAIN_ID; source /opt/ApexOS/setup.bash; colcon test --build-base build_cert --install-base install_cert --packages-select "$@" && colcon test-result --test-result-base build_cert --verbose | bat)
}

# Fuzzy search package names with Ctrl-F Ctrl-F
# https://junegunn.kr/2016/07/fzf-git/
prompt_packages() {
	# Assume that parent dir name = package name
	fd package.xml --type f -x basename {//} | sort -u | fzf
}
bind '"\er": redraw-current-line'
bind '"\C-f\C-f": "$(prompt_packages)\e\C-e\er"'

function ctid {
	if [ $# -eq 0 ]; then
		echo "No arguments supplied"
	else
		clang-tidy -p build/compile_commands.json "$@"
	fi
}

alias sinst='source install/setup.bash'
alias sfoxy='source /opt/ros/foxy/setup.bash'
alias sgala='source /opt/ros/galactic/setup.bash'
alias sroll='source /opt/ros/rolling/setup.bash'
alias sapex='source /opt/ApexOS/setup.bash'
