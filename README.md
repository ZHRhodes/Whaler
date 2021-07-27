![Logo_Lock_Transparent](https://user-images.githubusercontent.com/12732454/126949778-df08d3b0-5233-42d7-9757-c4652e0bdbff.png)

# Whaler

This repo contains the native Mac client app for the Whaler platform. It's a UIKit-based native Mac app built using Catalyst.
 
## What is Whaler? 

Whaler is a platform consisting of a native mac app and a [Go backend](https://github.com/ZHRhodes/Whaler-api). The goal is to enable real time sales outreach collaboration right on top of the organization's Salesforce data. This is accomplished by allowing the user to sign in to their organization's Salesforce, importing subsets of their data into the frontend app, and enhancing that data with additional constructs that power our features. 

These features include: 
* Kanban-style progress tracking for accounts and contacts
* Per-account tasks feature with ability to create, edit, set due date, and complete tasks
* Assign accounts, contacts, and tasks to users within your organization
* Real time collaborative editor for account notes, communicating over websockets with operational transform conflict resolution
* Real time data model updates over websockets

![Ultra HD (4K)](https://user-images.githubusercontent.com/12732454/127083623-79726f79-0079-47c7-95cc-ee26a9097832.jpg)

## Whaler Technical Overview 

Looking at the whole picture, this repo consists of the right half of this diagram:

![Whaler Technical Overview](https://user-images.githubusercontent.com/12732454/126923083-f529c8ba-a43b-49d5-976d-745047c1a230.png)

First, let's get a visual from thirty thousand feet:

<img width="2063" alt="Mind Map 9" src="https://user-images.githubusercontent.com/12732454/127088508-209a0cc9-ae57-44dd-8c89-b768002e9453.png">

Now let's dive into each piece and see how it all works together.

### Configuration

Whaler currently has two build configurations: Remote and Local. The Remote configuration sets the environment variable `API_URL` to point to the API running on Heroku. On the other hand, Local points that url to the user's own machine ([see here](https://github.com/ZHRhodes/Whaler-api/blob/master/README.md#running-locally)). `Configuration.swift` serves simply to store that environment variable string in the `Configuration.apiUrl` property. 

There is a third `Remote-copy` config that exists to make local development just a little bit easier. This configuration is the same as the Remote config except it changes the bundle identifier and adds an executable prefix. Because Whaler includes real time features between clients, there are times you need to open up multiple instances at once. Running the second one with this build config will keep them from colliding so macOS will let them both run at the same time. 

### Network Layer


