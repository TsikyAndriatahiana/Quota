#!/bin/bash
#home


sed -i "\|home|s/defaults /defaults,urquota,grpquota/" /etc/fstab
sudo systemctl daemon-reload
sudo mount -o remount /home 
sudo quotacheck -cug /home 
sudo quotaon -ug /home	

nbr_ligne= $(wc -l /etc/passwd | awk '{print $1}')
for ((i=1;i<$nbr_ligne;i++))
do
	usr=$(awk -F ':' '($3>=1000) && ($3<=60000) && (NR == 12) && ($1!="nobody") { print $1 }' /etc/passwd)
	
	 if [ -n "$usr" ]
        then
		sudo setquota -u $usr 400M 500M 0 0 /home
	fi
done


nbr_ligne= $(wc -l /etc/group | awk '{print $1}')
for ((i=1;i<$nbr_ligne;i++))
do
	grp=$(awk -F ':' 'NR==$i && $3>=1000 && $1!="nobody" && $1!="nogroup" { print $1 }' /etc/group)
  if [ -n "$grp" ]
  then
	sudo setquota -g $grp 400M 500M 0 0 /home 
  fi
done


# /data
echo "/dev/loop33   /data   ext4    loop,defaults,usrquota,grpquota    0 0" >> /etc/fstab
sudo systemctl daemon-reload
sudo mount -o remount /data 
sudo quotacheck -cug /data 
sudo quotaon -ug /data	

nbr_ligne= wc -l /etc/passwd | awk '{print $1}'
for ((i=1;i<$nbr_ligne;i++))
do
	usr=$(awk -F ':' '($3>=1000) && ($3<=60000) && (NR == 12) && ($1!="nobody") { print $1 }' /etc/passwd)
	
	 if [ -n "$usr" ]
        then
		sudo setquota -u $usr 400M 500M 400 500 /data
	fi
done


nbr_ligne= $(wc -l /etc/group | awk '{print $1}')
for ((i=1;i<$nbr_ligne;i++))
do
	grp=$(awk -F ':' 'NR==$i && $3>=1000 && $1!="nobody" && $1!="nogroup" { print $1 }' /etc/group)
  if [ -n "$grp" ]
  then
	sudo setquota -g $grp 400M 500M 400 500 /data 
  fi
done

