#!/bin/sh
# https://github.com/mislav/git-deploy 

git remote add production2 root@www.hanryumoa.net:/var/www/rails/hcafe2_2
git deploy setup -r "production2"
git deploy init


