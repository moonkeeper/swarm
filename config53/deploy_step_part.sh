#!/bin/bash
./deploy_env.sh

if [ "$3" -eq 1 ] then
    ./deploy_part.sh
if

./deploy_clef.sh
./deploy_bee.sh $1 $2