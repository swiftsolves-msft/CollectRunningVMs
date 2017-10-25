# CollectRunningVMs
Project to deploy and automate Runbook that will grabs active VMs and information and commit to NO SQL DB.

High level Usage Steps:

Create a Storage Account in a new ResourceGroup
                
                Create a new Table in the Storage account
                Record the names of the storage account, table, resource group, and subscription we will use these to populate the variables at the top of the script.
                
Create an Automation Account in the existing ResourceGroup
                
                Goto modules blade and click the Update Azure Modules Button (this may take 5 minutes to complete, modules created are 1.0.1 after update should have version 3.x.x)
                Goto modules blade and click on modules gallery, search and import the following module AzureRmStorageTable (May take a few minutes to import)
                Goto runbooks blade and create a new runbook choose a blank Powershell runbook
                Edit the runbook and copy the code from the script and update the variables (storage account, table, resource group, and subscription) at beginning of script to match your environment
                Click on Test to test the runbook to ensure it runs without error successfully.
                Click on Publish to publish the Runbook
                Click on Schedule to create a new schedule to run hourly and reoccurring, I set mine to run in the middle of the hour @ :30
                Use Azure Storage Explorer to examine the data in the Storage Tables 
