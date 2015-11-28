#################################################################################################################################
#!/bin/bash
DISKNAME=`ls -l /dev/disk/by-uuid/ | grep "d90785f1-8769-450e-82b8-de9aaf3edbc9" | mawk '{ print $(NF) }' | sed s_\.\.\/\.\.\/__`
let a=0
#check 100 times with 0.1s gaps,
#and go on adding
for i in `seq 0 100`
do
let a=`cat /proc/diskstats | grep $DISKNAME | mawk '{ print $(NF-2) }'`+a
sleep 0.1s
done
echo $a
if [ $a == 0 ]
then
echo "No Activity"
#sdparm -C stop /dev/$DISKNAME
#try the sg_start --pc=3 /dev/$DISKNAME (have to remove # from end of diskname
else
echo "Disk Active"
fi
exit 0
#################################################################################################################################
