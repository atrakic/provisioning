#!/bin/bash
eval `ssh-agent -s`
ssh-add $HOME/.ssh/id_rsa
ssh-add -l
