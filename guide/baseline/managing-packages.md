# Managing Packages with Chocolatey and Plans

In this section, we'll become familar with installing packages using the puppet language. To keep it simple, we'll be 
leveraging a Windows package management solution called "Chocolatey". 

We will also take a look at a couple of awesome features called `facter` and `hiera`, which can be used across both Puppet and Bolt.

## What is Chocolatey?

## What is Facter?

"Facter is Puppet’s cross-platform system profiling library. It discovers and reports per-node facts, which are available in your Puppet manifests as variables." - Facter documentation

What does this mean? Well, facter runs as part of the puppet agent process. In our situation, facter is running during the `apply_prep` portion of the Bolt plans we are running. Facts are metadata about your system. There are a large amount of built-in facts such as `ipaddress`, `operatingsystem`, `domain` and the like. In addition to the built-in facts, you extend facter to include your own facts, which we will do below.

### Why build custom facts? 

Your business is probably a bit complicated, no? Everything has different locations, versions, owners, etc... and when you start bringing in a concept like infrastructure as code you need to know how to drop the right code on the right systems. By extending facter, we can add vital business information to our systems to better define them, such as the team that owns the server, cost centers, application names and more. When combined with `hiera`, We can also supply specific **data** for each section we need to manage, and by separating our data from our code we can write once and solve for many. Let's take a look.

## What is Hiera?

Quick recap, **hiera** is a hierarchical data lookup service and **facter** is a metadata profiler. Facter sets the metadata and hiera looks up values per that metadata. Let's look at our configuration for hiera, which is located at `./hiera.yaml`:

    version: 5
    defaults:
      datadir: data
      data_hash: yaml_data

    hierarchy:
    - name: "Per-node data"                 
        path: "nodes/%{trusted.certname}.yaml"

    - name: "Server Type" # Uses custom facts.
        path: "server_type/%{facts.server_type}.yaml"
    
    - name: "Team"
        path: "team/%{facts.team}.yaml"
    
    - name: "Common Items"
        path: "common.yaml"

From the top:

1. We are running hiera version 5.
2. Our defaults have us keeping yaml formatted files in a ./data folder.
3. Our hierarchy goes from the bottom to the top. Common items are first (which apply to all), then we start using our facts to slice up our infrastructure. After common items comes the team name, then the server type, then just the node itself. 

By default, a hiera lookup for this data will pull from all these sources where it finds data and merge it together. That means I can give it a list of packages that all servers get, say Microsoft Edge (the nice chrome-y one, not that old thing) should be available on all servers. Then I can say "The DevOps team should also have git and Visual Studio Code on their systems" and place those packages in the Team YAML. Let's look at common.yaml and team/devops.yaml to get a look at what a hiera key/value pair looks like:

**common.yaml**

    ---
    windows::packages:
      - microsoft-edge

**team/devops.yaml**

    ---
    windows::packages:
      - git
      - vscode

If I have a server with a team fact of `devops`, I'll get all three packages. If I don't have a team fact, or if I have a different value for the team fact, say `finance`, I will not get git or vscode.

Now that we have those pieces together, we can now look at our bolt plan for managing packages, which takes one step further into the puppet language by using functions and an iterator (knowledge is power!).

    plan wsp::baseline::packages(
      TargetSpec $targets
    ) {
      apply_prep($targets)
      $jobs = apply($targets) {
          lookup('windows::packages').each |$pkg| {
            package { $pkg:
                ensure   => 'present',
                provider => 'chocolatey'
            }
          }
      }
      return $jobs
    }

Jump down to the apply block and you will first see a lookup function. Functions in Bolt/Puppet are formatted as command with parenthesis afterwards with the parameters within. Similar to the apply block itself, which is a function. `apply()` and `apply_prep()` are both functions, actually. They just refer to Bolt functions, specifically to handle running puppet code in our plans. The `lookup()` function runs inside the puppet code to drive looking up hiera values. 

In the apply block above, that lookup function is collecting all of the Windows packages we want installed, then running an iterator. In plain english, we're telling bolt:

*Find all the packages we need installed, then make sure each one is `present`. Also, use `chocolatey` to install them*

So now we have:

* A plan to grab all the packages per host and install them via Chocolatey.
* Data that lists all the packages per "slice" of our infrastructure.
* A configuration file telling the lookup function where to look for that data.

The last thing we need? A team fact!

## Exercise #1: Add a team fact

From your project directory, run `bolt task show wsp::set_fact`.

    wsp::set_fact - Creates a JSON task on a Windows Server.

    USAGE:
    bolt task run --targets <node-name> wsp::set_fact fact_name=<value> fact_value=<value>

    PARAMETERS:
    - fact_name: String[1]
        The name of the fact to create.
    - fact_value: String[1]
        The value of the fact to create.

Documentation rules, no? This task is a PowerShell script will set a custom fact for you. It creates a JSON file in the default fact lookup location on the server, which was created on our first `apply_prep()` at the beginning of the guide. We simply need to give it a fact_name and a fact_value.

From your project directory, run `bolt task run wsp::set_fact -t <one_of_your_servers> fact_name=team fact_value=devops`. We want to have only **one** server get the team fact so we can validate which packages were installed. When that is complete, run `bolt task run facts -t <the_same_server>`. You should see more information than I'm willing to paste into Markdown, so let's look at the relevant portion:

    "system32": "C:\\Windows\\system32",
    "system_uptime": {
      "days": 16,
      "hours": 400,
      "seconds": 1443596,
      "uptime": "16 days"
    },
    "team": "devops",
    "timezone": "Central Daylight Time",
    "uptime": "16 days",

There we go! Along-side our built-in fats like timezone, uptime, etc... is now a `team` fact with a value of `devops`. This is now available when we run further bolt plans with puppet code, so let's move on to...

## Exercise #2: Managing Packages

From your project directory, run `bolt plan run wsp::baseline::packages -t windows`. 

Once completed, we can validate the packages by using chocolatey. From your project directory, run `bolt command run 'choco list --lo' -t windows`.

If you look at the output from each server you should see a list of packages. Look for a server without the team fact, and you will see no Visual Studio Code or git installed:

        chocolatey 0.10.13
        chocolatey-core.extension 1.3.3
        microsoft-edge 81.0.416.72
        microsoft-edge-insider 79.0.309.54

Looking at the server that now has the team fact classifying it as belonging to the DevOps team:

        chocolatey 0.10.15
        chocolatey-core.extension 1.3.5.1
        DotNet4.5.2 4.5.2.20140902
        git 2.26.2
        git.install 2.26.2
        vscode 1.45.0
        vscode.install 1.45.0
        microsoft-edge 81.0.416.72
        microsoft-edge-insider 79.0.309.54
    
## Wrap Up

Now we can install packages from the Chocolatey public repository, and we can use facts and data from facter and hiera to classify and specify what is going where while only having to use one small piece of code. 