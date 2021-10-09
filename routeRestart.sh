#!/bin/bash
function network() {
    local timeout=2
    local target=www.baidu.com
    # 根据网页的返回的状态码判断是否联网，追加timeout
    code=$(curl -I -s --connect-timeout ${timeout} ${target} -w %{http_code} | head -n1 | awk '{print $2}')
    # echo $code
    if [ "$code" == "200" ]; then
        return 1
    else
        return 0
    fi
    return 0
}
function routeR() {
    # 进入爱快控制台重启
    sshpass -p passwd ssh sshd@192.168.0.1 <<EOF
8
0
EOF
}
network
if [ $? -eq 0 ]; then
    echo "网络不畅通，请检查网络设置！"
    routeR
    exit -1
else
    echo "网络畅通，你可以上网冲浪！"
fi
