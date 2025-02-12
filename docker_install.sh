##########################################################
# Define user configuration variables
USER="macd"               # Username for the container
PASSWD=0221                  # Password (0 is likely a placeholder, update as needed)
docker_images_name="runqmeu_img:latest"  # Name and tag for the Docker image (lowercase only)
docker_container_name="runqemu"    # Name for the Docker container (lowercase only)
docker_workspace_path="/home/$USER/test_qemu"  # Workspace path inside the container
##########################################################


# Extract the SDK tarball
# sudo tar xvf en.SDK-x86_64-stm32mp1-openstlinux-6.6-yocto-scarthgap-mpu-v24.11.06.tar.gz
# # Extract the sources tarball
# sudo tar xvf en.SOURCES-stm32mp1-openstlinux-6.6-yocto-scarthgap-mpu-v24.11.06.tar.gz  

# Build the Docker image
# Pass the user, password, and workspace path as build arguments
# Use the specified image name and tag

docker build --build-arg USER=$USER  --build-arg PASSWD=$PASSWD \
--build-arg WORKSPACE_PATH=$docker_workspace_path --no-cache  -t $docker_images_name .


# Check if the device exists
echo "starting Docker container..."
docker run -itd -v "$(pwd)":$docker_workspace_path \
    --network host \
--cap-add NET_ADMIN --device /dev/net/tun \
    -w $docker_workspace_path --user $USER \
    --name $docker_container_name $docker_images_name


#

# 在容器內執行命令
docker exec -it $docker_container_name bash -c "
    cd $docker_workspace_path &&
    echo $PASSWD | sudo -S chown -R $USER:$USER $docker_workspace_path &
    sleep 2 && echo -e ' \nChanging ownership, please wait...\n' &&
    wait &&
    echo 'Setup complete!' &&
    bash
"

