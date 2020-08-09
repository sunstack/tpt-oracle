#!/bin/bash

# Copyright 2020 Tanel Poder. All rights reserved. 
# Licensed under the Apache License, Version 2.0.

# Purpose: enable I/O throttling for a block device using cgroups
#
# Usage: find block device major:minor numbers using ls -l /dev or lsblk
#        ./enable_throttle.sh <major:minor> <max_iops> <max_bps>
#        ./enable_throttle.sh 259:3 500 100000000
#
# More info at https://tanelpoder.com
# 
# sun noet:
# 
#  need get device maj:min info ( like  259:3) from lsblk  or ls -l /dev
#[oracle@srv1 disks]$ lsblk
#NAME                       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
#sda                          8:0    0    2G  0 disk
#└─sda1                       8:1    0    2G  0 part
#sdb                          8:16   0   50G  0 disk
#└─sdb1                       8:17   0   50G  0 part
#sdc                          8:32   0  100G  0 disk
#├─sdc1                       8:33   0  500M  0 part /boot
#└─sdc2                       8:34   0 99.5G  0 part
#  ├─vg_srv1-lv_root (dm-0) 252:0    0 93.7G  0 lvm  /
#  └─vg_srv1-lv_swap (dm-1) 252:1    0  5.9G  0 lvm  [SWAP]
#sr0                         11:0    1 1024M  0 rom
#sr1                         11:1    1 1024M  0 rom
#nvme0n1                    259:0    0    1T  0 disk
#└─nvme0n1p1                259:4    0 1024G  0 part
#nvme0n2                    259:2    0    1T  0 disk
#└─nvme0n2p1                259:5    0 1024G  0 part
#[oracle@srv1 disks]$ ls -la /dev/oracleasm/disks
#total 0
#drwxr-xr-x. 1 root root       0 Aug  5 21:13 .
#drwxr-xr-x. 4 root root       0 Aug  5 21:13 ..
#brw-rw----. 1 grid dba    8,  1 Aug  9 07:43 CRSDISK1
#brw-rw----. 1 grid dba  259,  4 Aug  9 07:43 DATADISK10
#brw-rw----. 1 grid dba  259,  5 Aug  9 07:42 DATADISK11
#brw-rw----. 1 grid dba    8, 17 Aug  9 07:43 FRADISK1
#[oracle@srv1 disks]$
#
# ./enable_throttle.sh 8:1 500 100000000
# ./enable_throttle.sh 8:1 500 100000000
# ./enable_throttle.sh 259:4 500 100000000
# ./enable_throttle.sh 259:5 500 100000000
# and need run following to unset the io throttle
# ./enable_throttle.sh 8:1
# ./enable_throttle.sh 8:1
# ./enable_throttle.sh 259:4
# ./enable_throttle.sh 259:5

DEVICE_ID=$1
DEVICE_IOPS=$2
DEVICE_BPS=$3

echo $DEVICE_ID $DEVICE_IOPS > /sys/fs/cgroup/blkio/blkio.throttle.write_iops_device
echo $DEVICE_ID $DEVICE_IOPS > /sys/fs/cgroup/blkio/blkio.throttle.read_iops_device

echo $DEVICE_ID $DEVICE_BPS > /sys/fs/cgroup/blkio/blkio.throttle.write_bps_device
echo $DEVICE_ID $DEVICE_BPS > /sys/fs/cgroup/blkio/blkio.throttle.read_bps_device

grep . /sys/fs/cgroup/blkio/blkio.throttle*device

