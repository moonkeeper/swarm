#!/bin/bash -e

set -euxo pipefail

cd /usr/local/src
yum install -y wget
wget https://codeload.github.com/linux-nvme/nvme-cli/tar.gz/refs/tags/v1.14
tar zxvf v1.14
cd nvme-cli-1.14
yum -y install gcc-c++
make && make install
cd /root/deploy



BASE_DIR=${BASE_DIR:-"/mnt/disks"}
NVME_LIST=($(nvme list | grep "nvme" | cut -d " " -f 1 || true))
NVME_COUNT=${#NVME_LIST[@]}

PARTED_SCRIPT=${PARTED_SCRIPT:-""}
echo "script : $PARTED_SCRIPT"

# Checking if local disks are already provisioned
if [[ "$(ls -A $BASE_DIR)" ]]
then
  echo -e "\n$(ls -Al $BASE_DIR | tail -n +2)\n"
  echo "Local disks are already provisioaned"
  exit 1
fi

mkdir -p $BASE_DIR

case ${NVME_COUNT} in
"0")
  printf "There are no ' NVMe Instance Storage' devices.\n"
  exit 1
  ;;

*)
  printf "Following ' NVMe Instance Storage' devices are found:\n"
  printf "%s\n" ${NVME_LIST[@]}
  if [ -z "$PARTED_SCRIPT" ]
  then
    # PARTITIONING
    printf "Proceed without partitioning.\n"
    # FORMATTING
    for NVME in ${NVME_LIST[@]}
    do
      mkfs.xfs -f $NVME
      UUID=$(blkid -s UUID -o value "$NVME")
      mkdir $BASE_DIR/$UUID
      mount -t xfs "$NVME" "$BASE_DIR/$UUID"
      echo UUID=`blkid -s UUID -o value "$NVME"` $BASE_DIR/$UUID xfs defaults 0 2 | tee -a /etc/fstab
    done
  else
    # PARTITIONING
    printf "Partitioning script: %s\n" "${PARTED_SCRIPT}"
    for NVME in ${NVME_LIST[@]}
    do
      parted --script $NVME ${PARTED_SCRIPT}
    done
    # FORMATTING
    for NVME in ${NVME_LIST[@]}
    do
      PARTITION_COUNT=$(lsblk | grep $(cut -d'/' -f3 <<<$NVME)p | wc -l)
      for i in $(seq 1 $PARTITION_COUNT); do
        mkfs.xfs -f "$NVME"p"$i"
        UUID=$(blkid -s UUID -o value "$NVME"p"$i")
        mkdir $BASE_DIR/$UUID
        mount -t xfs "$NVME"p"$i" $BASE_DIR/$UUID
        echo UUID=`blkid -s UUID -o value "$NVME"p"$i"` $BASE_DIR/$UUID xfs defaults 0 2 | tee -a /etc/fstab
      done
    done
  fi

  ;;
esac

echo "Local disks are provisioned succesfully"

N_ONE=${NVME_LIST[0]}
UUID=$(blkid -s UUID -o value "$N_ONE")

echo "=============== 挂载磁盘uuid  $UUID  =================="
echo "=============== 重置docker默认存储路径  $UUID  =================="

if [ -n "$UUID" ] 
    then  
        if [ ! -f /etc/docker/daemon.json ]
            then 
                cp daemon.json /etc/docker/daemon.json

                old=\\/www\\/docker
                new=\\/mnt\\/disks\\/$UUID
                sed -i "s/$old/$new/g" /etc/docker/daemon.json
        fi
        
else 
    echo "挂载磁盘uuid 存在"
fi

echo "=============== 重置docker默认存储路径 完毕 重启docker  =================="
sudo systemctl restart docker