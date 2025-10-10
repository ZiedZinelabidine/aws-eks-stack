# # Variable pour le nom du bucket S3
# variable "bucket_name" {
#   type        = string
#   description = "Nom du bucket S3"

#   # Validation pour vérifier que le nom du bucket est valide
#   validation {
#     condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
#     error_message = "Le nom du bucket doit contenir uniquement des lettres minuscules, des chiffres, des points et des tirets, et avoir une longueur comprise entre 3 et 63 caractères."
#   }
# }

# # Variable pour la région AWS
# variable "aws_region" {
#   type        = string
#   description = "Région AWS pour le bucket S3"
#   default     = "us-east-1"

#   # Validation pour vérifier que la région est valide
#   validation {
#     condition     = contains(["us-east-1", "us-west-2", "eu-west-1"], var.aws_region)
#     error_message = "La région AWS doit être l'une des suivantes : us-east-1, us-west-2, eu-west-1."
#   }
# }

# # Data source pour récupérer la région AWS actuelle
# data "aws_region" "current" {}

# # Création du bucket S3
# resource "aws_s3_bucket" "example" {
#   bucket = var.bucket_name
#   region = var.aws_region

#   # Postcondition pour vérifier que le bucket a été créé avec succès
#   lifecycle {
#     precondition {
#       condition     = data.aws_region.current.name == var.aws_region
#       error_message = "La région AWS actuelle ne correspond pas à la région spécifiée. Veuillez exécuter Terraform dans la région ${var.aws_region}."
#     }

#     postcondition {
#       condition     = self.arn != ""
#       error_message = "Le bucket S3 n'a pas été créé correctement."
#     }
#   }
# }

# # Output pour l'ARN du bucket S3
# output "bucket_arn" {
#   value = aws_s3_bucket.example.arn

#   # Postcondition pour vérifier que l'ARN du bucket est valide
#   precondition {
#     condition     = can(regex("^arn:aws:s3:::", aws_s3_bucket.example.arn))
#     error_message = "L'ARN du bucket S3 n'est pas valide."
#   }
# }

# # Check pour vérifier que le bucket S3 est accessible
# check "s3_health_check" {
#   data "aws_s3_bucket" "example_check" {
#     bucket = aws_s3_bucket.example.bucket
#   }

#   assert {
#     condition     = data.aws_s3_bucket.example_check.bucket_domain_name != ""
#     error_message = "Le bucket S3 ${aws_s3_bucket.example.bucket} n'est pas accessible ou n'existe pas."
#   }
# }


# # Check pour vérifier que le bucket est accessible
# resource "null_resource" "check_bucket_access" {
#   provisioner "local-exec" {
#     command = "aws s3 ls s3://${aws_s3_bucket.example.bucket} || echo 'Le bucket n'est pas accessible'"
#   }

#   depends_on = [aws_s3_bucket.example]
# }
