#!/bin/bash

service=elasticsearch-es-01
initd=/etc/init.d
[[ -x $initd/$service ]] || service=elasticsearch
sudo systemctl unmask $service

systemctl restart $service
