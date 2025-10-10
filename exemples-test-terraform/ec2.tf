# # Variable pour l'AMI ID
# variable "ami_id" {
#   type        = string
#   description = "ID de l'AMI pour l'instance EC2"

#   # Validation pour vérifier que l'AMI ID est valide
#   validation {
#     condition     = can(regex("^ami-[0-9a-f]{8,17}$", var.ami_id))
#     error_message = "L'AMI ID doit commencer par 'ami-' et être suivi de 8 à 17 caractères hexadécimaux."
#   }
# }

# # Variable pour le type d'instance
# variable "instance_type" {
#   type        = string
#   description = "Type d'instance EC2"
#   default     = "t2.micro"

#   # Validation pour vérifier que le type d'instance est valide
#   validation {
#     condition     = contains(["t2.micro", "t2.small", "t2.medium"], var.instance_type)
#     error_message = "Le type d'instance doit être l'un des suivants : t2.micro, t2.small, t2.medium."
#   }
# }

# # Variable pour la région AWS
# variable "aws_region" {
#   type        = string
#   description = "Région AWS pour l'instance EC2"
#   default     = "us-east-1"

#   # Validation pour vérifier que la région est valide
#   validation {
#     condition     = contains(["us-east-1", "us-west-2", "eu-west-1"], var.aws_region)
#     error_message = "La région AWS doit être l'une des suivantes : us-east-1, us-west-2, eu-west-1."
#   }
# }

# # Data source pour récupérer la région AWS actuelle
# data "aws_region" "current" {}

# # Création de l'instance EC2
# resource "aws_instance" "example" {
#   ami           = var.ami_id
#   instance_type = var.instance_type

#   tags = {
#     Name = "example-instance"
#   }

#   # Postcondition pour vérifier que l'instance a été créée avec succès
#   lifecycle {
#     precondition {
#       condition     = data.aws_region.current.name == var.aws_region
#       error_message = "La région AWS actuelle ne correspond pas à la région spécifiée. Veuillez exécuter Terraform dans la région ${var.aws_region}."
#     }

#     postcondition {
#       condition     = self.public_ip != ""
#       error_message = "L'instance EC2 n'a pas reçu d'adresse IP publique."
#     }
#   }
# }

# # Output pour l'adresse IP publique de l'instance EC2
# output "public_ip" {
#   value = aws_instance.example.public_ip

#   # Precondition pour vérifier que l'adresse IP publique est valide
#   precondition {
#     condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", aws_instance.example.public_ip))
#     error_message = "L'adresse IP publique de l'instance EC2 n'est pas valide."
#   }
# }

# # Check pour vérifier que l'instance EC2 est accessible via SSH
# check "ec2_health_check" {
#   data "aws_instance" "example_check" {
#     instance_id = aws_instance.example.id
#   }

#   assert {
#     condition     = data.aws_instance.example_check.public_ip != ""
#     error_message = "L'instance EC2 ${aws_instance.example.id} n'est pas accessible ou n'a pas d'adresse IP publique."
#   }
# }

# # Provisioner pour vérifier l'accès à l'instance EC2 via SSH
# resource "null_resource" "ec2_access_check" {
#   provisioner "local-exec" {
#     command = "ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa ec2-user@${aws_instance.example.public_ip} 'echo Instance is accessible' || echo 'L'instance EC2 ${aws_instance.example.public_ip} n'est pas accessible via SSH'"
#   }

#   depends_on = [aws_instance.example]
# }
