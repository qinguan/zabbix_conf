#!/usr/bin/env bash
# vim:fileencoding=UTF-8

# FileName: get_nginx_api_status.sh 
# Created: 1月 5, 2017
# Author(s): Xu Guojun 

# 要求tengine配置如下状态顺序收集
# 支持获取 req_total http_2xx http_3xx http_4xx http_5xx 
# http_403 http_404 http_499 http_500 http_502 http_503 http_504

HTTP_STAT=$1
#echo $HTTP_STAT
KV=`ifconfig | grep Mask | grep -v 127.0.0.1 | cut -f2 -d':' | cut -f1 -d' ' | head -1`:80,
#echo $KV
NGINX_API_STAT=`curl -s "http://127.0.0.1:8090/traffic_status" | grep $KV`
#echo $API_STAT
ERROR_WRONG_PARAM="-0.99"

case $HTTP_STAT in
  req_total)  echo "$NGINX_API_STAT" | cut -f2 -d',' ;;
  http_2xx)   echo "$NGINX_API_STAT" | cut -f3 -d',' ;;
  http_3xx)   echo "$NGINX_API_STAT" | cut -f4 -d',' ;;
  http_4xx)   echo "$NGINX_API_STAT" | cut -f5 -d',' ;;
  http_5xx)   echo "$NGINX_API_STAT" | cut -f6 -d',' ;;
  http_403)   echo "$NGINX_API_STAT" | cut -f7 -d',';;
  http_404)   echo "$NGINX_API_STAT" | cut -f8 -d',';;
  http_499)   echo "$NGINX_API_STAT" | cut -f9 -d',';;
  http_500)   echo "$NGINX_API_STAT" | cut -f10 -d',';;
  http_502)   echo "$NGINX_API_STAT" | cut -f11 -d',';;
  http_503)   echo "$NGINX_API_STAT" | cut -f12 -d',';;
  http_504)   echo "$NGINX_API_STAT" | cut -f13 -d',';;
  *) echo $ERROR_WRONG_PARAM; exit 1;;
esac

exit 0
