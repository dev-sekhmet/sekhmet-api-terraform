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
    bucket = "sekhmet-content-${var.environment_suffix}"
    acl = "private"
    force_destroy = true
    tags = {
        Name        = "Name"
        Environment = "Sekhmet_Chat_File"
    }
}

resource "aws_s3_bucket_object" "s3_bucket_object_sekhmet-app" {
    bucket = aws_s3_bucket.s3_bucket_sekhmet.id
    key = "beanstalk/sekhmet-app"
    source = data.artifactory_file.jar.output_path
}

resource "aws_elastic_beanstalk_application" "beanstalk_app" {
    name = "sekhmet-api"
}

resource "aws_elastic_beanstalk_application_version" "beanstalk_app_version" {
    application = aws_elastic_beanstalk_application.beanstalk_app.name
    bucket = aws_s3_bucket.s3_bucket_sekhmet.id
    key = aws_s3_bucket_object.s3_bucket_object_sekhmet-app.id
    name = "v${var.app_version}"
}

resource "aws_elastic_beanstalk_environment" "beanstalk_sekhmet_env" {
    name = "app-${var.environment_suffix}"
    application = aws_elastic_beanstalk_application.beanstalk_app.name
    solution_stack_name = "64bit Amazon Linux 2 v3.2.11 running Corretto 11"
    version_label = aws_elastic_beanstalk_application_version.beanstalk_app_version.name

    setting {
        name = "SERVER_PORT"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = var.app_env_SERVER_PORT
    }
    setting {
        name = "SPRING_DATASOURCE_URL"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = var.app_env_SPRING_DATASOURCE_URL
    }
    setting {
        name = "SPRING_DATASOURCE_USERNAME"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = var.app_env_SPRING_DATASOURCE_USERNAME
    }
    setting {
        name = "SPRING_DATASOURCE_PASSWORD"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = var.app_env_SPRING_DATASOURCE_PASSWORD
    }
    setting {
        name = "SPRING_ELASTICSEARCH_REST_URIS"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = var.app_env_SPRING_ELASTICSEARCH_REST_URIS
    }
    setting {
        name = "APPLICATION_S3_REGION"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = "eu-west-3"
    }
    setting {
        name = "APPLICATION_S3_BUCKET"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = aws_s3_bucket.s3_bucket_sekhmet.bucket
    }

    setting {
        name = "APPLICATION_S3_ENDPOINT"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = "https://s3.eu-west-3.amazonaws.com"
    }

    setting {
        name = "APPLICATION_SMS_TWILIO_ACCOUNT_SID"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = var.app_env_APPLICATION_SMS_TWILIO_ACCOUNT_SID
    }
    setting {
        name = "APPLICATION_SMS_TWILIO_AUTH_TOKEN"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = var.app_env_APPLICATION_SMS_TWILIO_AUTH_TOKEN
    }

    setting {
        name = "APPLICATION_SMS_PASSWORD_PHONE_NUMBER_SECRET"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = var.app_env_APPLICATION_SMS_PASSWORD_PHONE_NUMBER_SECRET
    }
    setting {
        name = "APPLICATION_SMS_TWILIO_VERIFY_SID"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = var.app_env_APPLICATION_SMS_TWILIO_VERIFY_SID
    }
    setting {
        name = "APPLICATION_SMS_TWILIO_CONVERSATION_SID"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = var.app_env_APPLICATION_SMS_TWILIO_CONVERSATION_SID
    }

    setting {
        name = "APPLICATION_SMS_TWILIO_API_SID"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = var.app_env_APPLICATION_SMS_TWILIO_API_SID
    }
    setting {
        name = "APPLICATION_SMS_TWILIO_API_SECRET"
        namespace = "aws:elasticbeanstalk:application:environment"
        value = var.app_env_APPLICATION_SMS_TWILIO_API_SECRET
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