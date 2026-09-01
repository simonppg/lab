resource "truenas_filesystem_acl" "mymedia" {
  path    = "/mnt/MyPool/MyMedia"
  acltype = "NFS4"
  uid     = 568
  gid     = 568

  dacl = [
    {
      tag          = "owner@"
      id           = -1
      default      = false
      perm_read    = true
      perm_write   = true
      perm_execute = true
    },
    {
      tag          = "group@"
      id           = -1
      default      = false
      perm_read    = true
      perm_write   = true
      perm_execute = true
    },
    {
      tag          = "GROUP"
      id           = 545
      default      = false
      perm_read    = true
      perm_write   = true
      perm_execute = true
    },
    {
      tag          = "GROUP"
      id           = 544
      default      = false
      perm_read    = true
      perm_write   = true
      perm_execute = true
    },
    {
      tag          = "USER"
      id           = 3000
      default      = false
      perm_read    = true
      perm_write   = true
      perm_execute = true
    }
  ]
}
