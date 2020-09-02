#!/bin/sh
project=$1
if [ -z "$project" ]; then
    echo "unknow project"
    exit
fi

version="1.0"
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
DARK='\033[1;30m'
NC='\033[0m'

echo "${BLUE}${project} binary installer ${version}${NC}"
unameOut="$(uname -s)"

case "${unameOut}" in
Darwin*)
  arch=macos-amd64
  ;;
*)
  arch=linux-amd64
  ;;
esac
out_dir="/tmp/binary-installer"
url=$(curl -s https://api.github.com/repos/saltbo/${project}/releases/latest | grep "browser_download_url.*${arch}.tar.gz\"" | cut -d : -f 2,3 | tr -d '\"[:space:]')

echo "${DARK}"
echo "Configuration: [${arch}]"
echo "Location:      [${url}]"
echo "Directory:     [${out_dir}]"
echo "${NC}"

test ! -d "${out_dir}" && mkdir "${out_dir}"
curl -J -L "${url}" | tar xz -C "${out_dir}"

if [ $? -eq 0 ]; then
  "${out_dir}/${project}-${arch}/install.sh"
  echo "${GREEN}"
  echo "Installation completed successfully."
else
  echo "${RED}"
  echo "Failed installing ${project}"
fi

echo "${NC}"
