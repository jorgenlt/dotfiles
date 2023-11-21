#!/bin/bash

sudo echo ''
echo '-------------------------'
echo 'UPDATING PACKAGE INDEX'
echo '-------------------------'
echo ''
sudo apt update
echo ''
echo '-------------------------'
echo 'UPGRADING PACKAGES'
echo '-------------------------'
echo ''
sudo apt upgrade -y
echo ''
echo '-------------------------'
echo 'UPDATING SNAP PACKAGES'
echo '-------------------------'
echo ''
sudo snap refresh &&
sleep 1
echo ''
echo '-------------------------'
echo 'UPDATE COMPLETE'
echo '-------------------------'
sleep 1
