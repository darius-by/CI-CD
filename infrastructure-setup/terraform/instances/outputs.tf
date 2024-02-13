output "ci_cd_instance_id" {
  value = aws_instance.ci_cd.id
}

output "docker_instance_id" {
  value = aws_instance.docker.id
}

output "monitor_instance_id" {
  value = aws_instance.monitor.id
}

output "ci_cd_eip" {
  value = aws_eip.ci_cd_eip.public_ip
}

output "docker_eip" {
  value = aws_eip.docker_eip.public_ip
}

output "monitor_eip" {
  value = aws_eip.monitor_eip.public_ip
}

