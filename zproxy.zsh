#!/bin/zsh

# Get IP {{{
function outOpt() { curl -s ip.sb }
function inOpt() { ifconfig \
    | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' }
function ipOpt() { echo "Public IP:"; outOpt; echo "Intranet IP:"; inOpt }
# }}}

function shellProxy() {
    case $1 {
        (list)
        [[ ""$HTTP_PROXY"" == "" && "$HTTPS_PROXY" == "" && "$ALL_PROXY" == "" ]] \
            && echo "UNSET PROXY"
        [[ "$HTTP_PROXY" != "" ]] && echo "HTTP_PROXY="$HTTP_PROXY
        [[ "$HTTPS_PROXY" != "" ]] && echo "HTTPS_PROXY="$HTTPS_PROXY
        [[ "$ALL_PROXY" != "" ]] && echo "ALL_PROXY="$ALL_PROXY
        ;;
    }
}

# Handle config file {{{
function editConfig() { [[ "$+EDITOR" ]] && $EDITOR $configFile || vi $configFile }
function getPort() {
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
    (edit) editConfig ;;
}
