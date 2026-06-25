#!/bin/bash

# Install dependencies
apt-get update && apt-get install -y gcc curl vim

## Install snpseq-packs
ln -fns /opt/stackstorm/packs.dev /opt/stackstorm/packs/snpseq_packs

## Copy dummy genologics config to home of root user (required for unit tests)
cp /opt/stackstorm/packs/snpseq_packs/utils/.genologicsrc /root/

# Reload to recognize snpseq_packs
st2ctl reload

## Load snpseq_packs packs
st2 run packs.load packs=snpseq_packs register=all

## Make virtualenv for snpseq_packs
st2 run packs.setup_virtualenv packs=snpseq_packs

# Create symlink to dummy pack config
ln -fs /opt/stackstorm/packs.dev/snpseq_packs.yaml /opt/stackstorm/configs/snpseq_packs.yaml

## Make sure config is loaded
st2ctl reload --register-configs

## Make sure rules are disabled
/opt/stackstorm/packs/snpseq_packs/scripts/rule_switch disable

# create the known_hosts file and add the snpseq-tester host key
ssh-keyscan -t ecdsa snpseq-tester >> /home/stanley/.ssh/known_hosts
chown -R stanley:stanley /home/stanley/.ssh

# Make git trust the repo
git config --global --add safe.directory /opt/stackstorm/packs.dev

# Create version file based on latest commit
cd /opt/stackstorm/packs/snpseq_packs && git log -1 --pretty=format:"%H" > version.txt
