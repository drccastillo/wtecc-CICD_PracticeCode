# Self-Hosted Runner Setup Guide

This guide will help you set up a self-hosted GitHub Actions runner for the Final Project CI Pipeline.

## 📋 Prerequisites

Before setting up a self-hosted runner, ensure you have:

- ✅ A machine (local computer, VM, or cloud instance) with:
  - **OS**: Linux (Ubuntu 20.04+ recommended), macOS, or Windows
  - **RAM**: Minimum 2GB (4GB+ recommended)
  - **Storage**: Minimum 10GB free space
  - **Network**: Stable internet connection
- ✅ **Docker** installed and running
- ✅ **Administrator/sudo access** on the machine
- ✅ **GitHub repository access** (admin or maintain permissions)

## 🚀 Quick Setup (Ubuntu/Linux)

### Step 1: Install Docker

If Docker is not already installed:

```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to docker group (to run docker without sudo)
sudo usermod -aG docker $USER

# Verify installation
docker --version
```

**Important**: Log out and back in for the docker group changes to take effect.

### Step 2: Configure the GitHub Runner

1. **Navigate to your GitHub repository**:
   ```
   https://github.com/YOUR_USERNAME/wtecc-CICD_PracticeCode
   ```

2. **Go to Settings → Actions → Runners**:
   - Click on **"New self-hosted runner"**
   - Select your operating system (Linux, macOS, or Windows)

3. **Download the runner**:

   GitHub will provide commands like these (use the exact commands from your repo):

   ```bash
   # Create a folder for the runner
   mkdir actions-runner && cd actions-runner

   # Download the latest runner package
   curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz

   # Extract the installer
   tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz
   ```

4. **Configure the runner**:

   ```bash
   # Create the runner and start the configuration
   ./config.sh --url https://github.com/YOUR_USERNAME/wtecc-CICD_PracticeCode --token YOUR_TOKEN

   # When prompted, provide:
   # - Runner name: (press Enter for default or choose a name like "linux-runner-1")
   # - Runner group: (press Enter for default)
   # - Labels: Add "linux" and "x64" (or press Enter for defaults)
   # - Work folder: (press Enter for default "_work")
   ```

5. **Start the runner**:

   ```bash
   # Run interactively (for testing)
   ./run.sh

   # OR run as a service (recommended for production)
   sudo ./svc.sh install
   sudo ./svc.sh start
   sudo ./svc.sh status
   ```

### Step 3: Verify Runner is Connected

1. Go to **Settings → Actions → Runners** in your GitHub repository
2. You should see your runner listed with a green "Idle" status
3. The runner should show labels like: `self-hosted`, `Linux`, `X64`

## 🔧 Update the Workflow to Use Self-Hosted Runner

Once your runner is set up and connected, update the workflow file:

### Edit `.github/workflows/final-project.yml`

**Before (GitHub-hosted):**
```yaml
jobs:
  build-and-push:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, ubuntu-20.04]
```

**After (Self-hosted):**
```yaml
jobs:
  build-and-push:
    runs-on: [self-hosted, linux, x64]
    # Remove the matrix strategy or keep it with self-hosted labels
```

**Hybrid approach** (use both):
```yaml
jobs:
  build-and-push:
    runs-on: ${{ matrix.runner }}
    strategy:
      matrix:
        include:
          - runner: ubuntu-latest
            name: GitHub-hosted
          - runner: [self-hosted, linux, x64]
            name: Self-hosted
```

## 🖥️ Platform-Specific Instructions

### macOS

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Docker Desktop for Mac
brew install --cask docker

# Follow Step 2 above for runner configuration
```

### Windows

```powershell
# Install Docker Desktop for Windows
# Download from: https://www.docker.com/products/docker-desktop

# Create runner directory
mkdir actions-runner; cd actions-runner

# Download runner (use PowerShell)
Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-win-x64-2.311.0.zip -OutFile actions-runner-win-x64-2.311.0.zip

# Extract
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.311.0.zip", "$PWD")

# Configure
./config.cmd --url https://github.com/YOUR_USERNAME/wtecc-CICD_PracticeCode --token YOUR_TOKEN

