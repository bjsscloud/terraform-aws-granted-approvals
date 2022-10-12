locals {
  sfn_state_machine_definition = jsonencode({
    Comment = "Granted Access Handler State Machine"
    StartAt = "Validate End is in the Future"

    States = {
      "Validate End is in the Future" = {
        Choices = [{
          Next                     = "Wait for Grant Start Time"
          TimestampGreaterThanPath = "$$.State.EnteredTime"
          Variable                 = "$.grant.end"
        }]

        Comment = "Do not provision any access if the end time is in the past"
        Default = "Fail"
        Type    = "Choice"
      }

      "Wait for Grant Start Time" = {
        Next          = "Activate Access"
        TimestampPath = "$.grant.start"
        Type          = "Wait"
      }

      "Activate Access" = {
        Next = "Wait for Window End"

        OutputPath = "$.Payload"

        Parameters = {
          FunctionName = module.lambdacron_granter.lambda_function_name

          Payload = {
            "action"  = "ACTIVATE"
            "grant.$" = "$.grant"
          }
        }

        Resource   = "arn:${var.aws_partition}:states:::lambda:invoke"
        ResultPath = "$"

        Retry = [{
          BackoffRate = 2

          ErrorEquals = [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
          ]

          IntervalSeconds = 2
          MaxAttempts     = 6
        }]

        Type = "Task"
      }

      "Wait for Window End" = {
        Next          = "Expire Access"
        TimestampPath = "$.grant.end"
        Type          = "Wait"
      }

      "Expire Access" = {
        End = true

        OutputPath = "$.Payload"

        Parameters = {
          FunctionName = module.lambdacron_granter.lambda_function_name

          Payload = {
            "action"  = "DEACTIVATE"
            "grant.$" = "$.grant"
          }
        }

        Resource   = "arn:${var.aws_partition}:states:::lambda:invoke"
        ResultPath = "$"

        Retry = [{
          BackoffRate = 2

          ErrorEquals = [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
          ]

          IntervalSeconds = 2
          MaxAttempts     = 6
        }]

        Type = "Task"
      }

      "Fail" = {
        Type = "Fail"
      }
    }
  })
}
