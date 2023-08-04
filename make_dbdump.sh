#!/bin/sh
date=$(date +%Y%m%d)
apppath=$(basename `dirs`)
pushd .

mysqldump hcafe2 -u root -p > ${apppath}_${date}.sql

