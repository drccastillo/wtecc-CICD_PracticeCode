**Final Project: CI Pipeline with a Self-Hosted Agent** 

**Goal:** 

Students will set up a CI pipeline on GitHub with a self-hosted agent that pulls a Docker image, runs the container, and tests it with curl or cmd. 

**Requirements:** 

• GitHub repository with a Dockerfile and app code.   
• CI pipeline configuration (.github/workflows/final-project.yml).   
• Self-hosted runner with Docker installed.   
• DockerHub account with credentials stored as GitHub Secrets. 

**Pipeline Steps:** 

1 Checkout the repository from GitHub.   
2 Log in to DockerHub using GitHub Secrets.   
3 Build the Docker image from the repo.   
4 Push the image to DockerHub.   
5 Run the container from the image.   
6 Wait for the container to start.   
7 Test the container with curl.   
8 Stop and clean up the container. 

**Grading / Evaluation:** 

• 50%: Pipeline builds and pushes image successfully.   
• 20%: Container runs correctly on self-hosted agent.   
• 20%: Test succeeds with curl.   
• 10%: Code quality & proper use of secrets. 

**Stretch Goals (Optional):** 

• Test a specific response in the container (e.g., 'Hello, CI Pipeline\!').   
• Store logs as artifacts in GitHub Actions.   
• Extend the test to check on multiple operating systems (matrix builds). 

**Deliverables:** 

A working GitHub repository with the final project pipeline, Dockerfile, and application code that successfully passes the test.