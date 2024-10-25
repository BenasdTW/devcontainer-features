#!/bin/sh
set -e


# The 'install.sh' entrypoint script is always executed as the root user.
#
# These following environment variables are passed in by the dev container CLI.
# These may be useful in instances where the context of the final 
# remoteUser or containerUser is useful.
# For more details, see https://containers.dev/implementors/features#user-env-var
echo "The effective dev container remoteUser is '$_REMOTE_USER'"
echo "The effective dev container remoteUser's home directory is '$_REMOTE_USER_HOME'"

echo "The effective dev container containerUser is '$_CONTAINER_USER'"
echo "The effective dev container containerUser's home directory is '$_CONTAINER_USER_HOME'"

apt-get update && apt-get install -y ripgrep fd-find python3-venv luarocks npm curl
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
tar -C /opt -xzf nvim-linux64.tar.gz

export PATH="$PATH:/opt/nvim-linux64/bin"
# RUN mv /opt/nvim-linux64/bin/nvim /bin/nvim
# Create config directory for LazyVim
mkdir -p /root/.config/nvim

# Clone LazyVim starter template
git clone https://github.com/LazyVim/starter /root/.config/nvim

# Install Neovim plugins
/opt/nvim-linux64/bin/nvim --headless +Lazy! sync +qa

rm -rf /root/.config/nvim
git clone https://github.com/BenasdTW/nvim-config.git /root/.config/nvim

# Install Neovim plugins
/opt/nvim-linux64/bin/nvim --headless +Lazy! sync +qa
/opt/nvim-linux64/bin/nvim --headless +LazyHealth +qa

cat > /opt/start.sh \
<< EOF
#!/bin/bash

# Infinite loop to restart the program when it exits
while true; do
    /opt/nvim-linux64/bin/nvim --headless --listen 0.0.0.0:8888
    echo "restarts nvim server" >&2
done
EOF
chmod +x /opt/start.sh


