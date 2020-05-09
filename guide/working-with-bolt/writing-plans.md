# Writing Plans

This is a quick summary of writing plans for the purposes of this guide. For a full reference of writing plans, please visit [Writing plans in Puppet language](https://puppet.com/docs/bolt/latest/writing_plans.html) at our website.

## What is a Plan?

At it's most basic form, a plan is a list of steps to perform within Bolt's set of capabilities. This can be a whole variety of functions, but to keep it simple think about chaining a task, command, script or plan together with other tasks, commands, scripts, plans and execute them in order. 

Plans can be written in the puppet language or in YAML. For this guide we will be sticking to the puppet language, but for a quick example of a plan, I'll show you both. Say you need to perform the following task:

  - create a user
  - set password for user
  - add the user to a group

Assuming you had converted a few PowerShell scripts into tasks `usermgmt::create_user`, `usermgmt::set_password`, `usermgmt::add_to_group` with appropriate parameters for each, this might look like this in YAML:

    ---
    parameters:
      - name: targets
        type: TargetSpec
      - name: username
        type: String[1]
      - name: password
        type: String[1]
      - name: group
        type: String[1]
    steps:
      - name: create_user
        task: usermgmt::create_user
        targets: $targets
        parameters:
          username: $username
      - name: set_password
        task: usermgmt::set_password
        targets: $targets
        parameters:
          username: $username
          password: $password
      - name: add_to_group
        script: usermgmt::add_to_group
        targets: $targets
        parameters:
          username: $username
          group: $group

In puppet code, the same would look something like this:

    plan usermgmt::create(
        String[1] $username,
        String[1] $password,
        String[1] $group
    ) {
        run_task('usermgmt::create_user', $targets, username => $username)
        run_task('usermgmt::set_password,
                 $targets,
                 username => $username,
                 password => $password
        )
        run_task('usermgmt::add_to_group',
                 $targets,
                 username => $username,
                 group    => $group
        )
    }

So a few less lines, but using a language vs. a data structure gives us some advanced capabilities. The one we'll be focusing in is the ability to drop code from puppet (the tool) into Bolt plans, which gives you the power of desired state but in an ad-hoc fashion.

This is where you really can get the quickest value out of the entire tool stack, as you can affect change quickly and consistently without having to worry about writing a PowerShell script that has conditionals for every single thing that might go wrong if you run it more than once. Puppet DSL code is idempotent, so you can run it against a target host 1,000 times and get the same result, which would be `unchanged` unless the resources you are managing need to be altered to become compliant with your code. Then they will register as `changed` and put into compliance.

From here on out we will be spending most of our time in exercises with this concept of using puppet code inside of Bolt as it allows for desired state configuration, has a community repository of around 6,000+ modules at your disposal and frankly is a lot easier to write once you get the concepts down. Puppet language can be as simple or as complex as you want to make it, so we'll keep it simple for the guide and give you resources to grow from there.