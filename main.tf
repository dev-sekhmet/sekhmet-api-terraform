provider "artifactory" {
    url      = "${var.artifactory_url}/artifactory"
    username = var.artifactory_username
    password = var.artifactory_password
    check_license = false
}

data "artifactory_file" "jar" {
    repository  = var.artifactory_repo
    path        = "com/sekhmet/sekhmetapi/sekhmet-api/${var.app_version}/sekhmet-api-${var.app_version}.jar"
    output_path = "artifact.jar"
}

resource "aws_s3_bucket" "s3_bucket_sekhmet" {
    bucket = "deployment-artifact-${var.environment_suffix}"
    acl = "private"
}

resource "aws_s3_bucket_object" "s3_bucket_object_sekhmet-app" {
    bucket = aws_s3_bucket.s3_bucket_sekhmet.id
    key = "beanstalk/sekhmet-app"
    source = data.artifactory_file.jar.output_path
}

resource "aws_elastic_beanstalk_application" "beanstalk_app" {
    name = "sekhmet-api"
}

resource "aws_elastic_beanstalk_application_version" "beanstalk_myapp_version" {
    application = aws_elastic_beanstalk_application.beanstalk_app.name
    bucket = aws_s3_bucket.s3_bucket_sekhmet.id
    key = aws_s3_bucket_object.s3_bucket_object_sekhmet-app.id
    name = "v${var.app_version}"
}


resource "aws_elastic_beanstalk_environment" "beanstalk_sekhmet_env" {
    name = "app-${var.environment_suffix}"
    application = aws_elastic_beanstalk_application.beanstalk_app.name
    solution_stack_name = "64bit Amazon Linux 2 v3.2.9 running Corretto 11"
    version_label = aws_elastic_beanstalk_application_version.beanstalk_myapp_version.name

    setting {
        name = "SERVER_PORT"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = "5000"
    }

    setting {
        namespace = "aws:ec2:instances"
        name = "InstanceTypes"
        value = "t2.micro"
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "IamInstanceProfile"
        value = "aws-elasticbeanstalk-ec2-role"
    }
}
