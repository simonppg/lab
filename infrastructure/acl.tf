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

resource "truenas_filesystem_acl" "jellyfin" {
  path    = "/mnt/MyPool/Jellyfin"
  acltype = "POSIX1E"

  uid = 0
  gid = 0

  dacl = [
    {
      tag          = "USER_OBJ"
      id           = -1
      perm_read    = true
      perm_write   = true
      perm_execute = true
      default      = false
    },
    {
      tag          = "GROUP_OBJ"
      id           = -1
      perm_read    = true
      perm_write   = false
      perm_execute = true
      default      = false
    },
    {
      tag          = "OTHER"
      id           = -1
      perm_read    = true
      perm_write   = false
      perm_execute = true
      default      = false
    }
  ]
}

resource "truenas_filesystem_acl" "jellyfin_cache" {
  path    = "/mnt/MyPool/Jellyfin/Cache_Storage"
  acltype = "POSIX1E"

  uid = 568
  gid = 568

  dacl = [
    {
      tag          = "USER_OBJ"
      id           = -1
      perm_read    = true
      perm_write   = true
      perm_execute = true
      default      = false
    },
    {
      tag          = "GROUP_OBJ"
      id           = -1
      perm_read    = true
      perm_write   = true
      perm_execute = true
      default      = false
    },
    {
      tag          = "OTHER"
      id           = -1
      perm_read    = true
      perm_write   = false
      perm_execute = true
      default      = false
    }
  ]
}

resource "truenas_filesystem_acl" "jellyfin_config" {
  path    = "/mnt/MyPool/Jellyfin/Config_Storage"
  acltype = "POSIX1E"

  uid = 568
  gid = 568

  dacl = [
    {
      tag          = "USER_OBJ"
      id           = -1
      perm_read    = true
      perm_write   = true
      perm_execute = true
      default      = false
    },
    {
      tag          = "GROUP_OBJ"
      id           = -1
      perm_read    = true
      perm_write   = true
      perm_execute = true
      default      = false
    },
    {
      tag          = "OTHER"
      id           = -1
      perm_read    = true
      perm_write   = false
      perm_execute = true
      default      = false
    }
  ]
}

resource "truenas_filesystem_acl" "jellyfin_transcode" {
  path    = "/mnt/MyPool/Jellyfin/Transcode_Storage"
  acltype = "POSIX1E"

  uid = 568
  gid = 568

  dacl = [
    {
      tag          = "USER_OBJ"
      id           = -1
      perm_read    = true
      perm_write   = true
      perm_execute = true
      default      = false
    },
    {
      tag          = "GROUP_OBJ"
      id           = -1
      perm_read    = true
      perm_write   = true
      perm_execute = true
      default      = false
    },
    {
      tag          = "OTHER"
      id           = -1
      perm_read    = true
      perm_write   = false
      perm_execute = true
      default      = false
    }
  ]
}
