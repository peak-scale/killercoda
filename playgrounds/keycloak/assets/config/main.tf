provider "keycloak" {
    client_id     = "admin-cli"
    username      = var.keycloak_username
    password      = var.keycloak_password
    url           = var.keycloak_url
    tls_insecure_skip_verify = var.keycloak_insecure
}

resource "keycloak_realm" "demo_identity" {
  realm                                = "demo"
  display_name                         = "Demo Identity"
  enabled                              = true
  access_code_lifespan                 = "2h"
  sso_session_idle_timeout             = "10h"
  sso_session_max_lifespan             = "72h"
  offline_session_idle_timeout         = "720h"
  offline_session_max_lifespan_enabled = true
  registration_allowed                 = false
  registration_email_as_username       = false
  reset_password_allowed               = true
  verify_email                         = true
  login_with_email_allowed             = true
  ssl_required                         = "external"
  login_theme                          = "keywind"
  #account_theme                        = "keycloak"
  #admin_theme                          = "keycloak"
  #email_theme                          = "keycloak"
  #login_theme                          = "keycloak"

  smtp_server {
    host                  = "mail.buttah.cloud"
    port                  = 587
    from                  = "info@buttah.cloud"
    from_display_name     = "Buttah Identity (Do-Not-Reply)"
    reply_to              = "no-reply@buttah.cloud"
    reply_to_display_name = "Buttah Identity (Do-Not-Reply)"
    starttls              = true
    ssl                   = false
    auth {
      username = data.ejson_file.secrets.map.mail_user
      password = data.ejson_file.secrets.map.mail_password
    }
  }

  internationalization {
    supported_locales = [
      "de",
      "en",
      "fr"
    ]
    default_locale = "en"
  }

  # Vanilla-Kandidat
  security_defenses {
    headers {
      x_frame_options                     = "SAMEORIGIN"
      content_security_policy             = "frame-src 'self'; frame-ancestors 'self'; object-src 'none';"
      content_security_policy_report_only = ""
      x_content_type_options              = "nosniff"
      x_robots_tag                        = "none"
      x_xss_protection                    = "1; mode=block"
      strict_transport_security           = "max-age=31536000; includeSubDomains"
    }
    brute_force_detection {
      permanent_lockout                = false
      max_login_failures               = 30
      wait_increment_seconds           = 60
      quick_login_check_milli_seconds  = 1000
      minimum_quick_login_wait_seconds = 60
      max_failure_wait_seconds         = 900
      failure_reset_time_seconds       = 43200
    }
  }

  # Password Policy
  # Available [notEmail specialChars hashAlgorithm forceExpiredPasswordChange passwordHistory notUsername lowerCase digits hashIterations length regexPattern passwordBlacklist upperCase maxLength]
  #password_policy = "upperCase(1) and length(12) and digits(2) and specialChars(1) and passwordHistory(5) and forceExpiredPasswordChange(365) and notUsername and notEmail"
}

# Vanilla-Kandidat
resource "keycloak_realm_events" "demo_identity_events" {
  realm_id = keycloak_realm.demo_identity.id

  events_enabled    = true
  events_expiration = 172800

  admin_events_enabled         = true
  admin_events_details_enabled = true

  # When omitted or left empty, keycloak will enable all event types
  enabled_event_types = []

  events_listeners = [
    "jboss-logging", # keycloak enables the 'jboss-logging' event listener by default.
    "metrics-listener"
  ]
}

resource "keycloak_openid_client_scope" "demo_clientscope-roles-by-groups" {
  realm_id               = keycloak_realm.demo_identity.id
  name                   = "groups"
  description            = "User Roles as Groups claim"
  include_in_token_scope = false
  gui_order              = 1
}

resource "keycloak_openid_user_realm_role_protocol_mapper" "demo_realm_roles_by_groups_mapper" {
  realm_id        = keycloak_realm.demo_identity.id
  client_scope_id = keycloak_openid_client_scope.demo_clientscope-roles-by-groups.id
  name            = "groups"

  claim_name          = "groups"
  claim_value_type    = "String"
  multivalued         = true
  add_to_id_token     = true # Hubble needs that (in Feb 2023 at least)!
  add_to_access_token = true
  add_to_userinfo     = false
}

resource "keycloak_openid_client" "demo_identity_openid_client_kubernetes" {
  realm_id                     = keycloak_realm.demo_identity.id
  client_id                    = var.client_id
  client_secret                = var.client_secret
  name                         = "demo"
  description                  = "demo"
  enabled                      = true
  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = true
  implicit_flow_enabled        = true
  valid_redirect_uris          =  var.client_uris
  web_origins                  = [
    "+"
  ]
}

resource "keycloak_openid_full_name_protocol_mapper" "demo_full_name_mapper" {
  realm_id  = keycloak_realm.demo_identity.id
  client_id = keycloak_openid_client.demo_identity_openid_client_kubernetes.id
  name      = "full-name-mapper"
}

resource "keycloak_openid_client_default_scopes" "demo_realm_roles" {
  realm_id  = keycloak_realm.demo_identity.id
  client_id = keycloak_openid_client.demo_identity_openid_client_kubernetes.id

  default_scopes = [
    "profile",
    "email",
    keycloak_openid_client_scope.demo_clientscope-roles-by-groups.name,
  ]
}


