# Vagrant shared directories get owned by the vagrant user
# but some programs need certain (usually sub-) dirs to be user-writable.
# Create tmp dirs and mount them on top of the share to work around this.
function change_shared_dir_owner () {
  local user="$1" dest="$2"
  local src="/tmp/v-share-mounts/$dest"

  mkdir -p "$dest" "$src"
  chown "$user" "$src"
  chmod g+w "$src"

  # Only proceed if not already mounted.
  mount | grep -qF " $dest " && return

  mount --bind "$src" "$dest"
}
