#!/bin/bash -e

set -euxo pipefail

if [ -d "/var/lib/docker" ]; then 
        yum install -y lvm2
        pvcreate  /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 -y
        vgcreate TLVM  /dev/nvme0n1 
        vgextend TLVM /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1
        lvcreate -l 100%VG -nLVMDATA TLVM -y
        mkfs -t ext4 /dev/TLVM/LVMDATA
        mount /dev/TLVM/LVMDATA /var/lib/docker
        echo '/dev/TLVM/LVMDATA  /var/lib/docker ext4 defaults 0 0 ' >> /etc/fstab
        echo "Local disks are provisioned succesfully"
        echo "=============== 重置docker默认存储路径  /var/lib/docker 重启docker =================="
        sudo systemctl restart docker

else 
    echo "默认存储路径/var/lib/docker不存在"
    exit 1
fi
