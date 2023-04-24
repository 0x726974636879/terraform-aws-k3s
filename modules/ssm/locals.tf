locals {
  documents = {
    apply_kubernetes_deployment = {
      name            = "apply_kubernetes_deployment"
      document_format = "JSON"
      document_type   = "Command"

      content = jsonencode({
        "schemaVersion" : "2.2",
        "description" : "Create ${var.deployment_file_name} file.",
        "parameters" : {

        },
        "mainSteps" : [
          {
            "action" : "aws:runShellScript",
            "name" : "example",
            "inputs" : {
              "timeoutSeconds" : "60",
              "runCommand" : [
                "kubectl apply -f /home/ubuntu/${var.deployment_file_name}"
              ]
            }
          }
        ]
      })
    }
  }
}
