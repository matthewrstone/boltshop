# Getting Familar with Puppet Automation for Windows

## Introduction

This guide is a Windows Starter Pack for automating Windows Server with Puppet. In it you will learn how to apply desired state configuration, import PowerShell and "put it on the guardrails", extending your scripts with input validation and shareability. You'll also learn how Puppet Enterprise levels up your automation experience by providing such features as a graphical console for reporting, role-based access controls, APIs for integration into other tooling and the ability to delegate and execute tasks or workflows on demand.

This is a 'hands-on' type of guide. While you can read through to get an understanding, in my experience it is best to get your hands dirty, as once you start seeing how quickly you can affect consistent and reliable change in your environment, you'll begin to see things in a new light.

## About Puppet

Puppet (the Company) develops a set of tools, both open source and commercial, that help you to automate many of the tasks or "workflows" required to manage your infrastructure. These tools include:

    * Bolt, an open source task runner and orchestation tool.
    * Puppet (the tool), an open source configuration management and compliance engine.
    * Puppet Enterprise, Puppet's commercial offering that pulls the Bolt and Puppet tools into a single interface with advanced reporting and role-based access capabilities.
    * Continuous Delivery for Puppet Enterprise, a continuous integration and deployment tool for your infrastructure code.

For this interactive guide, we will be mainly focusing on the Bolt tool to get started quickly and mature over time to examples within Puppet Enterprise.

## How do I write infrastructure code?

In this guide we will be working with Puppet's Declarative Style Language (DSL), a simple resource modeling method. We'll be doing this within Bolt, which means apply our code will be on demand vs. the continuous enforcement you receive from deploying puppet open source or Puppet Enterprise.

## What do I need to write infrastructure code?

It is highly recommended to install Bolt, Git, VisualStudio Code and the puppet plugin for VS Code in order to find the most success. You can literally write puppet code in notepad.exe, but I wouldn't recommend it.


## What infrastructure do I need to work through this guide?

I'd recommend 3 Windows Servers, 2016 or higher. Some of the examples will deal with setting up Active Directory, setting up WSUS server and client and setting up an IIS server. While you can pile these roles on top of each other on a single server, part of the fun of using Bolt is the ability to affect change on multiple servers at the same time.

If you wish to setup Puppet Enterprise and CD4PE, you will need to Linux VMs, and I would recommend 4 cores and 8GB of RAM. There are trial versions of both products and we will walk through bootstrapping your PE environment towards the end of the guide.

All servers should have outbound access to the Internet. It's not required for PE, but additional configuration is required to make all the pieces work, so let's keep it simple.

## Wrap Up

Ready to get started? Click [here](guide/README.md) to start the walkthrough and dip your toe into eliminating the soul crushing work in your day to day work.