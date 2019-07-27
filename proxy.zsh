#!/bin/zsh

listOpt() {

}

infoOpt() {
    echo "公网IP："$(curl https://ipinfo.io/ip)
    echo "内网IP："$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
}

helpOpt() {
    
}

shellProxy() {

}

sshProxy() {

}

gitProxy() {

}

goProxy(){

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
