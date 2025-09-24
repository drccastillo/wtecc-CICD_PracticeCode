# Intro to CI/CD Practice Code

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Python 3.9](https://img.shields.io/badge/Python-3.9-green.svg)](https://shields.io/)
[![Docker](https://img.shields.io/badge/Docker-Enabled-blue.svg)](https://www.docker.com/)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI%2FCD-green.svg)](https://github.com/features/actions)

This repository contains the practice code for the labs in **IBM-CD0215EN-SkillsNetwork Introduction to CI/CD** with **Docker deployment automation** using GitHub Actions.

## 🚀 Features

- ✅ **Complete CI/CD Pipeline** with GitHub Actions
- ✅ **Docker Containerization** with optimized multi-stage builds
- ✅ **Automated Testing** (unit tests, linting, code formatting)
- ✅ **Docker Hub Deployment** using Personal Access Tokens (PAT)
- ✅ **Security Scanning** with Trivy vulnerability scanner
- ✅ **Multi-platform builds** (linux/amd64, linux/arm64)

## 📦 Docker Deployment

This project includes automated Docker image building and deployment to Docker Hub:

### 🏃 Quick Start
1. **Fork this repository**
2. **Configure GitHub Secrets**:
   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_TOKEN`: Your Docker Hub Personal Access Token
3. **Push to main branch** → GitHub Actions builds and deploys automatically!

### 🐳 Using the Docker Image
```bash
# Pull the latest image
docker pull dcastillo1/wtecc-cicd:latest

# Run locally
docker run -p 8000:8000 dcastillo1/wtecc-cicd:latest

# Test the application
curl http://localhost:8000/health
```

### 🔧 GitHub Actions Workflow
The automated workflow includes:
- **Testing**: Unit tests, linting (flake8), formatting (black)
- **Building**: Multi-platform Docker image build
- **Deployment**: Push to Docker Hub with proper tagging
- **Security**: Vulnerability scanning with Trivy

## 📚 Lab Contents

- Lab 1: [Build an empty Pipeline](labs/01_base_pipeline/README.md)
- Lab 2: [Adding GitHub Triggers](labs/02_add_git_trigger/README.md)
- Lab 3: [Use Tekton CD Catalog](labs/03_use_tekton_catalog/README.md)
- Lab 4: [Integrate Unit Test Automation](labs/04_unit_test_automation/README.md)
- Lab 5: [Building an Image](labs/05_build_an_image/README.md)
- Lab 6: [Deploy to Kubernetes](labs/06_deploy_to_kubernetes/README.md)

## 🔐 Docker Deployment Setup

For detailed instructions on configuring Docker deployment with GitHub Actions, see:
**[DOCKER-DEPLOYMENT-GUIDE.md](DOCKER-DEPLOYMENT-GUIDE.md)**

### Required GitHub Secrets:
- `DOCKER_USERNAME` - Your Docker Hub username
- `DOCKER_TOKEN` - Your Docker Hub Personal Access Token (not password!)

### Deployment Triggers:
- **Push to `main`** → Build, test, and deploy with `latest` tag
- **Push to `develop`** → Build, test, and deploy with `develop` tag  
- **Pull Request to `main`** → Run tests only (no deployment)
- **Tags `v*.*.*`** → Build and deploy with version tags

## 🏗️ Application Structure

```
├── .github/workflows/
│   └── docker-workflow.yml    # GitHub Actions CI/CD pipeline
├── service/                   # Flask application
│   ├── __init__.py
│   ├── routes.py             # API endpoints
│   └── common/               # Common utilities
├── tests/                    # Unit tests
├── Dockerfile               # Optimized Docker configuration
├── .dockerignore           # Docker build optimization
├── requirements.txt        # Python dependencies
└── README.md              # This file
```

## 🧪 Local Development

```bash
# Install dependencies
pip install -r requirements.txt

# Run tests
python -m nose tests/

# Run application locally
python -m gunicorn service:app --bind 0.0.0.0:8000

# Test endpoints
curl http://localhost:8000/
curl http://localhost:8000/health
```

## 🎯 Learning Objectives

- Understanding CI/CD pipeline concepts
- Docker containerization best practices
- GitHub Actions workflow automation
- Secure secrets management
- Automated testing and deployment
- Container registry integration

## Instructor

John Rofrano, Senior Technical Staff Member, DevOps Champion, @ IBM Research

---

## <h3 align="center"> © IBM Corporation 2022. All rights reserved. <h3/>

**Enhanced with Docker deployment automation by GitHub Copilot - 2025**