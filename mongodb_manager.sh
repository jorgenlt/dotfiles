#!/bin/bash

function mongo_status() {
  sudo systemctl status mongod
}

function mongo_start() {  
  sudo systemctl start mongod
}

function mongo_stop() {
  sudo systemctl stop mongod 
}

function mongo_restart() {
  sudo systemctl restart mongod
} 

function mongo_logs() {
  sudo journalctl -u mongod --since="1 hour ago"
}

function mongo_enable() {
  sudo systemctl enable mongod
}

function mongo_disable() {
  sudo systemctl disable mongod  
}

function mongo_create_admin_user() {
  # Steps to create admin user 
  mongo --eval "db.createUser({user:'admin', pwd:'password123', roles:[{role:'root', db:'admin'}]})"
}

function mongo_enable_auth() {
  # Steps to enable authorization
  sudo sed -i 's/^  authorization: disabled/  authorization: enabled/' /etc/mongod.conf
  mongo_restart
}