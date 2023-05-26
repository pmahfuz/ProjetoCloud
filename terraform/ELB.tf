resource "aws_elb" "web_elb" {
  name = "web-elb"  # The name of the Elastic Load Balancer (ELB)

  security_groups = [
    aws_security_group.ec2_security_group.id
  ]  # The security group(s) associated with the ELB
  
  subnets = [
    aws_default_subnet.default_az1.id,
    aws_default_subnet.second_az1.id
  ]  # The subnets where the ELB will be deployed
  
  cross_zone_load_balancing = true  # Enable cross-zone load balancing
  
  health_check {
    healthy_threshold = 2  # Number of consecutive successful health checks for an instance to be considered healthy
    unhealthy_threshold = 2  # Number of consecutive failed health checks for an instance to be considered unhealthy
    timeout = 3  # Number of seconds before considering a health check request as timed out
    interval = 30  # Interval between health checks in seconds
    target = "HTTP:80/"  # The target for the health checks (HTTP on port 80)
  }  # Configuration for health checks
  
  listener {
    lb_port = 80  # The load balancer's port to listen on
    lb_protocol = "http"  # The protocol for the load balancer (HTTP)
    instance_port = "80"  # The port on the instances to forward traffic to
    instance_protocol = "http"  # The protocol for communication with the instances (HTTP)
  }  # Configuration for the load balancer's listener
}