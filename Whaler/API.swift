// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class CreateAccountMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation createAccount($name: String!, $owner: String!, $industry: String, $description: String, $numberOfEmployees: String, $annualRevenue: String, $billingCity: String, $billingState: String, $phone: String, $website: String, $type: String, $state: String, $notes: String) {
      createAccount(input: {name: $name, owner: $owner, industry: $industry, description: $description, numberOfEmployees: $numberOfEmployees, annualRevenue: $annualRevenue, billingCity: $billingCity, billingState: $billingState, phone: $phone, website: $website, type: $type, state: $state, notes: $notes}) {
        __typename
        id
        createdAt
        updatedAt
        deletedAt
        name
        owner
        industry
        description
        numberOfEmployees
        annualRevenue
        billingCity
        billingState
        phone
        website
        type
        state
        notes
      }
    }
    """

  public let operationName: String = "createAccount"

  public let operationIdentifier: String? = "9a8f9cb47522cab379aae87d2311e07a33f971773240297ea9101f1e5c2c7135"

  public var name: String
  public var owner: String
  public var industry: String?
  public var description: String?
  public var numberOfEmployees: String?
  public var annualRevenue: String?
  public var billingCity: String?
  public var billingState: String?
  public var phone: String?
  public var website: String?
  public var type: String?
  public var state: String?
  public var notes: String?

  public init(name: String, owner: String, industry: String? = nil, description: String? = nil, numberOfEmployees: String? = nil, annualRevenue: String? = nil, billingCity: String? = nil, billingState: String? = nil, phone: String? = nil, website: String? = nil, type: String? = nil, state: String? = nil, notes: String? = nil) {
    self.name = name
    self.owner = owner
    self.industry = industry
    self.description = description
    self.numberOfEmployees = numberOfEmployees
    self.annualRevenue = annualRevenue
    self.billingCity = billingCity
    self.billingState = billingState
    self.phone = phone
    self.website = website
    self.type = type
    self.state = state
    self.notes = notes
  }

  public var variables: GraphQLMap? {
    return ["name": name, "owner": owner, "industry": industry, "description": description, "numberOfEmployees": numberOfEmployees, "annualRevenue": annualRevenue, "billingCity": billingCity, "billingState": billingState, "phone": phone, "website": website, "type": type, "state": state, "notes": notes]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createAccount", arguments: ["input": ["name": GraphQLVariable("name"), "owner": GraphQLVariable("owner"), "industry": GraphQLVariable("industry"), "description": GraphQLVariable("description"), "numberOfEmployees": GraphQLVariable("numberOfEmployees"), "annualRevenue": GraphQLVariable("annualRevenue"), "billingCity": GraphQLVariable("billingCity"), "billingState": GraphQLVariable("billingState"), "phone": GraphQLVariable("phone"), "website": GraphQLVariable("website"), "type": GraphQLVariable("type"), "state": GraphQLVariable("state"), "notes": GraphQLVariable("notes")]], type: .nonNull(.object(CreateAccount.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createAccount: CreateAccount) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createAccount": createAccount.resultMap])
    }

    public var createAccount: CreateAccount {
      get {
        return CreateAccount(unsafeResultMap: resultMap["createAccount"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "createAccount")
      }
    }

    public struct CreateAccount: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Account"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("deletedAt", type: .scalar(String.self)),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("owner", type: .nonNull(.scalar(String.self))),
          GraphQLField("industry", type: .scalar(String.self)),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("numberOfEmployees", type: .scalar(String.self)),
          GraphQLField("annualRevenue", type: .scalar(String.self)),
          GraphQLField("billingCity", type: .scalar(String.self)),
          GraphQLField("billingState", type: .scalar(String.self)),
          GraphQLField("phone", type: .scalar(String.self)),
          GraphQLField("website", type: .scalar(String.self)),
          GraphQLField("type", type: .scalar(String.self)),
          GraphQLField("state", type: .scalar(String.self)),
          GraphQLField("notes", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, createdAt: String, updatedAt: String, deletedAt: String? = nil, name: String, owner: String, industry: String? = nil, description: String? = nil, numberOfEmployees: String? = nil, annualRevenue: String? = nil, billingCity: String? = nil, billingState: String? = nil, phone: String? = nil, website: String? = nil, type: String? = nil, state: String? = nil, notes: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Account", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "deletedAt": deletedAt, "name": name, "owner": owner, "industry": industry, "description": description, "numberOfEmployees": numberOfEmployees, "annualRevenue": annualRevenue, "billingCity": billingCity, "billingState": billingState, "phone": phone, "website": website, "type": type, "state": state, "notes": notes])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var createdAt: String {
        get {
          return resultMap["createdAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return resultMap["updatedAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var deletedAt: String? {
        get {
          return resultMap["deletedAt"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "deletedAt")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var owner: String {
        get {
          return resultMap["owner"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "owner")
        }
      }

      public var industry: String? {
        get {
          return resultMap["industry"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "industry")
        }
      }

      public var description: String? {
        get {
          return resultMap["description"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
        }
      }

      public var numberOfEmployees: String? {
        get {
          return resultMap["numberOfEmployees"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "numberOfEmployees")
        }
      }

      public var annualRevenue: String? {
        get {
          return resultMap["annualRevenue"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "annualRevenue")
        }
      }

      public var billingCity: String? {
        get {
          return resultMap["billingCity"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "billingCity")
        }
      }

      public var billingState: String? {
        get {
          return resultMap["billingState"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "billingState")
        }
      }

      public var phone: String? {
        get {
          return resultMap["phone"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "phone")
        }
      }

      public var website: String? {
        get {
          return resultMap["website"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "website")
        }
      }

      public var type: String? {
        get {
          return resultMap["type"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "type")
        }
      }

      public var state: String? {
        get {
          return resultMap["state"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "state")
        }
      }

      public var notes: String? {
        get {
          return resultMap["notes"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "notes")
        }
      }
    }
  }
}

public final class CreateContactMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation createContact($firstName: String!, $lastName: String!, $jobTitle: String, $state: String, $email: String, $phone: String, $accountID: String) {
      createContact(input: {firstName: $firstName, lastName: $lastName, jobTitle: $jobTitle, state: $state, email: $email, phone: $phone, accountID: $accountID}) {
        __typename
        id
        createdAt
        updatedAt
        deletedAt
        firstName
        lastName
        jobTitle
        state
        email
        phone
        accountID
      }
    }
    """

  public let operationName: String = "createContact"

  public let operationIdentifier: String? = "61be1fa096f0401eaf17b6868e07898a4273b794bb744854de51d3c4e795257c"

  public var firstName: String
  public var lastName: String
  public var jobTitle: String?
  public var state: String?
  public var email: String?
  public var phone: String?
  public var accountID: String?

  public init(firstName: String, lastName: String, jobTitle: String? = nil, state: String? = nil, email: String? = nil, phone: String? = nil, accountID: String? = nil) {
    self.firstName = firstName
    self.lastName = lastName
    self.jobTitle = jobTitle
    self.state = state
    self.email = email
    self.phone = phone
    self.accountID = accountID
  }

  public var variables: GraphQLMap? {
    return ["firstName": firstName, "lastName": lastName, "jobTitle": jobTitle, "state": state, "email": email, "phone": phone, "accountID": accountID]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createContact", arguments: ["input": ["firstName": GraphQLVariable("firstName"), "lastName": GraphQLVariable("lastName"), "jobTitle": GraphQLVariable("jobTitle"), "state": GraphQLVariable("state"), "email": GraphQLVariable("email"), "phone": GraphQLVariable("phone"), "accountID": GraphQLVariable("accountID")]], type: .nonNull(.object(CreateContact.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createContact: CreateContact) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createContact": createContact.resultMap])
    }

    public var createContact: CreateContact {
      get {
        return CreateContact(unsafeResultMap: resultMap["createContact"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "createContact")
      }
    }

    public struct CreateContact: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Contact"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("deletedAt", type: .scalar(String.self)),
          GraphQLField("firstName", type: .nonNull(.scalar(String.self))),
          GraphQLField("lastName", type: .nonNull(.scalar(String.self))),
          GraphQLField("jobTitle", type: .scalar(String.self)),
          GraphQLField("state", type: .scalar(String.self)),
          GraphQLField("email", type: .scalar(String.self)),
          GraphQLField("phone", type: .scalar(String.self)),
          GraphQLField("accountID", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, createdAt: String, updatedAt: String, deletedAt: String? = nil, firstName: String, lastName: String, jobTitle: String? = nil, state: String? = nil, email: String? = nil, phone: String? = nil, accountId: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Contact", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "deletedAt": deletedAt, "firstName": firstName, "lastName": lastName, "jobTitle": jobTitle, "state": state, "email": email, "phone": phone, "accountID": accountId])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var createdAt: String {
        get {
          return resultMap["createdAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return resultMap["updatedAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var deletedAt: String? {
        get {
          return resultMap["deletedAt"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "deletedAt")
        }
      }

      public var firstName: String {
        get {
          return resultMap["firstName"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String {
        get {
          return resultMap["lastName"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "lastName")
        }
      }

      public var jobTitle: String? {
        get {
          return resultMap["jobTitle"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "jobTitle")
        }
      }

      public var state: String? {
        get {
          return resultMap["state"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "state")
        }
      }

      public var email: String? {
        get {
          return resultMap["email"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "email")
        }
      }

      public var phone: String? {
        get {
          return resultMap["phone"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "phone")
        }
      }

      public var accountId: String? {
        get {
          return resultMap["accountID"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "accountID")
        }
      }
    }
  }
}

public final class CreateContactAssignmentEntryMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation createContactAssignmentEntry($contactId: Int!, $assignedBy: String!, $assignedTo: String) {
      createContactAssignmentEntry(input: {contactId: $contactId, assignedBy: $assignedBy, assignedTo: $assignedTo}) {
        __typename
        id
        createdAt
        contactId
        assignedBy
        assignedTo
      }
    }
    """

  public let operationName: String = "createContactAssignmentEntry"

  public let operationIdentifier: String? = "61f0c1808dbd75d3d95de49951c6508d84cf82b3f6f83774a50026b416fffb87"

  public var contactId: Int
  public var assignedBy: String
  public var assignedTo: String?

  public init(contactId: Int, assignedBy: String, assignedTo: String? = nil) {
    self.contactId = contactId
    self.assignedBy = assignedBy
    self.assignedTo = assignedTo
  }

  public var variables: GraphQLMap? {
    return ["contactId": contactId, "assignedBy": assignedBy, "assignedTo": assignedTo]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createContactAssignmentEntry", arguments: ["input": ["contactId": GraphQLVariable("contactId"), "assignedBy": GraphQLVariable("assignedBy"), "assignedTo": GraphQLVariable("assignedTo")]], type: .nonNull(.object(CreateContactAssignmentEntry.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createContactAssignmentEntry: CreateContactAssignmentEntry) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createContactAssignmentEntry": createContactAssignmentEntry.resultMap])
    }

    public var createContactAssignmentEntry: CreateContactAssignmentEntry {
      get {
        return CreateContactAssignmentEntry(unsafeResultMap: resultMap["createContactAssignmentEntry"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "createContactAssignmentEntry")
      }
    }

    public struct CreateContactAssignmentEntry: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ContactAssignmentEntry"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("contactId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("assignedBy", type: .nonNull(.scalar(String.self))),
          GraphQLField("assignedTo", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, createdAt: String, contactId: GraphQLID, assignedBy: String, assignedTo: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "ContactAssignmentEntry", "id": id, "createdAt": createdAt, "contactId": contactId, "assignedBy": assignedBy, "assignedTo": assignedTo])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var createdAt: String {
        get {
          return resultMap["createdAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var contactId: GraphQLID {
        get {
          return resultMap["contactId"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "contactId")
        }
      }

      public var assignedBy: String {
        get {
          return resultMap["assignedBy"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "assignedBy")
        }
      }

      public var assignedTo: String? {
        get {
          return resultMap["assignedTo"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "assignedTo")
        }
      }
    }
  }
}

public final class FetchOrganizationQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query fetchOrganization {
      organization {
        __typename
        id
        name
        users {
          __typename
          firstName
          lastName
        }
      }
    }
    """

  public let operationName: String = "fetchOrganization"

  public let operationIdentifier: String? = "7f84dfc864fba0ea99d889df782636ef27349f211ac9bc38919d2439fb415123"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("organization", type: .object(Organization.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(organization: Organization? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "organization": organization.flatMap { (value: Organization) -> ResultMap in value.resultMap }])
    }

    public var organization: Organization? {
      get {
        return (resultMap["organization"] as? ResultMap).flatMap { Organization(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "organization")
      }
    }

    public struct Organization: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Organization"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("users", type: .nonNull(.list(.nonNull(.object(User.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, users: [User]) {
        self.init(unsafeResultMap: ["__typename": "Organization", "id": id, "name": name, "users": users.map { (value: User) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var users: [User] {
        get {
          return (resultMap["users"] as! [ResultMap]).map { (value: ResultMap) -> User in User(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: User) -> ResultMap in value.resultMap }, forKey: "users")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("firstName", type: .nonNull(.scalar(String.self))),
            GraphQLField("lastName", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(firstName: String, lastName: String) {
          self.init(unsafeResultMap: ["__typename": "User", "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var firstName: String {
          get {
            return resultMap["firstName"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String {
          get {
            return resultMap["lastName"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "lastName")
          }
        }
      }
    }
  }
}
