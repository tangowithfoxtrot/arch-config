#!/usr/bin/env bash

set -e

ansible-galaxy collection install -r requirements.yml
ansible-playbook -i localhost, -c local --become --ask-become-pass main.yml
