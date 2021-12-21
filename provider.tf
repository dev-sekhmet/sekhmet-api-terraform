provider "aws" {
}

terraform {
    required_providers {
        artifactory = {
            source = "jfrog/artifactory"
            version = "2.6.24"
        }
    }
}
