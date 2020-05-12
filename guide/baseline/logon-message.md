# Set the Logon Message

In this section we will use the *puppetlabs-motd* module to change our logon message. MOTD might not make sense in a purely Windows world, as it's short for "Message of the Day", which typically is a file you set on a Linux system to have whatever message you require upon SSH login to the system. Usually that's system information or a very long disclaimer sent by legal, other times it's an ASCII cow. The choice is yours (or your legal department's)!

## Exercise #1

  1. Open `plans/baseline/windows.pp` in Visual Studio Code. We will be building our baseline by uncommenting existing code blocks here.

  2. Uncomment lines 34-40. Puppet DSL allows you to keep comments in your code using `#` at the beginning of the line, so as you can see I've provided a link to the supporting documentation for using the MOTD module.

  3. Save windows.pp. If the vscode puppet plugin detects any errors, please read and resolve them before continuing.

  4.  From your powershell prompt in the repo root directory, run `bolt plan run wsp::baseline::windows -t windows`
  
  5. We will see results listed as changed, skipped or failed items. This is a summary report. Example:

    Starting: plan wsp::baseline::windows
    Starting: install puppet and gather facts on dc01.puppetdemos.com, dc02.puppetdemos.com
    Finished: install puppet and gather facts with 0 failures in 21.12 sec
    Starting: apply catalog on dc01.puppetdemos.com, dc02.puppetdemos.com
    Finished: apply catalog with 0 failures in 21.47 sec
    Finished: plan wsp::baseline::windows in 1 min, 29 sec
    Finished on dc01.puppetdemos.com:
      changed: 1, failed: 0, unchanged: 0 skipped: 0, noop: 0
    Finished on dc02.puppetdemos.com:
      changed: 1, failed: 0, unchanged: 0 skipped: 0, noop: 0
    Successful on 2 targets: dc01.puppetdemos.com,dc02.puppetdemos.com

6. Make sure you are logged out from your previous RDP session and then log back into your managed server. You should now see a logon message before you are sent to the password prompt.

That's all there is to it. However, we just added a quick sentence. If you have a giant disclaimer, how would you add that without having a big messy paragraph in the middle of your code? Let's source a file!

## Exercise #2

1. Open `plans/baseline/windows.pp` in VS Code.
2. Add comments back to lines 34-40. You can do this by selecting all text on those lines and hitting `Ctrl-/`.
3. Uncomment line 5, then lines 43-46 and save the file.

Let's get a quick summary of what we are doing here. We have a file with the motd text stored in files/motd.txt. We can do one of two things here:

* upload the file to a folder, then point to it on the server.
* stream the contents of the file into the content parameter.

I like the second option as it doesn't clutter up your system with unnecessary files. In line 5, we are telling Bolt to read the contents of the file into the `$motd` variable. Then in like 44, instead of a string we are using that variable for the content.

4. From your powershell prompt in the repo root directory, run `bolt plan run wsp::baseline::windows -t windows`. Your logon message should now be changed and you can log out and back in to RDP to verify.

## Wrap Up

An interesting difference here between using Bolt and Puppet is that Puppet is agent-based and have a central *puppet master* to store your code and files. Part of the Puppet server capabilities is file serving, so we can store our file on the server and refer to the location as `puppet:///modules/wsp/motd.txt` and it will magically find our text file. We will see examples of that later in the Puppet Enterprise section, but for now reading files out of a repo like this is the best option.