# Run
./run.cmd
```

## 🔐 Security Best Practices

### 1. **Runner Isolation**
- Don't run the runner as root/administrator
- Use a dedicated user account for the runner
- Consider using Docker containers or VMs for additional isolation

### 2. **Network Security**
```bash
# Configure firewall (Ubuntu/Debian)
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow from 192.30.252.0/22  # GitHub webhooks
sudo ufw allow from 185.199.108.0/22  # GitHub webhooks
```

### 3. **Regular Updates**
```bash
# Update runner periodically
cd ~/actions-runner
./config.sh remove --token YOUR_TOKEN
# Download latest version
curl -o actions-runner-linux-x64-LATEST.tar.gz -L [LATEST_URL]
tar xzf ./actions-runner-linux-x64-LATEST.tar.gz
./config.sh --url [YOUR_REPO] --token YOUR_TOKEN
```

### 4. **Restrict Repository Access**
- Only use self-hosted runners on **private repositories** or trusted public repos
- Enable "Require approval for all outside collaborators" in Settings → Actions

## 🧪 Testing Your Runner

After setup, test the runner with a simple workflow:

```bash
# Trigger the workflow manually
# Go to Actions → Final Project CI Pipeline → Run workflow
```

Or push a commit to trigger the workflow:
```bash
git commit --allow-empty -m "Test self-hosted runner"
git push
```

## 🐛 Troubleshooting

### Runner Not Connecting

```bash
# Check runner service status
sudo ./svc.sh status

# View runner logs
sudo journalctl -u actions.runner.* -f

# Restart runner service
sudo ./svc.sh stop
sudo ./svc.sh start
```

### Docker Permission Issues

```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Restart docker service
sudo systemctl restart docker

# Log out and back in
```

### Disk Space Issues

```bash
# Clean up Docker
docker system prune -a -f

# Check disk usage
df -h
du -sh ~/actions-runner/_work/
```

### Runner Offline

```bash
# Check network connectivity
ping github.com

# Check runner process
ps aux | grep Runner.Listener

# Manually restart
cd ~/actions-runner
./run.sh
```

## 📊 Monitoring and Maintenance

### Check Runner Status

```bash
# Service status
sudo ./svc.sh status

# View real-time logs
tail -f ~/actions-runner/_diag/Runner_*.log
```

### Resource Monitoring

```bash
# CPU and Memory usage
top

# Docker stats
docker stats

# Disk usage
df -h
```

### Cleanup Old Workflows

```bash
# Navigate to work directory
cd ~/actions-runner/_work

# Remove old workflow runs (be careful!)
rm -rf */  # Only if you're sure!
```

## 🔄 Runner as a Service (Production)

For production use, configure the runner to start automatically:

```bash
# Install as service
cd ~/actions-runner
sudo ./svc.sh install

# Start service
sudo ./svc.sh start

# Enable on boot
sudo systemctl enable actions.runner.*

# Check status
sudo ./svc.sh status
```

## 📚 Additional Resources

- [GitHub Actions: Self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners)
- [Docker installation guide](https://docs.docker.com/engine/install/)
- [Runner application releases](https://github.com/actions/runner/releases)
- [Autoscaling runners](https://docs.github.com/en/actions/hosting-your-own-runners/autoscaling-with-self-hosted-runners)

## ⚡ Quick Reference Commands

```bash
# Start runner service
sudo ./svc.sh start

# Stop runner service
sudo ./svc.sh stop

# Check runner status
sudo ./svc.sh status

# View runner logs
sudo journalctl -u actions.runner.* -f

# Uninstall runner service
sudo ./svc.sh uninstall

# Remove runner from GitHub
./config.sh remove --token YOUR_TOKEN
```

## 💡 Tips

1. **Use a dedicated machine**: Don't run on your development machine
2. **Monitor resources**: Keep an eye on CPU, memory, and disk usage
3. **Regular maintenance**: Update Docker and the runner regularly
4. **Backup configuration**: Save your runner configuration
5. **Use labels**: Add custom labels to organize multiple runners
6. **Consider cloud**: Use AWS, GCP, or Azure for scalable runners

---

**Need help?** Check the [Final Project README](README.md) or open an issue in the repository.
