#!/bin/bash

# Install dependencies
apt-get update && apt-get install -y gcc curl vim

## Install test_packs
ln -fns /opt/stackstorm/packs.dev /opt/stackstorm/packs/test_packs

# Reload to recognize test_packs
st2ctl reload

## Load snpseq_packs packs
st2 run packs.load packs=snpseq_packs register=all

## Make virtualenv for snpseq_packs
st2 run packs.setup_virtualenv packs=test_packs

