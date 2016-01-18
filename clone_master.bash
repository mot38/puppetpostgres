#!/bin/bash
data_dir=/var/lib/pgsql/9.4/data/
recovery_conf=${data_dir}recovery.conf
cluster_show_cmd="su - postgres -c \"ssh vip1  \\\"/usr/pgsql-9.4/bin/repmgr -f /etc/repmgr/9.4/repmgr.conf cluster show\\\"\""

function master_node_name {
  eval "${cluster_show_cmd}" | grep master | sed 's/^.*host=\(node[abc]1\) user.*$/\1/'
}


case `hostname` in
  nodea1) nodenum=1 ;;
  nodeb1) nodenum=2 ;;
  nodec1) nodenum=3 ;;
  noded1) nodenum=4 ;;
esac

clear

echo -e "\n\n\tShowing the current status of the cluster, with '"`master_node_name`"' as the master.\n\n"

eval "${cluster_show_cmd}"

sleep 5

echo -e "\n\n\tStopping the Postgres service."
su - postgres -c "/usr/pgsql-9.4/bin/pg_ctl stop -m immediate"
su - postgres -c "/usr/pgsql-9.4/bin/pg_ctl status"
echo -e "\n\n\tThe Postgres service has stopped.\n\n"
echo -e "\n\n\tDeleting everything in the data directory.\n\n"
rm -rf ${data_dir}*

ls -la ${data_dir}*
echo -e "\n\n\tSee, it's empty!"

sleep 5
clear
echo -en "\n\n\tNow let's add an object on the new master, then clone it to this server; press any key to initiate the clone procedure."
read x

su - postgres -c "/usr/pgsql-9.4/bin/repmgr -D ${data_dir} -f /etc/repmgr/9.4/repmgr.conf --force --rsync-only -h vip1 -d repmgr -U repmgr --verbose standby clone"

sleep 5
echo -e "\n\n\tRetarting the Postgres service"
su - postgres -c "/usr/pgsql-9.4/bin/pg_ctl start"
sleep 5
echo -e "\n\n\tReregistering the node with repmgr"
su - postgres -c "/usr/pgsql-9.4/bin/repmgr -f /etc/repmgr/9.4/repmgr.conf --force standby register"
sleep 5
echo -e "\n\n\tRetarting the repmgr service"
systemctl start repmgr

echo -e "\n\n\tShowing the status of the repmgr service"
systemctl status repmgr
echo -e "\n\n"
su - postgres -c "/usr/pgsql-9.4/bin/pg_ctl status"
echo -e "\n\n"
sleep 5
eval "${cluster_show_cmd}"
echo -e "\n\n\tThe cloned '`hostname`' has now re-joined the cluster and is following the new Master '"`master_node_name`"'.\n\n"
