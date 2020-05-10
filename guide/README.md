# Windows Starter Pack for Bolt

## Table of Contents

| Section | Description |
|---------|-------------|
| [Working with Bolt](#working-with-bolt) | A quick run through using Bolt at the command line and setting up your environment to work with this guide.
| [Baseline Configuration Items](#baseline) | Learn the desired state approach creating a baseline for consistent server builds.
| [Windows Security](#security) | Firewalls, AV and GPOs aren't a problem for Puppet and Bolt. Learn how to manage security tools and apply policy with desired state.
| [Windows Updates](#windows-updates) | A patching primer for updating your Windows servers. 
| [Using DSC](#dsc) | Level up your PowerShell DSC with our tools.
| [Building an IIS Server](#building-an-iis-server) | Use a mix of desired state and tasks to building a Windows Web Server and deploy assets for a webpage.
| [Bringing in Chocolatey](#bringing-in-chocolatey) | Chocolatey is a great package management tool for Windows that integrates amazingly well in either task-based or desired state automation.
| [Bringing it all Together in Puppet Enterprise](#puppet-enterprise) | You've seen task and plan based automation. You've seen desired state applied. Now let's bring it together with continuous enforcement, RBAC, CI/CD and a graphical interface for reporting and task execution.

### [Working with Bolt](#working-with-bolt)
- [Installing Bolt](working-with-bolt/installing.md) 
- [Setting Up Your Inventory File](working-with-bolt/setup-inventory-file.md)
- [What can I do with Bolt?](working-with-bolt/what-can-i-do.md)
- [Using Puppet DSL in Bolt Plans](working-with-bolt/using-puppet-modules-and-code-in-bolt-plans.md)
- [Writing Tasks & Plans](working-with-bolt/writing-tasks-and-plans.md)
- [Documenting Tasks](working-with-bolt/documenting-tasks)
- [Using Puppet Forge Modules](working-with-bolt/using-the-forge.md)

### [Baseline Configuration Items](#baseline)
- [What is a Baseline Configuration?](baseline/what-is-a-baseline.md)
- [Managing Windows Power Settings](baseline/power-settings.md)
- [Adding a Scheduled Task](baseline/scheduled-task.md)
- [Setting the Logon Message](baseline/logon-message.md)
- [Managing Packages with Chocolatey](baseline/managing-packages.md)

### [Windows Security](#security)
- [Managing Windows Defender](baseline/windows-defender.md)
- [Managing Windows Firewall](security/managing-windows-firewall.md)
- [Exporting Group Policy into Puppet Resources](security/exporting-gpo.md)
- [Applying Security Policies](security/applying-security-policies.md)
- [Applying CIS Controls](security/applying-cis-controls.md)
- [Validating Ongoing Compliance in PE](security/cis-compliance.md)

### [Windows Updates](#windows-updates)

- [Deploying a WSUS Server](windows-updates/building-a-wsus-server.md)
- [Configuring WSUS Clients](windows-updates/configuring-wsus-clients)
- [Reporting Missing Updates](windows-updates/reporting-missing-updates.md)
- [Patching a Server](windows-updates/patching-a-server.md)
- [Rebooting a Server](windows-updates/rebooting-a-server.md)

### [Using DSC](#dsc)

- [Using PowerShell DSC in Bolt Plans](dsc/using-dsc-in-bolt-plans.md)
- [Mixing DSC with Tasks](dsc/mixing-dsc-with-tasks.md)


### [Building an IIS Server](#building-an-iis-server)

[Building and IIS Server](iis/building-an-iis-server.md)
[Deploying a an Application](iis/deploying-an-application.md)
  (use upload_files, then move to chocolatey and explain other tools)

### [Bringing in Chocolatey](#bringing-in-chocolatey)

  - [Intro to Chocolatey for Package Management](chocolatey/intro-to-chocolatey-for-package-management.md)
  - [Using Chocolatey in the Enterprise](chocolatey/using-chocolatey-in-the-enterprise.md)
  - [Installing Packages with Tasks](chocolatey/installing-packages.md)
  - [Managing Chocolatey Configuration with Plans](chocolatey/managing-chocolatey-configuration-with-plans)
  - [Creating an Internal Chocolatey Repository](chocolatey/creating-an-internal-repository)

### [Bringing it all Together in Puppet Enterprise](#puppet-enterprise)




