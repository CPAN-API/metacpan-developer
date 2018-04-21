#!/bin/bash

service=elasticsearch-es-01
[[ -e /etc/default/$service ]] || service=elasticsearch

sudo systemctl restart $service
