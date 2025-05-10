
# README for Dev Container Configuration

  

## Overview

  

This repository contains a development container setup for working with Terraform, Azure CLI, Go, Python, and Docker-in-Docker. The configuration leverages Visual Studio Code's Dev Containers feature to provide a consistent and isolated development environment.

  

## Dev Container Configuration

  

The development container is defined in the `.devcontainer` directory and uses a base image from Microsoft along with several features to add necessary tools and configurations.

  

### `devcontainer.json` Configuration

  

```json

{

"name": "Terraform",

"image": "mcr.microsoft.com/devcontainers/base:jammy",

"features": {

"ghcr.io/devcontainers/features/azure-cli:1": {},

"ghcr.io/devcontainers/features/go:1": {},

"ghcr.io/devcontainers/features/python:1": {},

"ghcr.io/devcontainers/features/docker-in-docker:2": {},

"ghcr.io/devcontainers/features/terraform:1": {}

},

"remoteUser": "vscode"

}
```
  

## Features Included

  

Azure CLI: Provides the Azure Command-Line Interface for managing Azure resources.

Go: Adds support for the Go programming language.

Python: Adds support for the Python programming language.

Docker-in-Docker: Allows Docker to be run within the container.

Terraform: Adds support for Terraform for infrastructure as code.

  

## Using the Dev Container

  

To use this development container configuration, follow these steps:

  

 1. Clone the Repository:
 
```
sh
git clone https://github.com/your-repo.git
cd your-repo
```
  
 2. Open in Visual Studio Code:


 - Open Visual Studio Code and navigate to the cloned repository.
 - If the Dev Containers extension is installed, you will be prompted to    reopen the folder in a container. Accept the prompt.

  
 - Reopen in Container:

 - If not prompted automatically, open the Command Palette (Ctrl+Shift+P
   or Cmd+Shift+P on macOS) and select **Dev Containers: Reopen in
   Container.**

 - Choose the appropriate folder for the desired scenario. For example,
   to use the Terraform container, select the `.devcontainer/terraform`
   folder.

  

## Customizing the Dev Container

  

If you need to customize the development container, you can modify the devcontainer.json file and rebuild the container.

## Notes

  

 - The remoteUser is set to vscode to enhance security while maintaining sufficient permissions for development tasks.
 - Ensure that you have Docker installed on your machine to use Docker-in-Docker feature.

  

## Additional Information

  

For more details on Dev Containers, visit the [Dev Containers documentation](https://code.visualstudio.com/docs/devcontainers/containers).
