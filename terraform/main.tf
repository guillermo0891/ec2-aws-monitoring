resource "aws_instance" "targets" {
  count         = var.target_count
  ami           = data.aws_ami.amzn2023.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.monitor_sg.id]
  tags = {
    Name = "monitor-target-${count.index}"
    Role = "monitor-target"
  }
}

resource "aws_instance" "promgraf" {
  ami           = data.aws_ami.amzn2023.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.monitor_sg.id]
  tags = {
    Name = "prom-graf"
    Role = "promgraf"
  }
}