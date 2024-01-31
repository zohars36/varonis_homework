# Open REST API for Restaurants

## Introduction

The Worldwide Open REST API is a globally accessible service that provides a comprehensive list of restaurants based on specific criteria. This service is ideal for users looking to find restaurants that match their preferred style, vegetarian options, opening hours, and delivery services.

## Features

- **Filter by Cuisine Style:** Choose from various cuisine styles like Italian, Chinese, etc.
- **Vegetarian Options:** Specify if you prefer vegetarian options.
- **Opening Hours:** Select restaurants based on their opening hours, or simply use "now" to find currently open restaurants.
- **Delivery Services:** Find out if the restaurant offers delivery services.

## Usage

### Payload Structure

To use the API, send a POST request with the following payload structure. All fields are required:

```json
{
  "style": "<cuisine style>",
  "vegetarian": "<yes/no>",
  "open_hour": "<hour or 'now'>",
  "does_deliveries": "<yes/no>"
}
```

# Technical Details

This document provides an overview of the technical aspects of our system, highlighting key components and technologies used in its design and implementation.

## System Architecture

- **Cloud-Native Design**: Our system is architected to be Azure Cloud Native, leveraging the robust, scalable, and flexible infrastructure provided by Microsoft Azure. This design choice ensures high availability, scalability, and a seamless integration with various Azure services.

## Application Development

- **Programming Language**: The application is developed in Python, known for its simplicity and efficiency. Python's vast ecosystem of libraries and frameworks makes it an ideal choice for rapid development and deployment.

## Deployment

- **Azure App Service**: The application is deployed on Azure App Service, a fully managed web hosting service. This platform enables us to quickly build, deploy, and scale web apps without worrying about the underlying infrastructure.

## Data Storage

- **Azure Table Storage**: We utilize Azure Table Storage for storing the history of requests and responses. This NoSQL data service provides a key/attribute store with a schema-less design, which allows us to store complex data sets in a cost-effective and highly available manner.

# Initialization Setup

This document outlines the steps required to set up your project in Azure DevOps. Follow these instructions to create a dedicated project and configure service connections.

## Step 1: Create a Dedicated Project

1. Log in to your Azure DevOps organization.
2. Create a new project dedicated to your work. Ensure it's configured with the necessary permissions and settings.

## Step 2: Set Up Service Connections

Under your newly created project, establish the following service connections:

### Azure Resource Manager

- Navigate to the 'Service connections' section in your project settings.
- Create a new service connection for Azure Resource Manager.
- In addtion add role assignments:
  - **Key Vault Data Access Administrator**: This role will manage access to the Key Vault resources.
  - **Key Vault Secrets Officer**: This role will be responsible for creating and managing secrets in the Key Vault.

### GitHub Connection

- Set up a connection to GitHub to access your source code repository.
- Follow the prompts to authenticate and link your GitHub account.

## Step 3: Sign in to Azure from Your Local Desktop

**Note**: The scripts use a mix of PowerShell and Azure CLI, so ensure you have both installed and configured.

```bash
Connect-AzAccount
az login
```

### Step 4: Create Terraform Container for State Files

This step involves creating a Terraform container to hold the state files.

**Script to run:**

```powershell
./Create-RestApp-Setup.ps1

```

### Step 5: Create Variables Group and Pipelines in Azure DevOps

This step involves setting up a variables group and configuring pipelines in your Azure DevOps project for the deployment.

**Script to Run:**
You will need to execute the `Create-RestApp-Pipelines.ps1` script. Make sure to replace `<org_name>`, `<project_name>`, and `<service_connection_name>` with the appropriate values for your Azure DevOps organization, project, and service connection.

```powershell
./Create-RestApp-Pipelines.ps1 -org "<org_name>" -project "<project_name>" -serviceName "<service_connection_name>"
```

### Step 6: Run Pipeline "Rest App Infra - Apply"

In this step, you will execute the "Rest App Infra - Apply" pipeline in Azure DevOps. This pipeline is responsible for setting up the necessary infrastructure components.

**Pipeline to Run:**

- Navigate to your Azure DevOps project.
- Go to the Pipelines section.
- Find and run the pipeline named `Rest App Infra - Apply`.

**Expected Results:**
Upon successful execution of the pipeline, the following resources will be created:

1. **Storage Account with `restLogs` Table:**

   - A new Azure Storage Account is provisioned.
   - Within this storage account, a table named `restLogs` is created to store logs.

