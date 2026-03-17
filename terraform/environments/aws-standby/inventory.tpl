all:
  children:
    aws_standby:
      hosts:
        k3s_node:
          ansible_host: ${ec2_ip}
          ansible_user: ubuntu
          ansible_ssh_private_key_file: ${pem_file}
          ansible_ssh_common_args: '-o StrictHostKeyChecking=no'