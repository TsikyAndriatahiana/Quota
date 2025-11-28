#!/bin/bash

#mail /home
nbr_ligne=$( wc -l /etc/passwd | awk '{print $1}')
for ((i=49;i<$nbr_ligne;i++))
do
	usr=$(awk -F ':' '($7 != "/usr/sbin/nologin") && (NR == $i) { print $1 }' /etc/passwd)
	hard_limit=$( quota -u $usr | awk 'NR==3 {print $4}')
	soft_limit=$(  quota -u $usr | awk 'NR==3 {print $3}')
	blocks_used=$( quota -u $usr | awk 'NR==3 {print $2}')
	if (( blocks_used >= soft_limit )); then
    		echo "Attention $usr a dépassé sa soft limit sur /home" | mail -s "Quota dépassé" admin@gmail.com
	fi
	if (( blocks_used == hard_limit )); then
    		echo "Attention $usr a atteint sa hard limit sur /home" | mail -s "Quota atteint" admin@gmail.com
	fi

done

#mail /data
for ((i=49;i<$nbr_ligne;i++))
do
	usr=$(awk -F ':' '($7 != "/usr/sbin/nologin") && (NR == $i) { print $1 }' /etc/passwd)
	hard_limit_inode=$( quota -u $usr | awk 'NR==3 {print $7}')
	soft_limit_inode=$(  quota -u $usr | awk 'NR==3 {print $6}')
	blocks_used_inode=$( quota -u $usr | awk 'NR==3 {print $5}')
	if (( blocks_used >= soft_limit )); then
    		echo "Attention $usr a dépassé sa soft limit d'inode sur /data" | mail -s "Quota dépassé" admin@gmail.com
	fi
	if (( blocks_used == hard_limit )); then
    		echo "Attention $usr a atteint sa hard limit d'jnode sur /data" | mail -s "Quota atteint" admin@gmail.com
	fi

done

# verifier si la motif "quota_check "n'existe pas
if ! crontab -l 2>/dev/null | grep -q "quota_check.sh"; then
    echo "Ajout de la tâche cron hebdomadaire..."
    (crontab -l 2>/dev/null; echo "0 8 * * 1 ~/quota_check.sh") | crontab -
fi

