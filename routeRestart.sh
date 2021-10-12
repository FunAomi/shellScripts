#!/bin/bash
function network() {
    local timeout=2
    local target=www.baidu.com
    local try_time=5
    local i=1
    # 成功次数
    local suc=0
    # 尝试5次访问
    while [ $i -le $try_time ]; do
        # 根据网页的返回的状态码判断是否联网，追加timeout
        code=$(curl -I -s --connect-timeout ${timeout} ${target} -w %{http_code} | head -n1 | awk '{print $2}')
        let i++
        if [ "$code" == "200" ]; then
            let suc++
        else
            echo -e "Code：$code\n"$(date) >>./code_log
        fi
    done
    return $suc
}
function routeR() {
    # 进入爱快控制台重启
    sshpass -p passwd ssh sshd@192.168.0.1 <<EOF
8
0
EOF
}
network
if [ $? -le 2 ]; then
    echo -e "网络不畅通,当前时间为：\n"$(date) >>./fail_log
    routeR
    exit -1
else
    echo -e "网络畅通,当前时间为：\n"$(date) >>./suc_log
fi
