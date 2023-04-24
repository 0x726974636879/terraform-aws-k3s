resource "aws_ssm_document" "this" {
  for_each        = local.documents
  name            = each.value.name
  document_format = each.value.document_format
  document_type   = each.value.document_type

  content = each.value.content
}


resource "aws_ssm_association" "this" {
  for_each = local.documents
  name     = aws_ssm_document.this[each.key].name

  document_version = "$LATEST"
  targets {
    key    = "tag:InstanceId"
    values = ["i-033dad697ddb9f5ca"]
  }
}
