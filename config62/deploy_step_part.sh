#!/bin/bash
./deploy_env.sh

if [ "$3" = "u2" ]; then
    echo "u2路径"
    ./deploy_part.sh
elif [ "$3" = "m2" ]; then
    echo "m2路径"
    ./deploy_part_m2.sh
else 
    echo "默认路径"
fi

./deploy_clef.sh
./deploy_bee.sh $1 $2