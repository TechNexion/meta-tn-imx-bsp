#!/bin/bash

#
# i.MX Yocto Project Build Environment Setup Script
#
# Copyright 2026 TechNexion Ltd.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA


# Automatically appends a meta-layer to bblayers.conf if it exists and isn't already present.
# Arguments: $1 (pwd) - Project root, $2 (id) - Release ID, $3 (name) - Layer folder name
tn_auto_append_layer() {
  local work_dir=$1 id=$2 name=$3

  [[ -d $work_dir/../sources/$name ]] || return
  grep -qF "$name" "$work_dir/conf/bblayers.conf" && return

  printf "\n# setup NXP $id release layer in bblayers.conf\n" >> "$work_dir/conf/bblayers.conf"
  printf "BBLAYERS += \" \${BSPDIR}/sources/$name \"\n" >> "$work_dir/conf/bblayers.conf"
}

# Append layer configuration to file if no backup exists
# Arguments: $1: file path, $2: show on screen (yes/no), $3: content to append
_tn_append_file() {
  local file_path="$1" show=$2 value="$3"
  local baskup_file_path="${file_path}.org"

  test -e "$baskup_file_path"
  file_exist="$?"
  [[ "$file_exist" == "0" ]] && return

  if [ "$show" == "yes" ]; then
    printf "$value\n" | tee -a "$file_path"
  else
    printf "$value\n" >> "$file_path"
  fi

}

# Append extra settings to local.conf if no backup exists
# Arguments: $1: work dir, $2: show on screen (yes/no), $3: content to append
tn_append_conf() {
  local work_dir=$1 show=$2 value="$3"

  local file_name="$work_dir/conf/local.conf"
  _tn_append_file "$file_name" "$show" "$value"
}

# Append layer configuration to file if no backup exists
# Arguments: $1: work dir, $2: show on screen (yes/no), $3: content to append
tn_append_layer() {
  local work_dir=$1 show=$2 value="$3"

  local file_name="$work_dir/conf/bblayers.conf"
  _tn_append_file "$file_name" "$show" "$value"
}