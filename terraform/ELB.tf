resource "aws_elb" "web_elb" {
  name = "web-elb"  # Name of the load balancer
  security_groups = [
    aws_security_group.ec2_security_group.id  # Security group ID(s) associated with the load balancer
  ]
  subnets = [
    aws_subnet.public_subnet.id  # Subnet ID(s) where the load balancer should be created
  ]
  instances = [
    aws_instance.ec2_instance[0].id,  # Instance ID(s) to be registered with the load balancer
    aws_instance.ec2_instance[1].id
  ]
  cross_zone_load_balancing   = true

  # Health check configuration
  health_check {
    healthy_threshold   = 2  # Number of consecutive successful health checks required to consider an instance healthy
    unhealthy_threshold = 2  # Number of consecutive failed health checks required to consider an instance unhealthy
    timeout             = 3  # Timeout value for each health check request
    interval            = 30  # Interval between health checks
    target              = "HTTP:80/"  # Target for the health check (in this case, HTTP on port 80)
  }

  # Listener configuration
  listener {
    lb_port           = 80  # Port on the load balancer to listen on
    lb_protocol       = "http"  # Protocol to use for the load balancer listener
    instance_port     = 80  # Port on the instances to forward traffic to
    instance_protocol = "http"  # Protocol to use for communicating with the instances
  }
}