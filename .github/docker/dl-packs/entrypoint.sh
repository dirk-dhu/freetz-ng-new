#! /usr/bin/env bash
[ "$#" -gt 0 ] && su "$BUILD_USER" -c "$@" || su "$BUILD_USER"
