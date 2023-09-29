# Ansible

## Installing Ansible

To install Ansible with *pipx*:

    pipx install yamllint
    pipx install ansible-core
    pipx install ansible-builder
    pipx inject --include-apps ansible-core ansible-lint
    pipx inject --include-apps ansible-core molecule
    pipx inject ansible-core 'molecule-plugins'

Use Ansible Galaxy to install the required add-ons:

    ansible-galaxy install -r requirements.yml

## Using Ansible

Ensure that you set AWS credentials for your shell session. Then use the *-i* option to specify the inventory file:

    ansible-inventory -i ./inventory/default/aws_ec2.yml --graph
    ansible-playbook -i ./inventory/default/aws_ec2.yml ./example/playbooks/aws_ec2_test.yml

## Ansible Builder

[Ansible Builder](https://ansible-builder.readthedocs.io/en/latest/) creates Execution Environments.

## Ansible Runner

```shell
ansible-runner run -p self_test.yml --project-dir ./data/project ./data
```
