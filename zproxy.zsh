#!/bin/zsh

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
            [[ ""$HTTP_PROXY"" == "" && "$HTTPS_PROXY" == "" && "$ALL_PROXY" == "" ]] \
                && echo "UNSET PROXY"
            [[ "$HTTP_PROXY" != "" ]] && echo "HTTP_PROXY="$HTTP_PROXY
            [[ "$HTTPS_PROXY" != "" ]] && echo "HTTPS_PROXY="$HTTPS_PROXY
            [[ "$ALL_PROXY" != "" ]] && echo "ALL_PROXY="$ALL_PROXY
        ;;
        (off) unset HTTP_PROXY HTTPS_PROXY ALL_PROXY ;;
        (*)
            hport=`getValue ":${1}.http"`
            sport=`getValue ":${1}.socks"`
            export HTTP_PROXY=http://localhost:${hport}
            export HTTPS_PROXY=http://localhost:${hport}
            export ALL_PROXY=socks5://localhost:${sport}
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
    }
}
function getValue() {
    value=`sed -n '/\['${1:r}'\]/,/^$/p' $configFile \
        | grep -Ev '\[|\]|^$' \
        | awk -F '=' '$1 == "'${1:e}'" {print $2}' \
    `
    echo $value
}
# }}}

# Get config file location {{{
if [[ ! -f "./.zproxyrc" ]] { (($+XDG_CONFIG_HOME)) \
    && configFile="$XDG_CONFIG_HOME/zproxy/zproxyrc" \
    || configFile="$HOME/.config/zproxy/zproxyrc"
} else { configFile="./.zproxyrc" }
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
