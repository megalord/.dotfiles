#!/usr/bin/env bash

function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

run compton --daemon
