# Setting up your Inventory file

Bolt utilizes a few core configuration files to maintain the chaos of trying to managing a vast amount of systems, tasks, connection and more. The `bolt.yaml` file contains helpful information about the module path (where you can find all your usable code) and other global settings, such as where to find the inventory file.

## Creating an Inventory file

An inventory file is a YAML document that contains either a static list of your servers divided into groups or potentially utilizes plugins to dynamically collect all of your servers. The plugin system is customizable, so you can use it for providers such as AWS, Azure, Google Cloud, Terraform state files or even querying the puppetDB service if you are using Puppet Enterpise. For the purposes of this guide we will be using a static list, but I will show an optional example for using the Azure inventory plugin.

## Static Inventory File

From your project directory, open example_inventory.yaml.

    groups:
      - name: windows
        targets:
          - server1
          - server2
        config:
          transport: winrm
          winrm:
              user: Administrator
              password: Pass1word
              ssl: false

See we have a top key for groups, then a list of groups. In this example, we have only one group, `windows`. Underneath windows, we list our targets. This is a list of any servers you would like to target for the purposes of this guide. 

Following the servers, we need to give them configuration info. How are we connecting? WinRM. We list our Administrator credentials to log into the servers and specify ssl as false to run over insecure WinRM. That's not advisable for production use but you can adjust that setting if you have WinRM running properly.

That's all there is to a basic inventory. You can make those adjustments then save the file as `inventory.yaml` and from this point forward every bolt command you run in the project directory will reference this inventory file.

## Using the Azure Inventory plugin

    groups:
    - name: azure
        targets:
        - _plugin: azure_inventory
        client_id: <azure appId>
        tenant_id: <azure tenantId>
        client_secret: <azure password from azcli command>
        subscription_id: <azure id>
        resource_group: boltshop
        location: westus
        tags:
            project: boltshop
        config:
        transport: winrm
        winrm:
            user: <azure win admin username>
            password: <azure win admin password>
            ssl: <true or false depending on config>

Prerequisites:

* Run az ad sp create-for-rbac and copy the appId and password fields. These correspond to the client_id and client_secret parameters to the task.

* You will also need to know your subscription ID and tenant ID. If you're using the Azure CLI, you can retrieve these with az account show. These will be in the id and tenantId fields respectively.
Dynamic inventory with Azure:

## Wrap Up

The inventory file is an essential piece of managing your systems with Bolt. If you are following along, you have now created an inventory file that will be used to manage your servers for the duration of this guide.