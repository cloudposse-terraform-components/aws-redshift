# Scheduled pause and resume for the cluster.
#
# A paused cluster bills for storage only, so a warehouse that is queried for part of
# the day can be paused for the rest of it.
#
# Schedules are a map rather than a single resume/pause pair because a cluster usually
# needs more than one up-window. AWS cannot maintain a paused cluster, so
# `preferred_maintenance_window` has to fall inside an up-window or maintenance can
# never run. That normally means one window for the workload and a separate, shorter
# one covering the maintenance window.
#
# Cron expressions are UTC. Redshift has no timezone support for scheduled actions, so
# a schedule expressed against local wall-clock time shifts by an hour at daylight
# saving transitions and has to be moved by hand.

locals {
  scheduled_actions = local.enabled && var.pause_resume_enabled ? var.pause_resume_schedules : {}
}

resource "aws_redshift_scheduled_action" "resume" {
  for_each = local.scheduled_actions

  name     = "${module.this.id}-${each.key}-resume"
  schedule = each.value.resume_cron
  iam_role = var.scheduled_action_iam_role_arn
  enable   = true

  target_action {
    resume_cluster {
      cluster_identifier = module.redshift_cluster.cluster_identifier
    }
  }

  lifecycle {
    precondition {
      condition     = var.scheduled_action_iam_role_arn != null && var.scheduled_action_iam_role_arn != ""
      error_message = "`scheduled_action_iam_role_arn` is required when `pause_resume_enabled` is true and `pause_resume_schedules` is non-empty. The provider requires `iam_role` on `aws_redshift_scheduled_action`. The role must trust `scheduler.redshift.amazonaws.com` and allow `redshift:PauseCluster` and `redshift:ResumeCluster`."
    }
  }
}

resource "aws_redshift_scheduled_action" "pause" {
  for_each = local.scheduled_actions

  name     = "${module.this.id}-${each.key}-pause"
  schedule = each.value.pause_cron
  iam_role = var.scheduled_action_iam_role_arn
  enable   = true

  target_action {
    pause_cluster {
      cluster_identifier = module.redshift_cluster.cluster_identifier
    }
  }

  lifecycle {
    precondition {
      condition     = var.scheduled_action_iam_role_arn != null && var.scheduled_action_iam_role_arn != ""
      error_message = "`scheduled_action_iam_role_arn` is required when `pause_resume_enabled` is true and `pause_resume_schedules` is non-empty. The provider requires `iam_role` on `aws_redshift_scheduled_action`. The role must trust `scheduler.redshift.amazonaws.com` and allow `redshift:PauseCluster` and `redshift:ResumeCluster`."
    }
  }
}
