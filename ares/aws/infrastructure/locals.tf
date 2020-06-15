locals {

  ictf_user = "ubuntu"

  services_scripts = jsondecode(file(var.game_config_file)).services
  
  registry_id = length(aws_ecr_repository.service_scriptbot_image) == 0 ? "" : aws_ecr_repository.service_scriptbot_image[0].registry_id

  database_provision_with_ansible = <<EOF
  ansible-playbook ~/ares_provisioning_first_stage/ansible-provisioning.yml \
    --extra-vars AWS_ACCESS_KEY=${var.access_key} \
    --extra-vars AWS_SECRET_KEY=${var.secret_key} \
    --extra-vars AWS_REGION=${var.region} \
    --extra-vars AWS_REGISTRY_URL=${aws_ecr_repository.ictf_database.repository_url} \
    --extra-vars COMPONENT_NAME=database
  EOF

  gamebot_provision_with_ansible = <<EOF
  ansible-playbook ~/ares_provisioning_first_stage/ansible-provisioning.yml \
    --extra-vars AWS_ACCESS_KEY=${var.access_key} \
    --extra-vars AWS_SECRET_KEY=${var.secret_key} \
    --extra-vars AWS_REGION=${var.region} \
    --extra-vars AWS_REGISTRY_URL=${aws_ecr_repository.ictf_gamebot.repository_url} \
    --extra-vars COMPONENT_NAME=gamebot
  EOF

  scoreboard_provision_with_ansible = <<EOF
  ansible-playbook ~/ares_provisioning_first_stage/ansible-provisioning.yml \
    --extra-vars AWS_ACCESS_KEY=${var.access_key} \
    --extra-vars AWS_SECRET_KEY=${var.secret_key} \
    --extra-vars AWS_REGION=${var.region} \
    --extra-vars AWS_REGISTRY_URL=${aws_ecr_repository.ictf_scoreboard.repository_url} \
    --extra-vars COMPONENT_NAME=scoreboard
  EOF

  teaminterface_provision_with_ansible = <<EOF
  ansible-playbook ~/ares_provisioning_first_stage/ansible-provisioning.yml \
    --extra-vars AWS_ACCESS_KEY=${var.access_key} \
    --extra-vars AWS_SECRET_KEY=${var.secret_key} \
    --extra-vars AWS_REGION=${var.region} \
    --extra-vars AWS_REGISTRY_URL=${aws_ecr_repository.ictf_teaminterface.repository_url} \
    --extra-vars COMPONENT_NAME=teaminterface
  EOF

  scriptbot_common_provision_with_ansible = <<EOF
  ansible-playbook ~/ares_provisioning_first_stage/ansible-provisioning.yml \
    --extra-vars AWS_ACCESS_KEY=${var.access_key} \
    --extra-vars AWS_SECRET_KEY=${var.secret_key} \
    --extra-vars AWS_REGION=${var.region} \
    --extra-vars AWS_REGISTRY_URL=${aws_ecr_repository.ictf_scriptbot.repository_url} \
    --extra-vars COMPONENT_NAME=scriptbot
  EOF

  logger_provision_with_ansible = <<EOF
  ansible-playbook ~/ares_provisioning_first_stage/ansible-provisioning.yml \
    --extra-vars AWS_ACCESS_KEY=${var.access_key} \
    --extra-vars AWS_SECRET_KEY=${var.secret_key} \
    --extra-vars AWS_REGION=${var.region} \
    --extra-vars AWS_REGISTRY_URL=${aws_ecr_repository.ictf_logger.repository_url} \
    --extra-vars COMPONENT_NAME=logger
  EOF

  router_provision_with_ansible = <<EOF
  ansible-playbook ~/ares_provisioning_first_stage/ansible-provisioning.yml \
    --extra-vars AWS_ACCESS_KEY=${var.access_key} \
    --extra-vars AWS_SECRET_KEY=${var.secret_key} \
    --extra-vars AWS_REGION=${var.region} \
    --extra-vars AWS_REGISTRY_URL=${aws_ecr_repository.ictf_router.repository_url} \
    --extra-vars COMPONENT_NAME=router
  EOF

  dispatcher_provision_with_ansible = <<EOF
  ansible-playbook ~/ares_provisioning_first_stage/ansible-provisioning.yml \
    --extra-vars AWS_ACCESS_KEY=${var.access_key} \
    --extra-vars AWS_SECRET_KEY=${var.secret_key} \
    --extra-vars AWS_REGION=${var.region} \
    --extra-vars AWS_REGISTRY_URL=${aws_ecr_repository.ictf_dispatcher.repository_url} \
    --extra-vars COMPONENT_NAME=dispatcher
  EOF

  start_service_container = <<EOF
  docker-compose -f ~/docker-compose.yml up -d
  EOF

}
