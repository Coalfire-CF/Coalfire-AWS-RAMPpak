#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

ACCOUNT_ID=$1
BU_ROLE_ARN=$2
BU_EXTERNAL_ID=$3
ORG_ROLE_ARN=$4
ORG_EXTERNAL_ID=$5

# Assume into org root account
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
$(aws sts assume-role \
--role-arn $ORG_ROLE_ARN \
--external-id $ORG_EXTERNAL_ID \
--role-session-name interlock_session \
--query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
--output text))

HANDSHAKE=$(aws organizations invite-account-to-organization \
--target '{"Type": "ACCOUNT", "Id": "'$ACCOUNT_ID'"}' \
--notes "This is a request for this account to join the Federal Ops Stack organization." \
--output text \
--query "Handshake.Id")

# Remove assume role
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

# Assume into BU account
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
$(aws sts assume-role \
--role-arn $BU_ROLE_ARN \
--external-id $BU_EXTERNAL_ID \
--role-session-name interlock_session \
--query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
--output text))

# Accept handshake in BU account
aws organizations accept-handshake --handshake-id $HANDSHAKE