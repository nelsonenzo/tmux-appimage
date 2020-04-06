#!/bin/bash
# arch_ip = ssh arch@75.101.221.166
# debian_ip = ssh admin@18.215.146.13
# redhat_ip = ssh ec2-user@3.91.243.203
# suse_ip = ssh ec2-user@18.234.66.165
# ubuntu_ip = ssh ubuntu@3.80.89.184
hosts='arch@54.173.139.1
admin@3.88.87.25
ec2-user@54.221.128.205
ec2-user@18.212.255.220
ubuntu@18.234.82.136'

for i in $hosts; do
  echo $i
  # ssh $i 'sudo -u root tmux ls; ls /touch-passed-true;'
  ssh -o StrictHostKeyChecking=no $i 'cat /touch-passed-true && cat /session-passed-true'
done
