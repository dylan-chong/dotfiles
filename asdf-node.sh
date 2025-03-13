#!/usr/bin/env bash

# Setup:
#   Put this code in this file ~/asdf-node.sh
#   sudo mkdir -p /usr/local/bin/
#   sudo ln -s ~/asdf-node.sh /usr/local/bin/node
#   sudo chmod +x ~/asdf-node.sh

set -e

asdf_base_dir="/opt/homebrew/Cellar/asdf"
asdf_highest_version=$(ls -1 $asdf_base_dir | sort -V | tail -n 1)
asdf_bin_dir="$asdf_base_dir/$asdf_highest_version/bin"

asdf_shims_dir=$HOME/.asdf/shims

export PATH="$asdf_data_dir:$asdf_bin_dir:$PATH"

which node
"$asdf_shims_dir/node" "$@"
