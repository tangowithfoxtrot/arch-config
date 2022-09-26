#!/usr/bin/env bash

set -e

# set arch_config_dir to the directory where arch-config is cloned
ansible localhost, -c local -m ansible.builtin.blockinfile -a \
"path=$(pwd)/imperative_deletion.sh \
marker='### {mark} ANSIBLE-MANAGED BLOCK ###' \
block='arch_config_dir=$(pwd)' insertafter='set -e'"

ansible-galaxy collection install -r requirements.yml
ansible-playbook -i localhost, -c local --become --ask-become-pass \
main.yml
