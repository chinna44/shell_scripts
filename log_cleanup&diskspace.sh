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

















