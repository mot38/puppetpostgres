#!/bin/bash
data_dir=/var/lib/pgsql/9.4/data/
recovery_conf=${data_dir}recovery.conf
export cluster_show_cmd='/usr/pgsql-9.4/bin/repmgr -f /etc/repmgr/9.4/repmgr.conf cluster show'

function master_node_name {
  $cluster_show_cmd | grep master | sed 's/^.*host=\(node[abc]\) user.*$/\1/'
}


case `hostname` in
  nodea) nodenum=1 ;;
  nodeb) nodenum=2 ;;
  nodec) nodenum=3 ;;
esac

clear

echo -e "\n\n\tShowing the current status of the cluster, with '"`master_node_name`"' as the master.\n\n"

tput cuf 10 ;  $cluster_show_cmd

sleep 5

echo -e "\n\n\tStopping the Postgres service."
systemctl stop postgresql-9.4
systemctl status postgresql-9.4
echo -e "\n\n\tThe Postgres service has stopped.\n\n"
echo -e "\n\n\tDeleting everything in the data directory.\n\n"
rm -rf ${data_dir}*

ls -l ${data_dir}*
echo -e "\n\n\tSee, it's empty!"

sleep 10
clear
echo -en "\n\n\tLet's take a backup of the 'Master' node on the 'bart' server; press any key to initiate the backup."
read x
su - postgres -c "ssh barman@bart \"barman backup primary\""
sleep 10
clear
echo -en "\n\n\tNow we'll restore from that backup on 'bart' server to `hostname`; press any key to continue with recovery process."
read x
clear
su - postgres -c "ssh barman@bart \"barman recover --remote-ssh-command 'ssh postgres@`hostname`' primary latest /var/lib/pgsql/9.4/data/\""
cat << HERE > $recovery_conf
standby_mode = 'on'
primary_conninfo = 'port=5432 host=vip user=repmgr application_name=node${nodenum}'
recovery_target_timeline = 'latest'
primary_slot_name = repmgr_slot_${nodenum}
HERE

chmod 644 ${recovery_conf}
chown postgres:postgres ${recovery_conf}
su - postgres -c "psql -h vip -U repmgr -c \"select pg_create_physical_replication_slot('repmgr_slot_${nodenum}');\""
echo -e "\n\n\tRe-starting the Postgres service"
systemctl start postgresql-9.4
echo -e "\n\n"
systemctl status postgresql-9.4
echo -e "\n\n"
$cluster_show_cmd
echo -e "\n\n\tThe restored '`hostname`' has now re-joined the cluster and is following the new Master '"`master_node_name`"'.\n\n"
