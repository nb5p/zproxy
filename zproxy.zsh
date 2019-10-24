#!/bin/zsh

function listOpt() {

}

function outOpt() {
    curl -s ip.sb
}

function inOpt() {
    ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
}

function ipOpt() {
    echo "Public IP:"
    outOpt
    echo "Intranet IP:"
    inOpt
}

function helpOpt() {
    
}

function shellProxy() {
    case $1 {
        (list)
        [[ ""$HTTP_PROXY"" == "" && "$HTTPS_PROXY" == "" && "$ALL_PROXY" == "" ]] && echo "UNSET"
        [[ "$HTTP_PROXY" != "" ]] && echo "HTTP_PROXY="$HTTP_PROXY
        [[ "$HTTPS_PROXY" != "" ]] && echo "HTTPS_PROXY="$HTTPS_PROXY
        [[ "$ALL_PROXY" != "" ]] && echo "ALL_PROXY="$ALL_PROXY
        ;;
    }
}

function sshProxy() {

}

function gitProxy() {

}

function goProxy(){

}

case $1 {
    (list)
    echo "@list"
    ;;

    (ipi)
    inOpt
    ;;

    (ipe)
    outOpt
    ;;

    (ip)
    ipOpt
    ;;

    (help)
    echo "@help"
    ;;

    (shell)
    shellProxy $2
    ;;

    (ssh)
    echo "@ssh"
    ;;

    (git)
    echo "@git"
    ;;

    (go)
    echo "@go"
    ;;
}
