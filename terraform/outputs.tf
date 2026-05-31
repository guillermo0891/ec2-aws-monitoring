output "promgraf_public_ip" {
  value = aws_instance.promgraf.public_ip
}

output "promgraf_private_ip" {
  value = aws_instance.promgraf.private_ip
}

output "targets_public_ips" {
  value = aws_instance.targets[*].public_ip
}

output "targets_private_ips" {
  value = aws_instance.targets[*].private_ip
}

output "promgraf_instance_id" {
  value = aws_instance.promgraf.id
}