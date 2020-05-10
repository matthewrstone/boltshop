# Managing Windows Power Settings

In this section we will configure a component of Windows power settings. One of the minor items that pops up when creating a base image or baseline profile is disabling hibernation. Hibernation settings are merely registry keys, so in this exercise we will use Puppet DSL **registry** resource to manage the key with a Bolt Plan

## Exercise #1

  1. Open `plans/baseline/windows.pp` in Visual Studio Code. We will be building our baseline by uncommenting existing code blocks here.

  2. Uncomment lines 10-14. Puppet DSL allows you to keep comments in your code using `#` at the beginning of the line, so as you can see I've given a description of what this registry key will manage and a link to the supporting documentation for managing registry keys.

  3. Save windows.pp. If the vscode puppet plugin detects any errors, please read and resolve them before continuing.

  4.  From your powershell prompt in the repo root directory, run `bolt plan run wsp::baseline::windows -t windows`
  
  5. We will see results listed as changed, skipped or failed items. This is a summary report. Example:

    Starting: plan wsp::baseline::windows
    Starting: install puppet and gather facts on dc01.puppetdemos.com, dc02.puppetdemos.com
    Finished: install puppet and gather facts with 0 failures in 41.19 sec
    Starting: apply catalog on dc01.puppetdemos.com, dc02.puppetdemos.com
    Finished: apply catalog with 0 failures in 41.37 sec
    Finished: plan wsp::baseline::windows in 1 min, 23 sec
    Finished on dc01.puppetdemos.com:
      changed: 0, failed: 0, unchanged: 2 skipped: 0, noop: 0
    Finished on dc02.puppetdemos.com:
      changed: 0, failed: 0, unchanged: 2 skipped: 0, noop: 0
    Successful on 2 targets: dc01.puppetdemos.com,dc02.puppetdemos.com

  Things to note from this example plan run:

  1. In my case the status is unchanged, as I have *already configured* these settings, be it via GPO, script, manual, etc... That's the fun of idempotency. It handles the logic for you, so only makes changes if required.

  2. You see the first step is the `apply_prep`, which installs that puppet agent in a dormant state with dependencies then gathers facts. If you are new to Puppet, facts are metadata about your machine. They can either be internal things like what type of CPU, ip address, memory usage, etc... or can be customized to your desire, say for application team, what cost center the server belongs to, what update window it belongs in, etc... By using facts, you can write your code once and have it apply in many different situations by taking additional action or filling in specific data for the facts that are returned.