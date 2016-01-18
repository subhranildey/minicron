#!/bin/bash
set -e

VERSION="0.8.4"

echo "Installing mincron v$VERSION"
echo "OS input as $OS"

echo "Checking user authorization"
SUDO="sudo"
if [[ "$EUID" -eq "0" ]]; then #is root
	SUDO=""
elif ! hash sudo 2>/dev/null; then # no sudo
	echo "This script needs to be run as root user or sudo to be installed. Aborting ..."
	exit
fi

DOWNLOAD_FILE="https://github.com/jamesrwhite/minicron/releases/download/v$VERSION/minicron-$VERSION-$OS.zip"
# DOWNLOAD_FILE="http://localhost:8000/minicron-$VERSION-$OS.zip"
TMP_ZIP_LOCATION="/tmp/minicron-$VERSION-$OS.zip"
TMP_DIR_LOCATION="/tmp/minicron-$VERSION-$OS"
LIB_LOCATION="/opt/minicron"
BIN_LOCATION="/usr/local/bin/minicron"

echo "Downloading minicron to $TMP_ZIP_LOCATION"
(cd /tmp; curl -sL $DOWNLOAD_FILE -o $TMP_ZIP_LOCATION)

echo "Removing $TMP_DIR_LOCATION and extracting minicron from $TMP_ZIP_LOCATION to $TMP_DIR_LOCATION"
(cd /tmp; rm -rf $TMP_DIR_LOCATION; unzip -q $TMP_ZIP_LOCATION)

echo "Removing archive $TMP_ZIP_LOCATION"
rm $TMP_ZIP_LOCATION

echo "Removing $LIB_LOCATION and creating $LIB_LOCATION (may require password)"
$SUDO rm -rf $LIB_LOCATION && $SUDO mkdir -p /opt/minicron

echo "Moving $TMP_DIR_LOCATION to $LIB_LOCATION (may require password)"
$SUDO mv $TMP_DIR_LOCATION/* $LIB_LOCATION

echo "Removing $TMP_DIR_LOCATION"
rm -rf $TMP_DIR_LOCATION

echo "Removing $BIN_LOCATION and linking $BIN_LOCATION to $LIB_LOCATION/minicron (may require password)"
$SUDO rm -f $BIN_LOCATION && $SUDO ln -s $LIB_LOCATION/minicron $BIN_LOCATION

echo
echo "done!"
