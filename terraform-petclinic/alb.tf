# ALB for PetClinic

# Create ALB target group
resource "aws_lb_target_group" "alb_tg" {
    name     = "ch10-jack-tg"
    port     = 8080
    protocol = "HTTP"
    vpc_id   = var.vpc_id
}


# Attachment of LB target group for first instance
resource "aws_lb_target_group_attachment" "alb-target-attachement-1" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.jack-petclinic.id
  port             = 8080
}

# Attachment of LB target group for second instance
resource "aws_lb_target_group_attachment" "alb-target-attachement-2" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.jack-petclinic-lb.id
  port             = 8080
}


# Create ALB
resource "aws_lb" "jack-alb" {
  name               = "ch10-petclinic-alb-listener"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.jack-sg-allow-web.id]
  subnets            = [aws_subnet.jack-subnet-public.id,aws_subnet.jack-subnet-public-2.id]

  enable_deletion_protection = false

  #access_logs {
  #  bucket  = aws_s3_bucket.lb_logs.bucket
  #  prefix  = "test-lb"
  #  enabled = true
  #}

  tags = {
    Name = "<tagname>"
  }
}

# Create ALB Listener

resource "aws_lb_listener" "jack-alb-listener" {
  load_balancer_arn = aws_lb.jack-alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
  
}