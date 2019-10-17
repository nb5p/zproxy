#!/bin/zsh

function listOpt() {

}

function infoOpt() {
    echo "公网IP："
    curl -s ip.sb
    echo "内网IP："
    ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
}

function helpOpt() {
    
}

function shellProxy() {

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

    (info)
    infoOpt
    ;;

    (help)
    echo "@help"
    ;;

    (shell)
    echo "@shell"
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
