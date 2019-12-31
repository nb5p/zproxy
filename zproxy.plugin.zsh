function zproxy() {
# set -x

# Author: nb5p (https://github.com/nb5p)
# License: MIT
# Issue: https://github.com/nb5p/zproxy/issues

# EXIT CODE
#  0 - OK
# 11 - Config Error
# 12 - Config Error 
# 13 - Config Error 
# 14 - Port Not Available
# 21 - Parameter Error
# 31 - Command Not Found
# 32 - Config Not Found

# Get IP {{{
function outOpt() { checkCMD curl && curl -s ip.sb || return 31 }
function inOpt() {
    checkCMD ifconfig && {
        ifconfig | \
        sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
    } || { return 31 }
}
function ipOpt() { echo "Public IP:"; outOpt; echo "Intranet IP:"; inOpt }
# }}}

# MSIC {{{
function checkCMD() {
    { command -v $1 > /dev/null } || {
        echo "Command Not Found, with \e[31;1m$1\e[0m"
        return 31
    }
}
function getPortAvailable() {
    checkCMD nc && {
        nc -z ${2:-127.0.0.1} $1 &> /dev/null
    } || { return 31 }
}
# }}}

# Handle Shell {{{
function shellProxy() {
    what=shell
    (( ${+shell} )) || {
        echo "Config Error, with \e[31;1m$what\e[0m"
        return 11
    }
    case $1 {
        (list)
            [[ "$HTTP_PROXY" == "" && "$HTTPS_PROXY" == "" && \
                "$ALL_PROXY" == "" ]] && { echo "UNSET PROXY"; return 0 } || {
                [[ "$HTTP_PROXY" != "" ]] && echo "HTTP_PROXY="$HTTP_PROXY
                [[ "$HTTPS_PROXY" != "" ]] && echo "HTTPS_PROXY="$HTTPS_PROXY
                [[ "$ALL_PROXY" != "" ]] && echo "ALL_PROXY="$ALL_PROXY
                return 0
            }
        ;;
        (off)
            unset HTTP_PROXY HTTPS_PROXY ALL_PROXY
        ;;
        (on)
            for element ($shell) {
                port=`getValue $element socks`
                getPortAvailable $port
                [[ "$?" == 0 ]] && {
                    echo "Using \e[32m$element\e[0m"
                    shellProxy $element
                    unset element
                    allright=1
                    break
                }
            }
            (( ${+allright} )) && { unset allright } || {
                echo "Port error, with \e[31;1m$what > on\e[0m"
                return 14
            }
        ;;
        (*)
            (( ${+1} )) || {
                echo "Parameter Error, with \e[31;1m$what\e[0m"
                return 21
            }
            (( $shell[(I)$1] )) || {
                echo "Config Error, with \e[31;1m$what > $1\e[0m"
                return 12
            }
            hport=`getValue $1 http`; sport=`getValue $1 socks`
            [[ "$hport" == "" && "$sport" == "" ]] && {
                echo "Config Error, with \e[31;1m$what > $1 > http|socks\e[0m"
                return 13
            }
            export HTTP_PROXY=http://localhost:${hport}
            export HTTPS_PROXY=http://localhost:${hport}
            export ALL_PROXY=socks5://localhost:${sport}
            unset hport; unset sport
        ;;
    }
    unset what
}
# }}}

# Handle NPM {{{
function npmMirrors() {
    what=npm
    checkCMD $what || return 31
    (( ${+npm} )) || { echo "Config Error, with \e[31;1m$what\e[0m"; return 11 }
    case $1 {
        (list) npm config list ;;
        (off) npm config set registry https://registry.npmjs.org/ ;;
        (on)
            npmMirrors ${npm[1]}
        ;;
        (*)
            (( ${+1} )) || {
                echo "Parameter Error, with \e[31;1m$what\e[0m"
                return 21
            }
            (( $npm[(I)$1] )) || {
                echo "Config Error, with \e[31;1m$what > $1\e[0m"
                return 12
            }
            mirror=`getValue $1 npm`
            [[ "$mirror" == "" ]] && {
                echo "Config Error, with \e[31;1m$what > $1 > mirrors\e[0m"
                return 13
            }
            npm config set registry $mirror
            unset mirror
        ;;
    }
    unset what
}
# }}}

# Handle PIP {{{
function pipMirrors() {
    what=pip
    checkCMD pip3 || return 31
    (( ${+pip} )) || { echo "Config Error, with \e[31;1m$what\e[0m"; return 11 }
    case $1 {
        (list) pip3 config get global.index-url ;;
        (off) pip3 config unget global.index-url ;;
        (on)
            pipMirrors ${pip[1]}
        ;;
        (*)
            (( ${+1} )) || {
                echo "Parameter Error, with \e[31;1m$what\e[0m"
                return 21
            }
            (( $pip[(I)$1] )) || {
                echo "Config Error, with \e[31;1m$what > $1\e[0m"
                return 12
            }
            mirror=`getValue $1 pip`
            [[ "$mirror" == "" ]] && {
                echo "Config Error, with \e[31;1m$what > $1 > mirrors\e[0m"
                return 13
            }
            pip3 config set global.index-url $mirror > /dev/null
            unset mirror
        ;;
    }
    unset what
}
# }}}

# Handle config file {{{
function handleConfig() {
    case $1 {
        (edit)
            ${+EDITOR:-vi} $__zproxyConfigFile
        ;;
        (list)
            cat $__zproxyConfigFile
        ;;
    }
}
function getValue() {
    typeset -A hashTab=(${(kvP)1})
    echo $hashTab[$2]
    unset hashTab
}
# }}}

# Get config file {{{
if (( ${+__zproxyConfigFile} )) {} else {
    (( ${+XDG_CONFIG_HOME} )) \
        && __zproxyConfigFile="$XDG_CONFIG_HOME/zproxy/config.zsh" \
        || __zproxyConfigFile="$HOME/.config/zproxy/config.zsh"
}
if [[ -f "$__zproxyConfigFile" ]] {
    source $__zproxyConfigFile
} else {
    echo "Config Not Found in '\$XDG_CONFIG_HOME/zproxy/config.zsh'"
    return 32
}
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

unfunction outOpt
unfunction inOpt
unfunction ipOpt
unfunction checkCMD
unfunction getPortAvailable
unfunction shellProxy
unfunction npmMirrors
unfunction pipMirrors
unfunction handleConfig
unfunction getValue

# End of function Main
}
