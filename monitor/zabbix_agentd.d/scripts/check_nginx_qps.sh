#!/usr/bin/env bash
# vim:fileencoding=UTF-8

# FileName: check_nginx_qps.sh
# Created:  1月 6, 2017
# Author(s): Xu Guojun 

:<<!
================================================================
bash check_nginx_qps.sh /data/nginx/logs qinguan_access.log
!

#set -ex
die() { printf "%s: %s\n" "$0" "$@"; exit 1; }

[ -n "$1" ] || die "DIRECTORY missing"
[ -n "$2" ] || die "FILENAME missing"

dest_dir=$1
target_file=$2

[ -f $dest_dir/$target_file ] || die "file does not exist!"

target_gz=`ls $dest_dir -t | grep "$target_file.*.gz" | head -1`

total_requests=`zcat $dest_dir/$target_gz | wc -l`

echo "scale=0; $total_requests/300" | bc
