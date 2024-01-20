provider "aws" {
  region     = var.region
}

# terraform {
#   required_providers {
#     github = {
#       source = "integrations/github"
#       version = "6.0.0-alpha"
#     }
#   }
# }

# provider "github" {
#   token = "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"
# }

# resource "github_repository" "example" {
#   name        = "example"
#   description = "My awesome codebase..."

#   visibility = "public"
# }

# resource "github_branch" "development" {
#   repository = "example"
#   branch     = "development"
# }

# resource "aws_instance" "myinstance" {
#   ami           = "ami-0230bd60aa48260c6"
#   instance_type = "t2.micro"
#   tags = {
#     "Name" = "My-Instance"
#   }
# }

# resource "aws_db_parameter_group" "default" {
#   name   = "rds-pg"
#   family = "mysql8.0"

#   parameter {
#     name  = "character_set_server"
#     value = "utf8"
#   }

#   parameter {
#     name  = "character_set_client"
#     value = "utf8"
#   }
# }

# resource "aws_db_instance" "default" {
#   allocated_storage    = 10
#   db_name              = "mydb"
#   engine               = "mysql"
#   engine_version       = "8.0.35"
#   instance_class       = "db.t3.micro"
#   username             = "foo"
#   password             = "foobarbaz"
#   parameter_group_name = aws_db_parameter_group.default.name
#   skip_final_snapshot  = true
# }
