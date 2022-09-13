#!/bin/bash
fs_tocheck="/home /apps /apps/opt/hnm /apps/opt/hnm/logs /apps/opt/ASF-Apache /tmp /var"

fs_threshold="80"

function send_alert {
  mail_to="email_id1,email_id2"
  mail1_to="email_id1,email_id2"
  mail_body="Please cleanup space to get under 80 on hostname"
  echo "$mail_body" | mailx -s "$1" "$mail_to"
  print "alert sent"
  
}

time_stamp=$(date);
print $time_stamp

print "Checking the following file systems: $fs_tocheck"

for i in $fs_tocheck ; do
  df -k | grep $i | awk '{print $5}' | sed 's/\%//g' | read fs_current_size
  
  if [[ $fs_check_size -gt $fs_threshold ]] ; then
    
      print "$i, is over threshold ($fs_current_size %)"
      send_alert "CRITICAL: $i is at $fs_current_size% (over the threshold). Please check"
      
   else
      print "$i is ok currently at $fs_current_size %"
   fi
done
============================================================================================================================
#ziplog.sh
#!/bin/bash
set -x
FS=$(df -h /apps/opt/hnm | awk '{print $5}' | grep [0-9] | tr -d '\%')
if [ $FS -gt 80 ];
then
    log_files=$(ls /apps/opt/hnm/logs/*.log)
    for logs in $log_files
      do
         tar -czvf $logs.tar.gz $logs
         if [ $? -eq 0 ];
         then
             log_files=$(ls /apps/opt/hnm/logs/*.log)
             for logs in $log_flies
                do
                   >$logs
                done
         fi
      done
fi
=======================================================================================================================
##clean up log files
echo "log cleanup going to remove these files" > /tmp/log_cleanup.out

echo " " >> /tmp/log_cleanup.txt
echo " " >> /tmp/log_cleanup.txt
echo "cleaning up /apps/opt/hnm/log/web_vsm/BACKUP" >> /tmp/log_cleanup.txt
for i in `find /apps/opt/hnm/log/web_vsm/BACKUP -mtime +2`
do
ls -ltr $i >> /tmp/log_cleanup.txt
rm -f $i >> /tmp/log_cleanup.txt
done

echo " " >> /tmp/log_cleanup.txt
echo " " >> /tmp/log_cleanup.txt
echo "switching to /apps/opt/hnm/logs dir" >> /tmp/log_cleanup.txt
echo " " > /tmp/remove.out
for i in `find /apps/opt/hnm/logs -mtime +1`
do
if echo "$i" | grep log_file_name && `find $i -mtime +5`; then
       ls -ltr $i >> /tmp/remove.out
       continue;
fi
rm -rf $i >> /tmp/log_cleanup.txt
done






         
         















