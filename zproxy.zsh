#!/usr/bin/env zsh
# set -x

# Get IP {{{
function outOpt() { curl -s ip.sb }
function inOpt() { ifconfig \
    | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' }
function ipOpt() { echo "Public IP:"; outOpt; echo "Intranet IP:"; inOpt }
# }}}

# Scan Port {{{
function getPortAvailable() { nc -z ${2:-127.0.0.1} $1 }
# }}}

# Handle Shell {{{
function shellProxy() {
    what=shell
    (( ${+shell} )) || { echo "Config Error, with \e[31;1m$what\e[0m";
        exit 11 };
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
            echo -n "\e[33;1m"
            echo -n "  unset HTTP_PROXY HTTPS_PROXY ALL_PROXY"
            echo "\e[0m"
        ;;
        (on)
            for element ($shell) {
                port=`getValue $element socks`
                getPortAvailable $port
                [[ "$?" == 0 ]] && echo $port
            }
        ;;
        (*)
            (( ${+1} )) || { echo "Parameter Error, with \e[31;1m$what\e[0m";
                exit 21 }
            (( $shell[(I)$1] )) || { echo "Config Error, with \e[31;1m$what > $1\e[0m";
                exit 12 }
            hport=`getValue $1 http`
            sport=`getValue $1 socks`
            [[ "$hport" == "" && "$sport" == "" ]] && {
                echo "Config Error, with \e[31;1m$what > $1 > http|socks\e[0m"; exit 13 }
            echo "Please run:"
            echo -n "\e[33;1m"
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
    what=npm
    { command -v npm > /dev/null } || { echo "Command Error, with \e[31;1m$what\e[0m"; exit 31 }
    (( ${+npm} )) || { echo "Config Error, with \e[31;1m$what\e[0m"; exit 11 };
    case $1 {
        (list) npm config list ;;
        (off) npm config set registry https://registry.npmjs.org/ ;;
        (on) ;;
        (*)
            (( ${+1} )) || { echo "Parameter Error, with \e[31;1m$what\e[0m";
                exit 21 }
            (( $npm[(I)$1] )) || { echo "Config Error, with \e[31;1m$what > $1\e[0m";
                exit 12 }
            mirror=`getValue $1 npm`
            [[ "$mirror" == "" ]] && {
                echo "Config Error, with \e[31;1m$what > $1 > mirrors\e[0m"; exit 13 }
            npm config set registry $mirror
        ;;
    }
}
# }}}

# Handle PIP {{{
function pipMirrors() {
    what=pip
    { command -v pip3 > /dev/null } || { echo "Command Error, with \e[31;1m$what\e[0m"; exit 31 }
    (( ${+pip} )) || { echo "Config Error, with \e[31;1m$what\e[0m"; exit 11 };
    case $1 {
        (list) pip3 config get global.index-url ;;
        (off) pip3 config unget global.index-url ;;
        (on) ;;
        (*)
            (( ${+1} )) || { echo "Parameter Error, with \e[31;1m$what\e[0m";
                exit 21 }
            (( $pip[(I)$1] )) || { echo "Config Error, with \e[31;1m$what > $1\e[0m";
                exit 12 }
            mirror=`getValue $1 pip`
            [[ "$mirror" == "" ]] && {
                echo "Config Error, with \e[31;1m$what > $1 > mirrors\e[0m"; exit 13 }
            pip3 config set global.index-url $mirror
        ;;
    }
}
# }}}

# Handle config file {{{
function handleConfig() {
    case $1 {
        (edit)
            ${+EDITOR:-vi} $configFile
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
if [[ ! -f "./config.zsh" ]] { (( ${+XDG_CONFIG_HOME} )) \
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

    (npm) npmMirrors $2 ;;
    (pip) pipMirrors $2 ;;

    (config) handleConfig $2 ;;
}
