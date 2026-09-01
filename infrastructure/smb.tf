resource "truenas_share_smb" "mymedia" {
  name     = "MyMedia"
  path     = "/mnt/MyPool/MyMedia"
  enabled  = true
  readonly = false
}
