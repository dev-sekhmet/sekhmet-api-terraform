provider "aws" {
    region = "eu-west-3"
    alias = "euwest3"
}

terraform {
    required_providers {
        artifactory = {
            source = "jfrog/artifactory"
            version = "2.6.24"
        }
    }
}
