module "vpc" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "2.0.0"

  component = var.vpc_component_name

  # Skip the lookup entirely when subnets are supplied directly, so the component can be
  # used in stacks that have no CloudPosse managed `vpc` component.
  bypass = var.subnet_ids != null

  defaults = {
    private_subnet_ids = []
    public_subnet_ids  = []
    vpc_id             = null
  }

  context = module.this.context
}
