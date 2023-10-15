#!/bin/bash

# TODO:
# √ check parameters
# √ check pack directory, if not found create
# √ check git repository, if not found init (and init submodules) 
# x handle install command
# √ - check for sub-args (eager or lazy load plugin, repo url)
# x - add optional sub arg that pins a plugin to head even though it's got a tag
# √ - invoke a git command to see if repo exists &or is clonable
# √ - create a subdir in pack dir with plugin name and check if a plugin with the same name is already installed
# √ - depending on subarg create opt (lazy) or start(eager) subdir
# √ - clone plugin & add to git submodule (with pinned version)
# √   - figure out how to pin the submodule to a commit that is tied to a specific branch
# √   - commit newly added plugin
# x - generate documentation
# x - if lazy loaded add a line to load the plugin?
# x   - or maybe i prompt the user to review the order in which the plugins are loaded?
# x   - or maybe i do this manually?
# x handle remove command
# √ - check sub args (name of pkg to remove)
# √ - check if name of pkg is actually the name of an installed package (can use a fuzzy finder to do "did you mean *** ?")
# √ - do git rm to remove repo from tree
# √ - rm -rf to remove files
# √ - remove repo also from .git/modules and git config, see https://stackoverflow.com/questions/1260748/how-do-i-remove-a-submodule
# x - if was lazy linked, check and remove import lines
# x handle the update command
# x handle a command to do setup when repo is first cloned (fetch all submodules, and other eventual stuff)
#
# TODO REFACTORING:
# - split the "prelude checks" part in 4 functions:
#  - check tools are installed (and that they are of the desired versions)
#  - check directories we need are present
#  - check that files in those directories are present
#  - check that the content of those files is congruent with what we expect

## USEFUL VARIABLES ##

repo_root=$(pwd)
plugins_dir="pack/plugins"
lua_dir="lua"
lua_package_dir="$lua_dir/package"
package_module_file="$lua_package_dir/init.lua"

## HELPER FUNCTIONS ##

die () {
    echo >&2 "$@"
    exit 1
}

add_to_file() {

filepath=$1
message=$2

# this doesn't work for some reason, even tho the file exists
if [[ ! -f $filepath ]]
then
    die "no file present at '$filepath'"
fi

if [[ -z "$message" ]]
then
    die "message is empty"
fi

# echo -e turns \n' into a newline
printf "%s" "$message" >> $filepath

}

remove_from_file() {

filepath=$1
pattern=$2

if [[ ! -f $filepath ]]
then
    die "no file present at '$filepath'"
fi

if [[ -z "$pattern" ]]
then
    die "pattern is empty"
fi
grep -v $pattern $filepath > ./tmp
mv tmp $filepath

}

setup_init_file() {

filename="init.lua"

touch $filename

printf "%s\n" "local setup = require('package.setup')" >> init.lua
printf "\n" >> init.lua
printf "%s\n" "setup.plugins()" >> init.lua

}

validate_init() {

grep -E "^local setup = require\('package.setup'\)$" init.lua > /dev/null 2>&1
FOUND=$?

[[ FOUND -eq 0 ]] || die "missing import for 'package.setup' from init.lua"

grep -E "^setup\.plugins\(\)$" init.lua > /dev/null 2>&1
FOUND=$?

[[ FOUND -eq 0 ]] || die "missing call to setup.plugins() from init.lua"

}

setup_package_module() {

touch $package_module_file

printf "%s\n" "local M = {}" >> $package_module_file
printf "%s\n" "function M.plugins()" >> $package_module_file
printf "%s\n" "    vim.cmd('helptags ALL')" >> $package_module_file
printf "%s\n" "end" >> $package_module_file
printf "%s" "return M" >> $package_module_file

}

validate_package_module() {

grep -E "vim\.cmd\('helptags ALL'\)" $package_module_file > /dev/null 2>&1
FOUND=$?

[[ FOUND -eq 0 ]] || die "missing helptags gen command from package module file"

}

