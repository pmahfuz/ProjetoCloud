resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [
    aws_security_group.ec2_security_group.id
  ]
  subnets = [
    aws_default_subnet.default_az1.id,
    aws_default_subnet.second_az1.id
  ]
  cross_zone_load_balancing   = true
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}