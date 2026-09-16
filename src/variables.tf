variable "region" {
  type        = string
  description = "AWS region"
}

variable "port" {
  type        = number
  default     = 5439
  description = "The port number on which the cluster accepts incoming connections"
}

variable "admin_user" {
  type        = string
  default     = null
  description = "Username for the master DB user. Required unless a snapshot_identifier is provided"
}

variable "admin_password" {
  type        = string
  default     = null
  description = "Password for the master DB user. Required unless a snapshot_identifier is provided"
}

variable "database_name" {
  type        = string
  default     = null
  description = "The name of the first database to be created when the cluster is created"
}

variable "node_type" {
  type        = string
  default     = "dc2.large"
  description = "The node type to be provisioned for the cluster. See https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-clusters.html#working-with-clusters-overview"
}

variable "number_of_nodes" {
  type        = number
  default     = 1
  description = "The number of compute nodes in the cluster. This parameter is required when the ClusterType parameter is specified as multi-node"
}

variable "cluster_type" {
  type        = string
  default     = "single-node"
  description = "The cluster type to use. Either `single-node` or `multi-node`"
}

variable "engine_version" {
  type        = string
  default     = "1.0"
  description = "The version of the Amazon Redshift engine to use. See https://docs.aws.amazon.com/redshift/latest/mgmt/cluster-versions.html"
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "If true, the cluster can be accessed from a public network"
}

variable "allow_version_upgrade" {
  type        = bool
  default     = false
  description = "Whether or not to enable major version upgrades which are applied during the maintenance window to the Amazon Redshift engine that is running on the cluster"
}

variable "use_private_subnets" {
  type        = bool
  default     = true
  description = "Whether to use private or public subnets for the Redshift cluster"
}

variable "security_group_ids" {
  type        = list(string)
  default     = null
  description = "An array of security group IDs to associate with the endpoint."
}

variable "custom_sg_enabled" {
  type        = bool
  default     = false
  description = "Whether to use custom security group or not"
}

variable "custom_sg_allow_all_egress" {
  type        = bool
  default     = true
  description = "Whether to allow all egress traffic or not"
}

variable "custom_sg_rules" {
  type = list(object({
    key         = string
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default     = []
  description = "An array of custom security groups to create and assign to the cluster."
}

variable "cluster_identifier" {
  type        = string
  default     = ""
  description = "The Redshift Cluster Identifier. Must be a lower case string. Will use generated label ID if not supplied"
}

variable "snapshot_identifier" {
  type        = string
  default     = null
  description = "The name of the snapshot from which to create the new cluster"
}

variable "snapshot_cluster_identifier" {
  type        = string
  default     = null
  description = "The name of the cluster the source snapshot was created from"
}

variable "encrypted" {
  type        = bool
  default     = false
  description = "Specifies whether the cluster is encrypted at rest"
}

variable "kms_key_arn" {
  type        = string
  default     = null
  description = "The ARN for the KMS encryption key. When specifying `kms_key_arn`, `encrypted` needs to be set to `true`"
}

variable "iam_roles" {
  type        = list(string)
  default     = []
  description = "A list of IAM Role ARNs to associate with the cluster. A maximum of 10 can be associated to the cluster at any time"
}

variable "logging_enabled" {
  type        = bool
  default     = false
  description = "If true, enables logging information such as queries and connection attempts, for the specified Amazon Redshift cluster"
}

variable "logging_bucket_name" {
  type        = string
  default     = null
  description = "The name of an existing S3 bucket where the log files are to be stored. Must be in the same region as the cluster and the cluster must have read bucket and put object permissions"
}

variable "logging_s3_key_prefix" {
  type        = string
  default     = null
  description = "The prefix applied to the log file names"
}

variable "preferred_maintenance_window" {
  type        = string
  default     = null
  description = "Weekly time range during which system maintenance can occur, in UTC. Format: ddd:hh24:mi-ddd:hh24:mi"
}

variable "automated_snapshot_retention_period" {
  type        = number
  default     = 1
  description = "The number of days that automated snapshots are retained. If the value is 0, automated snapshots are disabled"
}

variable "availability_zone" {
  type        = string
  default     = null
  description = "Optional parameter to place Amazon Redshift cluster instances in a specific availability zone. If left empty, will place randomly"
}

variable "availability_zone_relocation_enabled" {
  type        = bool
  default     = false
  description = "Whether or not the cluster can be relocated to another availability zone, either automatically by AWS or when requested. Available for use on clusters from the RA3 instance family"
}

variable "enhanced_vpc_routing" {
  type        = bool
  default     = false
  description = "If true, enhanced VPC routing is enabled"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = true
  description = "Determines whether a final snapshot of the cluster is created before Amazon Redshift deletes the cluster"
}

variable "final_snapshot_identifier" {
  type        = string
  default     = null
  description = "The identifier of the final snapshot that is to be created immediately before deleting the cluster. If this parameter is provided, `skip_final_snapshot` must be `false`"
}

variable "cluster_parameters" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "List of Redshift parameters to apply"
}

variable "vpc_component_name" {
  type        = string
  default     = "vpc"
  nullable    = false
  description = "VPC component name"
}

variable "subnet_ids" {
  type        = list(string)
  default     = null
  description = "Subnet IDs to place the cluster in. When set, these are used directly and the `vpc` component is not looked up, which allows the component to be used in stacks that have no CloudPosse managed VPC"
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "VPC the cluster's security group belongs to. Only needed alongside `subnet_ids`, which bypasses the `vpc` component lookup, and only when `custom_sg_enabled` is `true`. Left null, the ID comes from the `vpc` component as before"
}

variable "pause_resume_enabled" {
  type        = bool
  default     = false
  description = "Whether to create scheduled actions that pause and resume the cluster"
}

variable "pause_resume_schedules" {
  type = map(object({
    resume_cron = string
    pause_cron  = string
  }))
  default     = {}
  description = <<-EOT
    Named up-windows for the cluster, each a resume and pause cron pair. A map rather than a
    single pair because `preferred_maintenance_window` must fall inside an up-window, since AWS
    cannot maintain a paused cluster. That usually means one window for the workload and a
    separate one for maintenance. Cron is UTC, in the Redshift format
    `cron(Minutes Hours Day-of-month Month Day-of-week Year)`.
  EOT
}

variable "scheduled_action_iam_role_arn" {
  type        = string
  default     = null
  description = "ARN of the IAM role Redshift assumes to run the scheduled actions. Must trust `scheduler.redshift.amazonaws.com` and allow `redshift:PauseCluster` and `redshift:ResumeCluster`"
}
