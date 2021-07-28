![Logo_Lock_Transparent](https://user-images.githubusercontent.com/12732454/126949778-df08d3b0-5233-42d7-9757-c4652e0bdbff.png)

This repo contains the Mac client app for the Whaler platform, a UIKit-based native Mac app built using Catalyst.

![Ultra HD (4K)](https://user-images.githubusercontent.com/12732454/127083623-79726f79-0079-47c7-95cc-ee26a9097832.jpg)
 
## What is Whaler? 

Whaler is a platform consisting of a native mac app and a [Go backend](https://github.com/ZHRhodes/Whaler-api). The goal is to enable real time sales outreach collaboration right on top of the organization's Salesforce data. This is accomplished by allowing the user to sign in to their organization's Salesforce, importing subsets of their data into the app, and enhancing that data with additional constructs that power our features. 

These features include: 
* Kanban-style progress tracking for accounts and contacts
* Assign accounts, contacts, and tasks to users within your organization
* Per-account tasks feature with ability to create, edit, set due date, and complete tasks
* Real time collaborative editor for account notes, communicating over websockets with operational transform conflict resolution
* Real time data model updates over websockets

Before we get into the technical details, let's get familiar with the user interface.

| ![Screen Shot 2021-07-27 at 1 17 29 AM](https://user-images.githubusercontent.com/12732454/127120882-43cc93f1-c7ee-4775-bac8-bc1bbe4c8c78.png) | 
|:--:| 
| Authentication • _Users belong to an organization_ |

| ![Screen Shot 2021-07-27 at 1 10 26 AM](https://user-images.githubusercontent.com/12732454/127119812-c29321ae-3bee-4521-bff6-fafccee173ad.png) | 
|:--:| 
| Authentication • _Supports dark mode throughout_ |

| ![image](https://user-images.githubusercontent.com/12732454/127121535-3e4f4be3-712b-4271-90ae-3f2ae6ba5c4b.png) | 
|:--:| 
| Tracked Accounts • _Accounts are dragged across the kanban as they progress_ |

| ![image](https://user-images.githubusercontent.com/12732454/127121330-616ee34c-70a6-4ae8-8fb3-fa4a73632863.png) | 
|:--:| 
| Tracked Accounts • _Changes are synced automatically_  |

| ![paste (1)](https://user-images.githubusercontent.com/12732454/127116063-4406bb84-62ed-4fb8-9335-0ff24841eb8e.png) | 
|:--:| 
| Account Details • _Tasks with due dates can be added to accounts_ |

| ![image](https://user-images.githubusercontent.com/12732454/127120551-89ddce87-bcef-4cc4-aabc-b3c2129c1a42.png) | 
|:--:| 
| Account Details • _Note taking is collaborative and real-time_ |

| ![image](https://user-images.githubusercontent.com/12732454/127122282-161eadcc-17a1-40d3-b2ec-04b6def0b8ab.png) | 
|:--:| 
| Track/Untrack Accounts • _Multiple filters can be stacked and added to the Salesforce query_|

| ![image](https://user-images.githubusercontent.com/12732454/127122314-84cf889d-3329-4ebd-8a5b-e7fd880c6068.png) | 
|:--:| 
| Track/Untrack Accounts • _Multiple users can track the same account_ |

## Whaler Technical Overview 

Looking at the whole picture, this repo consists of the right half of this diagram:

![Whaler Technical Overview](https://user-images.githubusercontent.com/12732454/126923083-f529c8ba-a43b-49d5-976d-745047c1a230.png)

Let's start with a thirty-thousand foot view of the app codebase:

<img width="2063" alt="Mind Map 9" src="https://user-images.githubusercontent.com/12732454/127088508-209a0cc9-ae57-44dd-8c89-b768002e9453.png">

Now we'll go into the interesting bits of these components to see how it all works. 

### Configuration

<img width="700" alt="IMG_DA5BD9A32359-1 copy" src="https://user-images.githubusercontent.com/12732454/127229629-a086faec-1b15-464b-a787-345acfc42ab4.jpg">

Whaler currently has two build configurations: Remote and Local. The Remote configuration sets the environment variable `API_URL` to point to the API running on Heroku. On the other hand, Local points that url to the user's own machine ([see here](https://github.com/ZHRhodes/Whaler-api/blob/master/README.md#running-locally)). `Configuration.swift` serves simply to store that environment variable string in the `Configuration.apiUrl` property. 

There is a third `Remote-Copy` config that exists to make local development just a little bit easier. This configuration is the same as the Remote config except it changes the bundle identifier and adds an executable prefix. Because Whaler includes real time features between clients, there are times you need to open up multiple instances at once. Running the second one with this build config will keep them from colliding so macOS will let them both run at the same time. 

### Shared

<img width="700" alt="IMG_DA5BD9A32359-1 copy" src="https://user-images.githubusercontent.com/12732454/127230252-83386c51-c0ca-43e9-a8ac-eb2d16173ce9.jpg">

The shared folder contains protocols, views, view controllers, models, and helpers that have a general use-case throughout the app. For example, `TablePopoverViewController.swift` is a configurable popover that can be used for menus. It has no knowledge of any specific feature in the app, making it a good fit for this top level folder. These components can easily be borrowed and reused in other apps as well. 

It's worth mentioning one particular subdirectory: `Salesforce`. This contains a set of Swift structs that map to Salesforce objects as well as an interface for composing Salesforce Object Query Language (SOQL) requests. No objects or methods within this directory have any knowledge of our application logic or how it interacts with Salesforce. That logic can be found one level up in `SFHelper.swift`, which defines the Salesforce operations used by the app. This separation abstracts the Swift-Salesforce communication from the business logic, leaving us with a `Salesforce/` directory that could be dropped into any app that needs it. 

### Controllers

<img width="700" alt="IMG_DA5BD9A32359-1 copy" src="https://user-images.githubusercontent.com/12732454/127230281-abdd9675-9a15-4e13-b61c-f51ffb9d495c.jpg">

All the pages of the app can be found here. The current architecture is a simple ViewController-Interactor pattern, primarily chosen for simplicity and quick development. There aren't currently too many pages in the app, so there isn't much presentation logic cluttering up ViewControllers. In the future, as more pages would be added, it would be a good idea to consider adding a Coordinator to the pattern to handle presentation.

All layouts are done via programatic autolayout. A few simple `UIView` extensions in `UIView+Extension.swift` make setting constraints a breeze. 

### NetworkLayer

<img width="700" alt="IMG_DA5BD9A32359-1 copy" src="https://user-images.githubusercontent.com/12732454/127233278-28dd5ddb-cef1-4e2e-8e01-5e8dc309378e.jpeg">

All the networking implementations are contained in this folder. In particular, that includes websockets, GraphQL, and a plain networking interface for REST calls. 

#### Websocket

Websockets are currently responsible for delivering real-time document and model updates. Because a single websocket can transmit messages of various types, we have to decode them over several steps. The first is to decode every message into a `SocketMessage<T>` where `T == AnyCodable` and `struct AnyCodable: Codable {}`. This gives us the basic structure of all messages sent by our API while skipping decoding the data parameter.

```  
  var messageId: String = ""
  var type: SocketMessageType
  var data: T
```

The `type` property is an enum with cases like `docChange`, and `resourceUpdated`. We switch on the `type` to ultimately transform the message into an enum called `SocketMsg` (which has a renaming in its future). `SocketMsg` represents the message as `case messageType(value)`, making it easy for any delegate to just switch on the enum to handle the message they want. For clarity, here's an example of a `SocketMsg` case: `case docChange(DocumentChange)`.

Currently, the client uses websockets for two purposes: real-time model updates and collaborative note editing. 

##### Model Updates

Clients who wish to monitor changes in a particular API resource can do so by simpling telling the `WebSocketManager` to `registerConnection` with the id for the resource. The caller provides a delegate which can respond to a new connection, receive messages, and respond to being disconnected. That's great for observing objects with a clear root; an account contains contacts and tasks, and by observing the account, we can get notified if anything changes. Currently, the only unique case is observing all Accounts, such as on the main kanban page. What is a logical root id that we can use to observe to catch changes to all accounts in the organization? At least for now, this is done by observing the organizationId itself. That will give you updates to any Account tracked by any user in the organization. This design decision is an MVP trade-off prioritizing simplicity and could use further refinement down the road.

##### Collaborative note editing

For a breakdown of how the operational transform algorithm works, see the [API repo](https://github.com/ZHRhodes/Whaler-api/blob/master/README.md#ot). An instance of this app would function as a `Client`, as referred to in that write up. While for the API we could benefit from an existing Go OT implementation, there was no such luck in Swift. I had to port the Go implementation over to Swift myself. To help carry the torch, I open sourced that port here (link).

In addition to porting the implementation, I added cursor support to `OTDoc.swift`. To reuse as much as possible, cursors stored as a struct containing an id and a position. When ops are applied to the document, those same ops are also transformed against all the cursors necessary. More specifically, we create a series of ops that treat the cursor as a character:

```
   let retainToCursor = OTOp(n: cursor.position, s: "")
   let cursorOp = cursor.op
   let retainAfterCursor = OTOp(n: size - cursor.position, s: "")
```

These ops are not actually applied to doc. Instead, they are transformed against the incoming ops being applied to the document. The cursor struct is updated with the new position after the transformation. In this way, we leverage the existing `transform` function to do the math for us.

#### GraphQL

Whaler uses Apollo to manage GraphQL. Apollo uses a build phase to generate Swift code based on your `schema.json` file. This file needs to be redownloaded every time the schema is changed. Currently, that introspection request requires an access token, which means you need to generate one using the `/login` endpoint. This is a little tedius, but progress on automating has been started in the `apollodownload` script. Right now it asks for the token and then makes the download request for you.

Queries and mutations are defined in `*.graphql` files placed at the top level of the project. **Note:** Apollo automatically caches requests, but I often ran into trouble with Apollo incorrectly assuming my data hadn't changed since the last request. For that reason, I usually find it safer to just use the `fetchIgnoringCacheData` cache policy. I would be wary using the Apollo cache for anything that might change at all rapidly.

#### NetworkInterface

Finally, there's also a lightweight networking protocol defined in `NetworkInterface.swift`. This protocol defines interacting with an external resource. There are currently two concrete implementations: `APINetworkInterface` and `SFNetworkInterface` where `SF` stands for Salesforce. My Go API works a little differently than the Salesforce API, so this abstracts those differences into their own implementations of the basic networking functions. Each `NetworkInterface` accepts a `Networker`, a protocol that provides the ability to execute any `NetworkRequest`. In that way, the logic of interacting with APIs is abstracted from the execution layer of networking. 

### DataLayer

 <img width="700" alt="IMG_DA5BD9A32359-1 copy" src="https://user-images.githubusercontent.com/12732454/127229560-032b01b7-5432-41f6-a2e4-d0da31c2c7d3.jpg">

Whaler consumes data from multiple sources, and that access is abstracted behind a reactive repository layer, made using Combine. For each source, a `DataSource` class implements the various operations that can be performed on it. This would be things like `fetchSingle(with id: String)`, `saveAll`, etc. 

![Untitled Document - Copy](https://user-images.githubusercontent.com/12732454/127109754-937d364b-bc36-4f48-ac98-595050207e8e.png)

This provides a common pattern for where to find operations for particular data types. Let’s take it another step and address how they interact with each other.

The data _consumer_ should never have to worry about maintaining the different data sources. That type of work should be encapsulated within the data layer. Rather than have these data sources know anything about each other, there's an abstraction over top of them that will handle all of these types of operations. For each data type, there is one data interface.

![Untitled Document - Copy-2](https://user-images.githubusercontent.com/12732454/127110947-6905291b-6739-4211-8373-5bc298ff9368.png)

The data interface is where you can plug in different data sources and determine how they interact with each other. By encapsulating this type of work into this sublayer, it makes it incomparably easier to modify our data sources at any point in the future. That includes, for example, adding a different method of caching – it would just become another data source to use in the interface. The plug-and-play nature of these components allows us to be quite agile. And what's more, the data interface only outputs one single simple type, so any necessary type conversion is abstracted. This was a deliberate restriction to make certain multiple representations wouldn't leak out into the codebase. 

The final touch to this repository architecture focuses on consumer ergonomics. Each data type will have its data interface wrapped in a **generic** class with the signature `Repository<Interface: DataInterface>`. The purpose of this class is to provide simple, reactive ergonomics for data consumers. A `Repository` has just a few simple functions, such as `fetchSubset`, `fetchSingle`, and `save`. These return publishers – specifically, a type-erased `AnyPublisher` – which forces all consumers to be prepared for streams of data.

![Untitled Document - Copy-3](https://user-images.githubusercontent.com/12732454/127111614-f36ba73f-61f6-4b83-8c8f-2354ee43b98e.png)

Because it’s the exact same class wrapping all interfaces, there will not be any differences in how data is accessed throughout the app. At the end of the day, data consumers don’t know anything about interfaces or data sources. All they need to work with is the same familiar class that’s used everywhere! All consumers interact with the same repository for each data type. That, coupled with the reactive pattern, ensure that data is always kept in sync across the app. Changes in data will be pushed out to all subscribers at once.

I also leveraged a few Combine features to implement a caching system in the `Repository`. This means that, when enabled, the last fetched data will be delivered immediately while a new fetch is kicked off. The consumers, being reactive, will respond to any number of data updates coming across the pipeline.

![Repository Data Flow-4](https://user-images.githubusercontent.com/12732454/127265224-d2ca3440-b1e5-408a-b4fc-75349edb52b6.png)

Future enhancements similar to that caching feature can be added to the `Repository` in the future, and the beauty is they will go into affect for all data types. This gives us a single point of optimization to affect data operations app-wide.

### Future 👀
1. As described [here](https://github.com/ZHRhodes/Whaler-api#future-), the salesforce integration should eventually be moved to the backend. Then, aside from logging in and passing that token to the API, the frontend wouldn't need to know anything else about Salesforce. This would let us relieve the frontend of a lot of the data juggling that exists currently. 
