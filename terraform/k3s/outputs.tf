output "master_public_ip" {
  description = "Public IP address of the k3s master node"
  value       = aws_eip.master.public_ip
}

output "master_private_ip" {
  description = "Private IP address of the k3s master node"
  value       = aws_instance.master.private_ip
}

output "worker_public_ips" {
  description = "Public IP addresses of the k3s worker nodes"
  value       = aws_instance.worker[*].public_ip
}

output "ssh_master" {
  description = "SSH command to connect to the k3s master node"
  value       = "ssh -i ~/.ssh/key.pem ubuntu@${aws_eip.master.public_ip}"
}

output "kubectl_test" {
  description = "Command to test cluster nodes from the master"
  value       = "ssh -i ~/.ssh/key.pem ubuntu@${aws_eip.master.public_ip} 'sudo k3s kubectl get nodes'"
}

output "kubeconfig_command" {
  description = "Command to copy kubeconfig from master to local machine"
  value       = "ssh -i ~/.ssh/key.pem ubuntu@${aws_eip.master.public_ip} 'sudo cat /etc/rancher/k3s/k3s.yaml' | sed 's/127.0.0.1/${aws_eip.master.public_ip}/g' > ~/.kube/healthpulse-config"
}
