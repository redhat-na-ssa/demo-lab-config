# Containerfile

This Containerfile builds a fedora container with podman in to execute the functions in this repo, like list_images.sh, on a Mac.

```
# build the container from the root dir of this repo
podman build -t macos_arm --arch=amd64 components/containers/macos

# run the container locally from the door dir of this repo
podman run -it --rm -v $(pwd):/data localhost/macos_arm 

# list the data dir in the container
cd data && ls -l

# source functions
source scripts/functions

# check if oc installed
bin_check oc

# run the script to list the images for software
./scripts/wip/image_list.sh

```