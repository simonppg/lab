resource "truenas_share_smb" "mymedia" {
  name     = "MyMedia"
  path     = "/mnt/MyPool/MyMedia"
  enabled  = true
  readonly = false
}

resource "truenas_share_smb" "mystorage" {
  depends_on = [truenas_dataset.mystorage]

  name      = "MyStorage"
  path      = "/mnt/MyPool/MyStorage"
  enabled   = true
  readonly  = false
  browsable = true
}
