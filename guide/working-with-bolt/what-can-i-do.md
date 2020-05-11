# What can I do with Bolt?

Bolt is an incredibly versatile tool. You can do anything from run a simple command to process incredible complex workflows and just about anything in between. Here's a brief summary of the typical actions performed at the command line.

| Action | Description | Example |
|--------|-------------|---------|
|bolt command| Runs a single command against target(s). Defaults to PowerShell | `bolt command run "Install-WindowsFeature Web-WebServer" -t web_servers"` would install IIS on a list of web_server targets.
|bolt script| Runs a script in any language against target(s). *Note: The remote host must be able to execute that script. Something like running a Python script on Windows without Python installed on the target will not work.* | `bolt script run `
|bolt task| Run a task, which is a script on guardrails essentially. Deeper explanation in a few sections. | `bolt task run mymodule::mytask --targets localhost` runs your task against your local system.
|bolt plan| Run a plan, which is an orchestrated workflow made up of commands, scripts, tasks, plans and/or even puppet DSL code.| `bolt plan run mymodule::myplan --targets dc01` runs the plan against a single system.

After you run `bolt` with `command`, `script`, `task`, or `plan`, you can also show what's available on your system by using `show` instead of `run`. For example:

| Action | Description |
|--------|-------------|
|`bolt plan show`| Shows all available plans on your system.
| `bolt task show myproject::mytask` | Shows documentation/parameters for the `myproject::mytask` task.

Bolt also has the ability to upload files and other items that we will cover throughout the course. To upload a file, run 

    bolt file upload <source> <destination> --targets <target_name(s)>

## Wrap Up

Bolt can do a lot of things. From simple commands to advanced workflows and everything in between. We looked at the basic command structure and syntax and are now ready to move into learning about what we'll be doing with those commands.