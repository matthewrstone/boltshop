# Using Puppet Forge Modules

The [Puppet Forge](https://forge.puppet.com) is a community collection of modules that allows you to extend the types of resources you can manage with puppet or bolt. As mentioned in the previous section, this code can work in puppet **or** bolt, so there is quite a bit of re-usability available. Towards the end of this guide we will look at what moving from a Bolt plan full of Puppet code to a Puppet profile that continuously enforces that configuration looks like.

In the meantime, let's get familiar with the Puppetfile. This project contains a sample Puppetfile of Windows modules you can play with. Example:

    mod 'puppetlabs-stdlib', '4.25.1'
    mod 'puppetlabs-chocolatey', '5.0.2'
    mod 'puppet-windowsfeature', '3.2.2'
    mod 'puppetlabs-registry', '2.1.0'
    mod 'puppetlabs-powershell', '2.3.0'

If you visit forge.puppet.com, you will find many modules. They will always have an author and a module name. You can see that referenced above. By clicking on the **Bolt** dropdown for installing the module on the Forge, you will see the lines formatted like above. We declare a module, the author/name combo of the module then the version we are using. We can also point to git repositories of customer code and even internal forges, but for the purposes of this guide we will stick to the Puppetfile we have here.

## Pulling in Forge Modules

For Bolt to apply puppet code on your infrastructure it must go through what is called an `apply_prep` process, where it installs the agent in a dormant state then copies all dependencies over to the server before running, followed by a cleanup process.

Those modules must exist on your client for them to transfer over to the targets. To download these modules, from the root of this project type `bolt puppetfile install`. They should all download to the modules/ folder.

If for some reason you get an SSL connect error (on Windows systems), please run `bolt plan run -t localhost wsp::cert_fix` to resolve that issue, then run `bolt puppetfile install` again.

## Wrap Up

At this point we have a project folder that now contains a variety of Windows modules we can use in either bolt or puppet to drive configuration on our servers. Let's start building!