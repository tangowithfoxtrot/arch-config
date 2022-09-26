#!/usr/bin/env bash

set -e
### BEGIN ANSIBLE-MANAGED BLOCK ###
### END ANSIBLE-MANAGED BLOCK ###

declarative_packages=$(yq '.[] | select(.)' $arch_config_dir/vars/packages.yml | sed '/^\s*[@#]/ d' | sed 's/- //g' | sort)
imperative_packages=$(cat /etc/pkglist.yml /etc/pkglist_aur.yml | sed 's/  - //g' | sort)

# get just the difference of declarative_packages - imperative_packages
remove_packages=$(diff -w --unchanged-line-format= --old-line-format= --new-line-format='%L' \
    <(echo "$declarative_packages" | sed 's/ /\n/g') <(echo "$imperative_packages"))

# remove imperative packages that are not in declarative packages
if [[ -n "$remove_packages" ]]; then
    echo "$(date)" >> /var/log/imperative_deletion.log
    echo "Removing packages:" >> /var/log/imperative_deletion.log
    echo "$remove_packages" >> /var/log/imperative_deletion.log
    pacman -Rns --noconfirm $remove_packages &>> /var/log/imperative_deletion.log
fi
