#!/bin/bash
function Mode_change {
    name=$1
    gdbinitfile=~/.gdbinit    #这个路径按照你的实际情况修改
    # gdbinitfile=/root/Desktop/mode
 
    peda="source /root/peda/peda.py"   #这个路径按照你的实际情况修改
    gef="source /root/.gdbinit-gef.py"   #这个路径按照你的实际情况修改
    pwndbg="source /pwndbg/gdbinit.py"   #这个路径按照你的实际情况修改
 
    sign=$(cat $gdbinitfile | grep -n "#this place is controled by user's shell")    
    #这是一个定位flag，此处上面的查找内容要和你自己的保持一致
 
    pattern=":#this place is controled by user's shell"
    number=${sign%$pattern}
    location=$[number+2]
 
    parameter_add=${location}i
    parameter_del=${location}d
 
    message="TEST"
 
    if [ $name -eq "1" ];then
        sed -i "$parameter_del" $gdbinitfile
        sed -i "$parameter_add $peda" $gdbinitfile
        echo -e "Please enjoy the peda!\n"
    elif [ $name -eq "2" ];then
        sed -i "$parameter_del" $gdbinitfile
        sed -i "$parameter_add $gef" $gdbinitfile
        echo -e "Please enjoy the gef!\n"
    else
        sed -i "$parameter_del" $gdbinitfile
        sed -i "$parameter_add $pwndbg" $gdbinitfile
        echo -e "Please enjoy the pwndbg!\n"
    fi
}
 
echo -e "Please choose one mode of GDB?\n1.peda    2.gef    3.pwndbg"
 
read -p "Input your choice:" num
 
if [ $num -eq "1" ];then
    Mode_change $num
elif [ $num -eq "2" ];then
    Mode_change $num
elif [ $num -eq "3" ];then
    Mode_change $num
else
    echo -e "Error!\nPleasse input right number!"
fi
 
gdb $1 $2 $3 $4 $5 $6 $7 $8 $9
