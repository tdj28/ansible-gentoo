#!/bin/bash

# Define the output files
PACKAGE_LIST="/tmp/gentoo_packages.txt"
ANSIBLE_PLAYBOOK="gentoo-packages.yml"

# Generate the list of additional packages
comm -23 <(qlist -I | sort) <(qlist -I @system | sort) > "$PACKAGE_LIST"

# Create the Ansible playbook
echo "---" > "$ANSIBLE_PLAYBOOK"
echo "- name: Install packages on Gentoo" >> "$ANSIBLE_PLAYBOOK"
echo "  hosts: gentoo" >> "$ANSIBLE_PLAYBOOK"
echo "  become: yes" >> "$ANSIBLE_PLAYBOOK"
echo "  vars:" >> "$ANSIBLE_PLAYBOOK"
echo "    install_graphical: false" >> "$ANSIBLE_PLAYBOOK"
echo "  tasks:" >> "$ANSIBLE_PLAYBOOK"

# Non-graphical packages task
echo "    - name: Install non-graphical packages" >> "$ANSIBLE_PLAYBOOK"
echo "      command: emerge --ask=n {{ item }}" >> "$ANSIBLE_PLAYBOOK"
echo "      loop:" >> "$ANSIBLE_PLAYBOOK"

# Add non-graphical packages to the playbook
while read -r package; do
    if [[ ! $package == gnome* && ! $package == x11-* && ! $package == *cuda* ]]; then
        echo "        - $package" >> "$ANSIBLE_PLAYBOOK"
    fi
done < "$PACKAGE_LIST"

# Graphical packages task
echo "    - name: Install graphical packages" >> "$ANSIBLE_PLAYBOOK"
echo "      command: emerge --ask=n {{ item }}" >> "$ANSIBLE_PLAYBOOK"
echo "      loop:" >> "$ANSIBLE_PLAYBOOK"
echo "      when: install_graphical" >> "$ANSIBLE_PLAYBOOK"

# Add graphical packages to the playbook
while read -r package; do
    if [[ $package == gnome* || $package == x11-* || $package == *cuda* ]]; then
        echo "        - $package" >> "$ANSIBLE_PLAYBOOK"
    fi
done < "$PACKAGE_LIST"

echo "Playbook created: $ANSIBLE_PLAYBOOK"

