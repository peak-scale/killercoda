// Groups

resource "keycloak_group" "solar" {
  realm_id = keycloak_realm.demo_identity.id
  name     = "solar"
}

resource "keycloak_group" "wind" {
  realm_id = keycloak_realm.demo_identity.id
  name     = "wind"
}

resource "keycloak_group" "green" {
  realm_id = keycloak_realm.demo_identity.id
  name     = "green"
}

// Users

resource "keycloak_user" "alice" {
  realm_id = keycloak_realm.demo_identity.id
  username = "alice"

  initial_password {
    temporary = false
    value     = "alice"
  }

  email          = "alice@killercoda.com"
  email_verified = true
  first_name     = "Alice"
  last_name      = "Solar"
}

resource "keycloak_user_groups" "alice" {
  realm_id = keycloak_realm.demo_identity.id
  user_id  = keycloak_user.alice.id

  group_ids = [keycloak_group.solar.id]
}

resource "keycloak_user" "bob" {
  realm_id = keycloak_realm.demo_identity.id
  username = "bob"

  initial_password {
    temporary = false
    value     = "bob"
  }

  email          = "bob@killercoda.com"
  email_verified = true
  first_name     = "Bob"
  last_name      = "Wind"
}

resource "keycloak_user_groups" "bob" {
  realm_id = keycloak_realm.demo_identity.id
  user_id  = keycloak_user.bob.id

  group_ids = [keycloak_group.wind.id]
}

resource "keycloak_user" "john" {
  realm_id = keycloak_realm.demo_identity.id
  username = "john"

  initial_password {
    temporary = false
    value     = "john"
  }

  email          = "john@killercoda.com"
  email_verified = true
  first_name     = "John"
  last_name      = "Green"
}

resource "keycloak_user_groups" "john" {
  realm_id = keycloak_realm.demo_identity.id
  user_id  = keycloak_user.john.id

  group_ids = [keycloak_group.green.id]
}
