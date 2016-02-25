# Branch Cut Status

Initially designed to allow for quick and easy reporting during Branch Cut. Now, it is used for general status reporting. 

## Features

* Quick "Building" & "SUCCESS" or "FAILURE" status for Deploy and Review jobs that Delivery DevOps should see
* Editing of the links that are used to check status via the browser
* ELK links to help find the cause of problems in the CI pipeline
* Login for controlling access to link changes
* All in One page for viewing all build status at once
* Serialized build status for instant page loads regardless of network issues or slow server page loads 

## Architecture

The "Branch Cut Status" application is extremely simple. So simple in fact, that it doesn't even use a full MVC web framework. It uses "Sinatra" a VC (view & controller) framework for Ruby. 

## File structure

* `branch_cut_report.rb` , is the startup script. When you run this with no args it will start up our app with logging directly to the console. When you login to the small VM that is hosting it, you will find a tmux session running for the "chefsolo" user. 
* **lib** contains a single library that handles connections to Jenkins
* **public** contains "css" which contains "styles.css" for pretty views
* **urls** has a single file called jobs.yaml. This is the file that lists the Jenkins report URLs. When someone uploads a change, this is the file that gets tweaked. 
* **views** contains all the files we use for display of the pages. Since they are all yaml, the layouts.yaml file allows for a footer, header, and side-bar that is consistent.

## Release

* copy the code to our host VM's chefsolo home directory with the date in front E.G. `2015-05-15-branch_cut_report`. 

You can use 

```bash
`date +%F`-branch_cut_report
```
 
 as a simple shortcut.
 
* edit `branch_cut_report.rb` and uncomment the "set"s listed for listening on port 9000 and 0.0.0.0 
* stop the running copy
* unlink the old version 
* link the new version 
* run `branch_cut_report.rb`
* leave the tmux session and test the new code.

## Todo

[ ] Human readable status. At present, the machine running "branch_cut_status" must match the timezone of the Jenkins Masters to work properly as calculations are *relative*

[ ] Use "hover" to reduce clutter and keep status neat and clean

[ ] Introduce the team to this code so that we all can contribute to and maintain it.
