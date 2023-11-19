#
# Code Commit
#
resource "aws_codecommit_repository" "codecommit" {
  repository_name = var.repo_name
  description = var.repo_description
}


#
# Code Build
# Test Stage
#
resource "aws_codebuild_project" "test" {

  count = "${length(var.branch)}"  

  name = "${var.repo_name}_${var.branch[count.index]}_test"
  service_role = var.codebuild_service_role

  source {
    type = "CODECOMMIT"
    location = "https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/${var.repo_name}"
    git_clone_depth = 1
    buildspec = var.test_buildspec[count.index]
  }

  source_version = "refs/heads/${var.branch[count.index]}"

  artifacts {
    # テスト工程での成果物を保存したい場合は必要だが、今回は不要なのでNONEを指定
    type = "NO_ARTIFACTS"
  }

  environment {
    image = var.build_env_image
    type = "LINUX_CONTAINER"
    compute_type = "BUILD_GENERAL1_SMALL"
    image_pull_credentials_type = "CODEBUILD"
  }
}


#
# Code Pipeline
#
resource "aws_codepipeline" "pipeline" {

  count = "${length(var.branch)}"  

  name = "${var.repo_name}_${var.branch[count.index]}_pipeline"
  role_arn = var.codepipeline_service_role

  artifact_store {
    type = "S3"
    location = var.artifact_bucket
  }

  stage {
    name = "Source"

    action {
      version = "1"
      name = "Source"
      category = "Source"
      owner = "AWS"
      provider = "CodeCommit"
      output_artifacts = ["SourceArtifact"]
      
      configuration = {
        RepositoryName = var.repo_name
        BranchName = var.branch[count.index]
        OutputArtifactFormat = "CODE_ZIP"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "FirstApproval"
    
    action {
      version = "1"
      name = "Approval"
      category = "Approval"
      owner = "AWS"
      provider = "Manual"
    }
  }

  stage {
    name = "BuildAndTest"

    action {
      version = "1"
      name = "Test"
      category = "Test"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["SourceArtifact"]
      output_artifacts = ["TestArtifact"]

      configuration = {
        ProjectName = aws_codebuild_project.test[count.index].name
      }
    }
  }
}

