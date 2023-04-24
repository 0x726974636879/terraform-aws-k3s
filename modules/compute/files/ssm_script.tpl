#!/bin/bash

sleep 60
scp -i ~/.ssh/${key_pair_name} \
-o StrictHostKeyChecking=no \
-o UserKnownHostsFile=/dev/null \
${deployment_file_path} ubuntu@${instance_public_ip}:/home/ubuntu &&
aws ssm send-command --instance-ids ${instance_id} \
--document-name apply_kubernetes_deployment \
--comment "launch apply_kubernetes_deployment"