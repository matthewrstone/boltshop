# Managing Windows Power Settings

## Summary

In this walkthrough we will configure a component of Windows power settings. One of the minor items that pops up when creating a base image or baseline profile is disabling hibernation. Hibernation settings are merely registry keys, so in this exercise we will use Puppet DSL **registry** resource to manage the key with a Bolt Plan

## Steps

  1. Open `plans/baseline/windows.pp` in Visual Studio Code. We will be building our baseline by uncommenting existing code blocks here.

  2. Uncomment lines 10-14. Puppet DSL allows you to keep comments in your code using `#` at the beginning of the line, so as you can see I've given a description of what this registry key will manage and a link to the supporting documentation for managing registry keys.

  3. Save windows.pp. If the vscode puppet plugin detects any errors, please read and resolve them before continuing.

  4.  From your powershell prompt in the repo root directory, run `bolt plan run wsp::baseline::windows -t windows`