##########################################################
# Define user configuration variables
USER="macd"               # Username for the container
PASSWD=0221                  # Password (0 is likely a placeholder, update as needed)
docker_images_name="runqmeu_img:latest"  # Name and tag for the Docker image (lowercase only)
docker_container_name="runqemu"    # Name for the Docker container (lowercase only)
docker_workspace_path="/home/$USER/test_qemu"  # Workspace path inside the container
##########################################################
# Run the Docker container
# Map the current directory to the workspace path inside the container
# Set the working directory and run the container as the specified user
# Assign the container the specified name



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