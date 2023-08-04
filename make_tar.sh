#!/bin/sh
date=$(date +%Y%m%d)
pushd .
cd ..
tar zcvf hcafe2_2_${date}.tgz \
    --exclude=hcafe2_2/public/uploads \
    --exclude=hcafe2_2/log/* \
    --exclude=hcafe2_2/vendor/* \
    --exclude=hcafe2_2/node_modules/* \
    --exclude=hcafe2_2/tmp/* \
    hcafe2_2/*
popd 