add_dynamic_import() {

# add new module lua/plugins/importfuns/{plugin_name}
# - default content of this is a single 'import' function that just does a packadd
# add require in lua/plugins/init.lua for that module
# call that import function (before documentation gen)


# can use grep -n to get line number of match
# and then can use sed line addressing https://stackoverflow.com/questions/9533679/how-to-insert-a-text-at-the-beginning-of-a-file

echo noop
}

remove_dynamic_import() {

# remove module lua/plugins/importfuns/{plugin_name}
# delete require in lua/plugins/init.lua for that module
# delete the call to that import function (before documentation gen)


echo noop
}

check_git_install() {


# check git is installed

git --version > /dev/null 2>&1 # discard output
GIT_IS_INSTALLED=$?

[[ GIT_IS_INSTALLED ]] || die "git is not installed on this system"

# check git version

min_version="2.39.0"

if (echo a version $min_version; git --version) | sort -Vk3 | tail -1 | grep -q git
then
	echo "git version sufficent"
else
	die "git version not recent enough, wanted $min_version, got $(git --version)"
fi

}

commit_plugin_state() {

    message=$1

    git add "${repo_root}/pack" 
    git add "${repo_root}/.gitmodules"

    git commit -m "$message"
    COMMIT_STATUS=$?

    if [[ ! COMMIT_STATUS -eq 0 ]]
    then
        die "couldn't commit changes"
    fi

}

## PRE-COMMAND CHECKS ##

# check parameters

# check we've got some arguments passed in

if [[ ! "$#" -gt 0 ]]
then
     die "no arguments provided"
fi

# check pack directory, if not found create

if [[ ! -d $plugins_dir ]]
then
     echo "creating ./pack directory"
     mkdir -p $plugins_dir
fi

# check lua directory, if not found create

if [[ ! -d $lua_dir ]]
then
     echo "creating ./$lua_dir directory"
     mkdir -p $lua_dir
fi

# check lua package directory

if [[ ! -d $lua_package_dir ]]
then
     echo "creating ./$lua_package_dir directory"
     mkdir -p $lua_package_dir
fi

# check initfile is present

if [[ ! -f init.lua ]]
then
    setup_init_file    
fi

#validate_init

if [[ ! -f $package_module_file ]]
then
    setup_package_module
fi

#validate_package_module

# check git install

check_git_install

# check ripgrep is installed

rg --version > /dev/null 2>&1 # discard output
RG_IS_INSTALLED=$?

[[ RG_IS_INSTALLED ]] || die "ripgrep is not installed on this system"

# check we are in a git repo, otherwise initalize it
git rev-parse --is-inside-work-tree > /dev/null 2>&1 # discard output
GIT_REPO_PRESENT=$?

if [[ GIT_REPO_PRESENT -ne 0 ]]
then
    echo "git repo not found, initializing"
    git init > /dev/null 2>&1
    git submodule init
fi

