
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

resource "truenas_filesystem_acl" "mystorage" {
  depends_on = [truenas_dataset.mystorage]

  path    = "/mnt/MyPool/MyStorage"
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
      tag          = "USER"
      id           = 3000
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
      tag          = "MASK"
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

