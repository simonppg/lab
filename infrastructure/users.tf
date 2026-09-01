resource "truenas_user" "cinefilo" {
  username  = "cinefilo"
  full_name = "cinefilo"

  uid    = 3000
  group  = truenas_group.cinefilo.id
  groups = [91]

  home   = "/var/empty"
  shell  = "/usr/sbin/nologin"
  smb    = true
  locked = false

  password = var.cinefilo_password
}
