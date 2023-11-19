resource "null_resource" "git_repository_setup" {
  for_each = toset(var.branch)

  triggers = {
    repo_name = var.repo_name
    branch_name = each.key
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "Listing files in ${path.module}/setup_files/${var.repo_name}"
      ls -la ${path.module}/setup_files/${var.repo_name}
      rm -rf /tmp/${var.repo_name}
      mkdir /tmp/${var.repo_name}
      cp -r ${path.module}/setup_files/${var.repo_name}/* /tmp/${var.repo_name}
      cd /tmp/${var.repo_name}
      git init
      
      # Configure git user
      git config user.name "Terraform"
      git config user.email "terraform@example.com"
      
      # Add remote origin
      git remote add origin ssh://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/${var.repo_name}
      
      if [ "${each.key}" == "master" ]; then
        # Create master branch
        git checkout -b master
        git add .
        git commit --allow-empty -m "Initial commit in ${each.key} branch"
        GIT_SSH_COMMAND="ssh -i ~/.ssh/codecommit" git push -u origin master
      else
        # Create develop branch
        git checkout -b ${each.key} master
        git add .
        git commit --allow-empty -m "Initial commit in ${each.key} branch"
        GIT_SSH_COMMAND="ssh -i ~/.ssh/codecommit" git push -u origin ${each.key}
      fi
    EOT
  }
}