## INSTALL COMMAND ##
install() {
    echo "install called with $@" 
    
    install_mode=$2
    repo_url=$3

    # check install mode param
    echo $install_mode | grep -E -q "eager|lazy" || die "install can only be called with 'eager' or 'lazy', instead '$install_mode' was passed"

    # check repo url
    # regex from here with a couple of tweaks: https://stackoverflow.com/questions/2514859/regular-expression-for-git-repository 
    repo_url_regex="((git|ssh|http(s)?)|(git@[\w\.]+))(:(\/\/)?)([\w\.@\:\/\-~]+)(\/)"

    echo $repo_url | grep -E -q $repo_url_regex || die "repo url '$repo_url' does not match regex pattern"

    # check remote repo exists
    GIT_TERMINAL_PROMPT=0 git ls-remote $repo_url HEAD > /dev/null 2>&1
    GIT_REPO_EXISTS=$? 

    if [[ ! GIT_REPO_EXISTS -eq 0 ]]
    then
        die "couldn't find git repo at '$repo_url', it might not exist or be private"
    fi

    # create plugin directory and check if plugin is already installed

    plugin_name=$(echo $repo_url | xargs basename -s .git)
    plugin_root=""

    if [[ $install_dir -eq "eager" ]]
    then
        plugin_root="${plugins_dir}/start/${plugin_name}" 
        [[ -d $plugin_root ]] && die "plugin with name $plugin_name is already present at $plugin_root" 
    else
        plugin_root="${plugins_dir}/opt/${plugin_name}"
        [[ -d $plugin_root ]] && die "plugin with name $plugin_name is already present at $plugin_root" 
    fi

    git submodule add $repo_url $plugin_root
    SUBMODULE_ADD_SUCCESSFUL=$?

    if [[ ! SUBMODULE_ADD_SUCCESSFUL -eq 0 ]] 
    then
        die "couldn't add cloned repo as submodule"
    fi


    echo $plugin_root | grep "opt" 
    STATUS=$?

    echo found $STATUS

    if [[ $STATUS -eq 0 ]]
    then
	    add_to_file $package_module_file "vim.cmd('packadd $plugin_name')"
    fi

    
    
    latest_tagged_version=$(cd $plugin_root && git describe --abbrev=0 --tags)
    STATUS=$?

    if [[ ! STATUS -eq 0 ]] 
    then
        echo "no tags found, pinning to HEAD"

        cd $repo_root

        commit_plugin_state "installed ${plugin_name} at HEAD"
    else
        cd $plugin_root
	
	git checkout $latest_tagged_version > /dev/null 2>&1
	STATUS=$?

	[[ STATUS -eq 0 ]] || die "couldn't checkout the $latest_tagged_version tag"

        cd $repo_root

        commit_plugin_state "installed ${plugin_name} at version $latest_tagged_version" 
    fi

}

## UNINSTALL COMMAND ##
uninstall() {
    echo "uninstall called with $@"

    plugin_to_remove=$2

    plugin_dir=""

    if [[ -d "${plugins_dir}/start/${plugin_to_remove}" ]]
    then 
        plugin_dir="${plugins_dir}/start/${plugin_to_remove}"
    elif [[ -d "${plugins_dir}/opt/${plugin_to_remove}" ]]
    then 
        plugin_dir="${plugins_dir}/opt/${plugin_to_remove}"
    else
        die "no plugin with name ${plugin_to_remove} found in ${plugins_dir}"
    fi

    echo "removing plugin ${plugin_to_remove}"

    git rm $plugin_dir
    GIT_RM_STATUS=$?

    [[ GIT_RM_STATUS -eq 0 ]] || die "couldn't git rm plugin directory" 

    rm -rf $plugin_dir
    RM_STATUS=$?

    [[ RM_STATUS -eq 0 ]] || die "couldn't delete plugin directory"

    commit_plugin_state "removed $plugin_to_remove"

    rm -rf ".git/modules/${plugin_dir}"
    RM_STATUS=$?

    [[ RM_STATUS -eq 0 ]] || die "couldn't git rm .git/modules plugin directory" 


    git config --remove-section "submodule.${plugin_dir}"
    GIT_CONFIG_STATUS=$?

    [[ GIT_CONFIG_STATUS -eq 0 ]] || die "couldn't remove plugin directory from git config"

    echo $plugin_dir | grep "opt" > /dev/null 2>&1
    STATUS=$?

    if [[ $STATUS -eq 0 ]]
    then
        remove_from_file $package_module_file "$plugin_name"
    fi

    echo "removed $plugin_to_remove"
}

## UPDATE COMMAND ##
update() {
    echo "update called with $@" 
}

## COMMAND SWITCH
case $1 in
    install)
        install $@
        ;;
    uninstall)
        uninstall $@
        ;;
    update)
        update $@
        ;;
    *)
        die "unrecognized command: $1"
        ;;
esac


