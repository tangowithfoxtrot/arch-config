#!/usr/bin/env bash

### BEGIN ANSIBLE-MANAGED BLOCK ###
### END ANSIBLE-MANAGED BLOCK ###

declarative_packages=$(yq '.[] | select(.)' $arch_config_dir/vars/packages.yml | sed '/^\s*[@#]/ d' | sed 's/- //g' | sort)
imperative_packages=$(cat /etc/pkglist.yml /etc/pkglist_aur.yml | sed 's/  - //g' | sort)

# get just the difference of declarative_packages - imperative_packages
remove_packages=$(diff -w --unchanged-line-format= --old-line-format= --new-line-format='%L' \
    <(echo "$declarative_packages" | sed 's/ /\n/g') <(echo "$imperative_packages"))

main() {
    if [[ -n "$remove_packages" ]]; then
        echo "$(date)" 2>&1 | tee -a /var/log/imperative_deletion.log
        echo "Removing the following packages:" 2>&1 | tee -a /var/log/imperative_deletion.log
        echo "$remove_packages" 2>&1 | tee -a /var/log/imperative_deletion.log
        pacman -Rns --noconfirm $remove_packages 2>&1 | tee -a /var/log/imperative_deletion.log && \
        return 0
    fi
}

main "$@"