// modules/database/outputs.tf
output "users_table_arn" {
  value = aws_dynamodb_table.users.arn
}

output "test_results_table_arn" {
  value = aws_dynamodb_table.test_results.arn
}