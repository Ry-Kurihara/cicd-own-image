provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  backend "s3" {
    bucket = "tf-state-bucket-ryku"
    key    = "cicd_own_image/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

# 作成するリポジトリの定義
module "container_sample" {
  source = "./modules/pipeline"

  repo_name = "container_sample"
  repo_description = "Hello description"
  branch = ["master"]
  test_buildspec = ["test_buildspec.yml"]
}

module "git_repository_setup" {
  source = "./modules/setup"
  
  repo_name = "container_sample"  
  branch    = ["master"] 
}
