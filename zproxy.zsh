#!/bin/zsh
#set -x

# Get IP {{{
function outOpt() { curl -s ip.sb }
function inOpt() { ifconfig \
    | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' }
function ipOpt() { echo "Public IP:"; outOpt; echo "Intranet IP:"; inOpt }
# }}}

# Handle Shell {{{
function shellProxy() {
    case $1 {
        (list)
            [[ "$HTTP_PROXY" == "" && "$HTTPS_PROXY" == "" && "$ALL_PROXY" == "" ]] \
                && echo "UNSET PROXY"
            [[ "$HTTP_PROXY" != "" ]] && echo "HTTP_PROXY="$HTTP_PROXY
            [[ "$HTTPS_PROXY" != "" ]] && echo "HTTPS_PROXY="$HTTPS_PROXY
            [[ "$ALL_PROXY" != "" ]] && echo "ALL_PROXY="$ALL_PROXY
        ;;
        (off)
            echo "Please run:"
            echo -n "\e[31;1m"
            echo -n "  unset HTTP_PROXY HTTPS_PROXY ALL_PROXY"
            echo "\e[0m"
        ;;
        (on) ;;
        (*)
            hport=`getValue ${1} http`
            sport=`getValue ${1} socks`
            echo "Please run:"
            echo -n "\e[31;1m"
            echo -n "  export HTTP_PROXY=http://localhost:${hport}; "
            echo -n "export HTTPS_PROXY=http://localhost:${hport}; "
            echo -n "export ALL_PROXY=socks5://localhost:${sport}"
            echo "\e[0m"
        ;;
    }
}
# }}}

# Handle NPM {{{
function npmMirrors() {
    case $1 {
        (list) npm config list ;;
        (off) npm config set registry https://registry.npmjs.org/ ;;
        (on) ;;
        (*)
            mirror=`getValue ${1} npm`
            npm config set registry $mirror
        ;;
    }
}
# }}}

# Handle PIP {{{
function pipMirrors() {
    case $1 {
        (list) pip3 config get global.index-url ;;
        (off) pip3 config unget global.index-url ;;
        (on) ;;
        (*)
            mirror=`getValue ${1} pip`
            pip3 config set global.index-url $mirror
        ;;
    }
}
# }}}

# Handle config file {{{
function handleConfig() {
    case $1 {
        (edit)
            [[ "$+EDITOR" ]] && $EDITOR $configFile || vi $configFile
        ;;
        (list)
            cat $configFile
        ;;
    }
}
function getValue() {
    typeset -A hashTab=(${(kvP)1})
    echo $hashTab[$2]
}
# }}}

# Get config file {{{
if [[ ! -f "./config.zsh" ]] { (($+XDG_CONFIG_HOME)) \
    && configFile="$XDG_CONFIG_HOME/zproxy/config.zsh" \
    || configFile="$HOME/.config/zproxy/config.zsh"
} else { configFile="./config.zsh" }
source $configFile
# }}}

case $1 {
    (ipi) inOpt ;;
    (ipe) outOpt ;;
    (ip) ipOpt ;;

    (shell) shellProxy $2 ;;
    (ssh) sshProxy $2 ;;
    (git) gitProxy $2 ;;

    (npm) npmMirrors $2 ;;
    (pip) pipMirrors $2 ;;
    (brew) brewMirrors $2 ;;
    (conda) condaMirrors $2 ;;

    (config) handleConfig $2 ;;
}
