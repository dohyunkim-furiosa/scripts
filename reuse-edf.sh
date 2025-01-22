#!/bin/bash
set -xe

if [ -z "$1" ]; then
    echo "Error: arg1(OLD_LONG_HASH) is required."
    echo "Usage: $0 <arg1>"
    exit 1
fi

OLD_LONG_HASH=$(git rev-parse $1)
NEW_LONG_HASH=$(git rev-parse HEAD)

OLD_HASH=$(echo $OLD_LONG_HASH | cut -c 1-10)
NEW_HASH=$(echo $NEW_LONG_HASH | cut -c 1-10)

aws s3 sync \
s3://furiosa-jenkins/rngd-ci/edf/$OLD_HASH \
s3://furiosa-jenkins/rngd-ci/edf/$NEW_HASH

aws s3 sync \
s3://furiosa-jenkins/rngd-ci/config/$OLD_HASH \
s3://furiosa-jenkins/rngd-ci/config/$NEW_HASH

aws s3 sync \
s3://furiosa-jenkins/snapshots/$OLD_HASH \
s3://furiosa-jenkins/snapshots/$NEW_HASH

# aws s3 cp \
# 	s3://furiosa-jenkins/artifacts/$OLD_HASH/bin/npu_runtime_test \
# 	s3://furiosa-jenkins/artifacts/$NEW_HASH/bin/npu_runtime_test