module "base" {
    source = "../base"
    app_env_SERVER_PORT = "${var.app_env_SERVER_PORT}"
    app_env_SPRING_DATASOURCE_URL = "${var.app_env_SPRING_DATASOURCE_URL}"
    app_env_SPRING_DATASOURCE_USERNAME = "${var.app_env_SPRING_DATASOURCE_USERNAME}"
    app_env_SPRING_DATASOURCE_PASSWORD = "${var.app_env_SPRING_DATASOURCE_PASSWORD}"

    app_env_SPRING_ELASTICSEARCH_REST_URIS = "${var.app_env_SPRING_ELASTICSEARCH_REST_URIS}"

    app_env_APPLICATION_SMS_TWILIO_ACCOUNT_SID = "${var.app_env_APPLICATION_SMS_TWILIO_ACCOUNT_SID}"
    app_env_APPLICATION_SMS_PASSWORD_PHONE_NUMBER_SECRET = "${var.app_env_APPLICATION_SMS_PASSWORD_PHONE_NUMBER_SECRET}"
    app_env_APPLICATION_SMS_TWILIO_API_SECRET = "${var.app_env_APPLICATION_SMS_TWILIO_API_SECRET}"
    app_env_APPLICATION_SMS_TWILIO_AUTH_TOKEN = "${var.app_env_APPLICATION_SMS_TWILIO_AUTH_TOKEN}"
    app_env_APPLICATION_SMS_TWILIO_CONVERSATION_SID = "${var.app_env_APPLICATION_SMS_TWILIO_CONVERSATION_SID}"
    app_env_APPLICATION_SMS_TWILIO_VERIFY_SID = "${var.app_env_APPLICATION_SMS_TWILIO_VERIFY_SID}"
    app_env_APPLICATION_SMS_TWILIO_API_SID = "${var.app_env_APPLICATION_SMS_TWILIO_API_SID}"
    app_env_APPLICATION_SMS_TWILIO_CHANNEL_USER_SID = "${var.app_env_APPLICATION_SMS_TWILIO_CHANNEL_USER_SID}"
    app_env_APPLICATION_SMS_TWILIO_CHANNEL_ADMIN_SID = "${var.app_env_APPLICATION_SMS_TWILIO_CHANNEL_ADMIN_SID}"

    app_version = "${var.app_version}"
    artifactory_password = "${var.artifactory_password}"
    artifactory_repo = "${var.artifactory_repo}"
    artifactory_username = "${var.artifactory_username}"
    artifactory_url = "${var.artifactory_url}"

    environment_cname = "${var.environment_cname}"
    name = "${var.name}"
}