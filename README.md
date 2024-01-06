# ansible-gentoo

Currently sudo is required, so run with great care. #TODO find a way to not invoke sudo to run ansible

```
sudo ansible-playbook main.yml -i hosts --tags "qemu"
```

## Creating roles

```
ansible-galaxy init my_role
```

## References

https://docs.ansible.com/ansible/latest/collections/community/general/chroot_connection.html