2. **Key Vault with Storage Account Connection String:**
   - An Azure Key Vault is set up.
   - The Key Vault is configured with the storage account's connection string for secure access.

### Step 7: Run Pipeline "Rest App Webapp - Apply"

This step involves executing the "Rest App Webapp - Apply" pipeline to set up a web application for your Python app in Azure.

**Pipeline to Run:**

- Navigate to your Azure DevOps project.
- Access the Pipelines section.
- Execute the pipeline named `Rest App Webapp - Apply`.

**Parameters to Set:**
When running the pipeline, set the following parameters:

- `envType=dev` (environment type, can be adjusted as per requirement)
- `instanceNo=1` (instance number, change as needed)

### Expected Outcome of Successful Pipeline Execution

Upon successfully running the pipeline, it will create specific resources in Azure, following a defined naming convention. These resources are critical for the infrastructure and configuration of the project.

#### Resources Created:

1. **Resource Group:**

   - A new Azure Resource Group will be created.
   - The naming convention for the Resource Group is `rest<envType>No<instanceNo>`.
     - `envType` is the environment type (e.g., `dev`, `prod`).
     - `instanceNo` is the instance number.
     - For example, for a development environment with instance number 1, the name would be `restdevNo1`.

2. **Terraform State (tfstate):**
   - A Terraform state file will also be created.
   - This tfstate file follows the same naming convention as the Resource Group.
   - It's used to keep track of the Terraform managed infrastructure and configuration.

**Example:**
If you run the pipeline with `envType=dev` and `instanceNo=1`, the created Resource Group will be named `restdevNo1`, and the tfstate file will also have the name `restdevNo1`.

**Note:**

- It is essential to ensure that the `envType` and `instanceNo` parameters are correctly set before running the pipeline to avoid any inconsistencies in resource naming.
- The Terraform state file is crucial for managing and maintaining the state of your infrastructure, so handle it securely and back it up regularly.

### Step 8: Run Pipeline "Rest WebApp - Deploy"

This step involves executing the "Rest WebApp - Deploy" pipeline, which deploys the web application in the specified environment.

**Pipeline to Run:**

- Go to your Azure DevOps project.
- Locate the Pipelines section.
- Select and run the pipeline named `Rest WebApp - Deploy`.

**Parameters to Set:**
Specify the following parameters when running the pipeline:

- `envType=dev` - This parameter sets the environment type to 'development'. Adjust this value based on your environment needs.
- `instanceNo=1` - This denotes the instance number. Change it according to the instance you are deploying to.

### Step 9: Testing the Application

To validate that the application is functioning correctly, perform a POST request using Postman.

**Testing Procedure:**

1. Open Postman on your computer.
2. Set up a new POST request to the following URL `<server_dns_url>/api/rest`
3. use the payload above.

## Cleanup Process

To ensure a proper cleanup and removal of all resources that were set up, follow these steps. This is important to avoid unnecessary costs and to maintain a clean environment.

#### 1. Run Pipeline "Rest Web Webapp - Destroy"

First, initiate the teardown of the web application infrastructure.

- Navigate to your Azure DevOps project.
- Access the Pipelines section.
- Find and execute the pipeline named `Rest Web Webapp - Destroy`.
- This pipeline will dismantle all resources associated with the web application.

#### 2. Run Pipeline "Rest App Infra - Destroy"

Next, proceed to remove the underlying infrastructure components.

- In the Pipelines section, locate and run the `Rest App Infra - Destroy` pipeline.
- This step ensures that all infrastructure components, such as the resource group, virtual machines, storage accounts, etc., are properly deleted.

**Note:** Be aware that running these pipelines will remove resources and data. Ensure that you have backed up any necessary information before proceeding.

#### 3. Delete Azure DevOps Project

Finally, if you wish to completely remove the project and all its configurations:

- Go to the Project Settings in your Azure DevOps portal.
- Find the option to delete the project and proceed with the deletion.
- Confirm the deletion when prompted.

**Warning:** Deleting the Azure DevOps project is an irreversible action. Ensure you truly want to remove all data and configurations associated with the project before doing so.

**Note:**

- It's a good practice to review the status of the resources in the Azure portal after running the destroy pipelines to confirm that all resources have been successfully removed.
- Deleting the Azure DevOps project should be the final step after you have confirmed the removal of all Azure resources.
