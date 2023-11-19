variable "repo_name" {}

variable "repo_description" {}

variable "branch" {}

variable "test_buildspec" {}

# variable "deploy_buildspec" {} パイプラインの動作確認のため、テストのみ実施で十分なので、デプロイは不要

variable "codebuild_service_role" {
  # self_auto_applyで作成したroleを指定する
  default = "arn:aws:iam::183780520150:role/codebuild-terraform-role"
}

variable "codepipeline_service_role" {
  # self_auto_applyで作成したroleを指定する
  default = "arn:aws:iam::183780520150:role/codepipeline-terraform-role"
}

variable "artifact_bucket" {
  # self_auto_applyで作成したbucketを指定する
  default = "tf-auto-apply-artifact-store"
}

variable "build_artifact_path" {
  default = "cicd_own_image"
}

variable "build_env_image" {
  # default = "496310396740.dkr.ecr.ap-northeast-1.amazonaws.com/td-toolbelt:latest" # fl_image_sample
  # default = "aws/codebuild/standard:5.0" # awsのデフォルトイメージ
  # default = "183780520150.dkr.ecr.ap-northeast-1.amazonaws.com/python_sample:latest"
  default = "public.ecr.aws/a8d0u7f4/pub_sample_python:latest"
}
