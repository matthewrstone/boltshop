# Writing Tasks and Plans

This is a quick summary of writing tasks and plan and why to do either. For a full reference of writing either, please visit [Writing Tasks](https://puppet.com/docs/bolt/latest/writing_tasks.html) or [Writing plans in Puppet language](https://puppet.com/docs/bolt/latest/writing_plans.html) at our website.


## What is a Task?

A task is just that. A task. Think of a single thing you want to perform. This is a task. I prefer to think of a task as the smallest unit of action. Install an application. Get user info. Create a user. Reboot a system. These are all single issues to resolve, even though they might require a few lines of code.

This sounds fairly similar to a script, where you would dump all of your actions and maybe some conditional logic into one file and run it. As a matter of fact, you can make a script a task by simply dumping it into the `tasks` folder of your project. It's an easy way to start sharing scripts with the rest of the company.

Easy isn't always best, though. In a lot of Windows teams there can be a wide disparity between GUI-driven administrators and the admins that live and breathe PowerShell for everything. If there's a 500 line script and the end user doesn't know PowerShell, how are they to know what it actually is or does? In PowerShell, you can create help documentation for those users. In Bolt, you can do similar, but with JSON file that describes the tasks and provides all the input parameters to be validate.

The difference is with tasks, you can also add items like which implementation to use, meaning I can run a single task and have it execute either the PowerShell or Python version of a script. This allows you to think more holistically about your infrastructure by building a single task that solves a common issue for either side of the house.

## Exercise #1

From your PowerShell prompt, change location to this project directory. Run `bolt task show` and you will see a variety of tasks listed. Look for `boltshop::example` and you will find two tasks listed:

    boltshop::example1
    boltshop::example2                 The bird is the word.

Notice the first example has no description, while the second does. This is the difference between dropping a PowerShell script into the tasks folder vs. adding metadata. Let's drive a little further into these tasks:

    PS C:\Users\matthew\Code\boltshop> bolt task show boltshop::example1

    boltshop::example1

    USAGE:
    bolt task run --targets <node-name> boltshop::example1

    MODULE:
    C:/Users/matthew/Code/boltshop

Stunningly informative, right? If I passed this task to another person they'd know how to run it, which is the same as any other task, and where it is, which could be useful for trying to figure out what this actually does. Now let's look at the second example

    PS C:\Users\matthew\Code\boltshop> bolt task show boltshop::example2

    boltshop::example2 - The bird is the word.

    USAGE:
    bolt task run --targets <node-name> boltshop::example2 word=<value>

    PARAMETERS:
    - word: String
        This is the word.

    MODULE:
    C:/Users/matthew/Code/boltshop

Excellent, more information! We now know that the bird is the word and we have a parameter the explains we must enter a string. The example shows we have to enter the parameter in order for this script to work. So, let's run the task on our localhost: 

    PS C:\Users\matthew\Code\boltshop> bolt task run boltshop::example2 word=bird -t localhost
    Started on localhost...
    Finished on localhost:
        I am a task with inputs.
        Don't you know about the bird?
        Everybody knows that the bird is the word.
    Successful on 1 target: localhost
    Ran on 1 target in 1.19 sec

One thing to point out here: this should have run successfully wether you are on a Windows machine, a Mac or whatever Linux distro people are installing on their laptops these days. Tasks allows you to create a cross-platform task by using an `implementation` in your metadata. If we look at `tasks/example2.json`, you will see the implementation key along with the logic for what Bolt will do if it detects a *nix shell vs. detecting a Windows shell.

That's all there is to it. We ran a tasks that's really nothing more than PowerShell with some input validation and description added. You can feel free to play around with this task by changing the target or even changing the parameter to a different string, but let's be honest, everybody knows that the bird is the word.

Before we wrap up, let's look at that metadata file by opening `tasks/example2.json` in VS Code.

    {
        "description": "The bird is the word.",
        "parameters": {
            "word": {
                "type": "String",
                "description": "This is the word."
            }
        },
        "implementations": [
           { "name": "example2.sh", "requirements": ["shell"] },
           { "name": "example2.ps1", "requirements": ["powershell"] }
        ]
    }

It's pretty straight forward. We list a description, the implementations, the parameters, and the type of parameter we are looking for along with a description. We take advantage of using types here, so we can also list out options as well. That's brings us to...

## Exercise #2

Let's change that input and check it out. In VS Code, edit `tasks/example2.json` by changing the word paramter. TYPE should become `Enum["bird","other_bird"]`. For reference:

    {
        "description": "The bird is the word.",
        "parameters": {
            "word": {
                "type": "Enum["bird", "other_bird"]",
                "description": "This is the word."
            }
        },
        "implementations": [
           { "name": "example2.sh", "requirements": ["shell"] },
           { "name": "example2.ps1", "requirements": ["powershell"] }
        ]
    }

Save the file and let's run `bolt task show boltshop::example2`.

    PS C:\Users\matthew\Code\boltshop> bolt task show boltshop::example2

    boltshop::example2 - The bird is the word.

    USAGE:
    bolt task run --targets <node-name> boltshop::example2 word=<value>

    PARAMETERS:
    - word: Enum['bird','other_bird']
        This is the word.

Now we can see the options we have, `bird` or `other_bird`. Try running `bolt task run -t localhost boltshop::example2 word=chicken`.

    PS C:\Users\matthew\Code\boltshop> bolt task run -t localhost boltshop::example2 word=chicken
    Task boltshop::example2:
       parameter 'word' expects a match for Enum['bird', 'other_bird'], got 'chicken'

Errors afoot! Chicken cannot be the word, only `bird` or `other_bird`. Let's try again with `bolt task run -t localhost boltshop::example2 word=other_bird`.

    PS C:\Users\matthew\Code\boltshop> bolt task run -t localhost boltshop::example2 word=other_bird
    Started on localhost...
    Finished on localhost:
        I am a task with inputs.
        Don't you know about the other_bird?
        Everybody knows that the other_bird is the word.
    Successful on 1 target: localhost
    Ran on 1 target in 1.04 sec

Success! Now we can give people a description of a task, a description of the parameters for that task along with what type of data we are looking for. These parameters pass straight into the `Param()` block in PowerShell, so you can just replicate them 1:1 at the top of your script and everything will pass through correctly. See the example in `tasks/example2.ps1`.

## Wrap Up

In this section we learned how to write and execute a task. This task can be something a simple as dropping a PowerShell script into the task folder or a maturing of that script into offering a description and input validate.

This can be very powerful as you can now consolidate on the tasks your team can use to do their jobs. If you deploy this code into Puppet Enterprise, you now also have a centralized location for people to execute this task, either via command line or graphical console, allowing everyone to be using the same version of the same script and get consistent results.