resource "truenas_dataset" "jellyfin" {
  pool = truenas_pool.mypool.name
  name = "Jellyfin"
}

resource "truenas_dataset" "jellyfin_cache" {
  pool           = truenas_pool.mypool.name
  name           = "Cache_Storage"
  parent_dataset = truenas_dataset.jellyfin.name
}

resource "truenas_dataset" "jellyfin_config" {
  pool           = truenas_pool.mypool.name
  name           = "Config_Storage"
  parent_dataset = truenas_dataset.jellyfin.name
}

resource "truenas_dataset" "jellyfin_transcode" {
  pool           = truenas_pool.mypool.name
  name           = "Transcode_Storage"
  parent_dataset = truenas_dataset.jellyfin.name
}

resource "truenas_dataset" "mymedia" {
  pool = truenas_pool.mypool.name
  name = "MyMedia"
}
