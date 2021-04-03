// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct AccountTrackingChange: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - account
  ///   - newState
  public init(account: NewAccount, newState: String) {
    graphQLMap = ["account": account, "newState": newState]
  }

  public var account: NewAccount {
    get {
      return graphQLMap["account"] as! NewAccount
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "account")
    }
  }

  public var newState: String {
    get {
      return graphQLMap["newState"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "newState")
    }
  }
}

public struct NewAccount: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - id
  ///   - salesforceId
  ///   - salesforceOwnerId
  ///   - name
  ///   - industry
  ///   - description
  ///   - numberOfEmployees
  ///   - annualRevenue
  ///   - billingCity
  ///   - billingState
  ///   - phone
  ///   - website
  ///   - type
  ///   - state
  ///   - notes
  public init(id: Swift.Optional<GraphQLID?> = nil, salesforceId: Swift.Optional<String?> = nil, salesforceOwnerId: Swift.Optional<String?> = nil, name: String, industry: Swift.Optional<String?> = nil, description: Swift.Optional<String?> = nil, numberOfEmployees: Swift.Optional<String?> = nil, annualRevenue: Swift.Optional<String?> = nil, billingCity: Swift.Optional<String?> = nil, billingState: Swift.Optional<String?> = nil, phone: Swift.Optional<String?> = nil, website: Swift.Optional<String?> = nil, type: Swift.Optional<String?> = nil, state: Swift.Optional<String?> = nil, notes: Swift.Optional<String?> = nil) {
    graphQLMap = ["id": id, "salesforceID": salesforceId, "salesforceOwnerID": salesforceOwnerId, "name": name, "industry": industry, "description": description, "numberOfEmployees": numberOfEmployees, "annualRevenue": annualRevenue, "billingCity": billingCity, "billingState": billingState, "phone": phone, "website": website, "type": type, "state": state, "notes": notes]
  }

  public var id: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["id"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var salesforceId: Swift.Optional<String?> {
    get {
      return graphQLMap["salesforceID"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "salesforceID")
    }
  }

  public var salesforceOwnerId: Swift.Optional<String?> {
    get {
      return graphQLMap["salesforceOwnerID"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "salesforceOwnerID")
    }
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var industry: Swift.Optional<String?> {
    get {
      return graphQLMap["industry"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "industry")
    }
  }

  public var description: Swift.Optional<String?> {
    get {
      return graphQLMap["description"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var numberOfEmployees: Swift.Optional<String?> {
    get {
      return graphQLMap["numberOfEmployees"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "numberOfEmployees")
    }
  }

  public var annualRevenue: Swift.Optional<String?> {
    get {
      return graphQLMap["annualRevenue"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "annualRevenue")
    }
  }

  public var billingCity: Swift.Optional<String?> {
    get {
      return graphQLMap["billingCity"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "billingCity")
    }
  }

  public var billingState: Swift.Optional<String?> {
    get {
      return graphQLMap["billingState"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "billingState")
    }
  }

  public var phone: Swift.Optional<String?> {
    get {
      return graphQLMap["phone"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phone")
    }
  }

  public var website: Swift.Optional<String?> {
    get {
      return graphQLMap["website"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "website")
    }
  }

  public var type: Swift.Optional<String?> {
    get {
      return graphQLMap["type"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var state: Swift.Optional<String?> {
    get {
      return graphQLMap["state"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "state")
    }
  }

  public var notes: Swift.Optional<String?> {
    get {
      return graphQLMap["notes"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notes")
    }
  }
}

public struct NewContact: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - id
  ///   - salesforceId
  ///   - firstName
  ///   - lastName
  ///   - jobTitle
  ///   - state
  ///   - email
  ///   - phone
  ///   - accountId
  public init(id: Swift.Optional<GraphQLID?> = nil, salesforceId: Swift.Optional<String?> = nil, firstName: String, lastName: String, jobTitle: Swift.Optional<String?> = nil, state: Swift.Optional<String?> = nil, email: Swift.Optional<String?> = nil, phone: Swift.Optional<String?> = nil, accountId: Swift.Optional<String?> = nil) {
    graphQLMap = ["id": id, "salesforceID": salesforceId, "firstName": firstName, "lastName": lastName, "jobTitle": jobTitle, "state": state, "email": email, "phone": phone, "accountID": accountId]
  }

  public var id: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["id"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var salesforceId: Swift.Optional<String?> {
    get {
      return graphQLMap["salesforceID"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "salesforceID")
    }
  }

  public var firstName: String {
    get {
      return graphQLMap["firstName"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: String {
    get {
      return graphQLMap["lastName"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var jobTitle: Swift.Optional<String?> {
    get {
      return graphQLMap["jobTitle"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "jobTitle")
    }
  }

  public var state: Swift.Optional<String?> {
    get {
      return graphQLMap["state"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "state")
    }
  }

  public var email: Swift.Optional<String?> {
    get {
      return graphQLMap["email"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var phone: Swift.Optional<String?> {
    get {
      return graphQLMap["phone"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phone")
    }
  }

  public var accountId: Swift.Optional<String?> {
    get {
      return graphQLMap["accountID"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "accountID")
    }
  }
}

public final class AccountsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query accounts {
      accounts {
        __typename
        id
        salesforceOwnerID
        name
        salesforceID
        industry
        numberOfEmployees
        annualRevenue
        billingCity
        billingState
        phone
        website
        type
        description
        state
        notes
      }
    }
    """

  public let operationName: String = "accounts"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("accounts", type: .nonNull(.list(.nonNull(.object(Account.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(accounts: [Account]) {
      self.init(unsafeResultMap: ["__typename": "Query", "accounts": accounts.map { (value: Account) -> ResultMap in value.resultMap }])
    }

    public var accounts: [Account] {
      get {
        return (resultMap["accounts"] as! [ResultMap]).map { (value: ResultMap) -> Account in Account(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Account) -> ResultMap in value.resultMap }, forKey: "accounts")
      }
    }

    public struct Account: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Account"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("salesforceOwnerID", type: .scalar(String.self)),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("salesforceID", type: .scalar(String.self)),
          GraphQLField("industry", type: .scalar(String.self)),
          GraphQLField("numberOfEmployees", type: .scalar(String.self)),
          GraphQLField("annualRevenue", type: .scalar(String.self)),
          GraphQLField("billingCity", type: .scalar(String.self)),
          GraphQLField("billingState", type: .scalar(String.self)),
          GraphQLField("phone", type: .scalar(String.self)),
          GraphQLField("website", type: .scalar(String.self)),
          GraphQLField("type", type: .scalar(String.self)),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("state", type: .scalar(String.self)),
          GraphQLField("notes", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, salesforceOwnerId: String? = nil, name: String, salesforceId: String? = nil, industry: String? = nil, numberOfEmployees: String? = nil, annualRevenue: String? = nil, billingCity: String? = nil, billingState: String? = nil, phone: String? = nil, website: String? = nil, type: String? = nil, description: String? = nil, state: String? = nil, notes: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Account", "id": id, "salesforceOwnerID": salesforceOwnerId, "name": name, "salesforceID": salesforceId, "industry": industry, "numberOfEmployees": numberOfEmployees, "annualRevenue": annualRevenue, "billingCity": billingCity, "billingState": billingState, "phone": phone, "website": website, "type": type, "description": description, "state": state, "notes": notes])
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

      public var salesforceOwnerId: String? {
        get {
          return resultMap["salesforceOwnerID"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "salesforceOwnerID")
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

      public var salesforceId: String? {
        get {
          return resultMap["salesforceID"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "salesforceID")
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

      public var description: String? {
        get {
          return resultMap["description"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
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

public final class ApplyAccountTrackingChangesMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation applyAccountTrackingChanges($input: [AccountTrackingChange!]!) {
      trackedAccounts: applyAccountTrackingChanges(input: $input) {
        __typename
        id
        name
        salesforceID
        salesforceOwnerID
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

  public let operationName: String = "applyAccountTrackingChanges"

  public var input: [AccountTrackingChange]

  public init(input: [AccountTrackingChange]) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("applyAccountTrackingChanges", alias: "trackedAccounts", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.list(.nonNull(.object(TrackedAccount.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(trackedAccounts: [TrackedAccount]) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "trackedAccounts": trackedAccounts.map { (value: TrackedAccount) -> ResultMap in value.resultMap }])
    }

    public var trackedAccounts: [TrackedAccount] {
      get {
        return (resultMap["trackedAccounts"] as! [ResultMap]).map { (value: ResultMap) -> TrackedAccount in TrackedAccount(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: TrackedAccount) -> ResultMap in value.resultMap }, forKey: "trackedAccounts")
      }
    }

    public struct TrackedAccount: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Account"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("salesforceID", type: .scalar(String.self)),
          GraphQLField("salesforceOwnerID", type: .scalar(String.self)),
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

      public init(id: GraphQLID, name: String, salesforceId: String? = nil, salesforceOwnerId: String? = nil, industry: String? = nil, description: String? = nil, numberOfEmployees: String? = nil, annualRevenue: String? = nil, billingCity: String? = nil, billingState: String? = nil, phone: String? = nil, website: String? = nil, type: String? = nil, state: String? = nil, notes: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Account", "id": id, "name": name, "salesforceID": salesforceId, "salesforceOwnerID": salesforceOwnerId, "industry": industry, "description": description, "numberOfEmployees": numberOfEmployees, "annualRevenue": annualRevenue, "billingCity": billingCity, "billingState": billingState, "phone": phone, "website": website, "type": type, "state": state, "notes": notes])
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

      public var salesforceId: String? {
        get {
          return resultMap["salesforceID"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "salesforceID")
        }
      }

      public var salesforceOwnerId: String? {
        get {
          return resultMap["salesforceOwnerID"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "salesforceOwnerID")
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

public final class ContactsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query contacts($accountID: ID!) {
      contacts(accountID: $accountID) {
        __typename
        id
        firstName
        lastName
        jobTitle
        email
        phone
        salesforceID
        accountID
        state
      }
    }
    """

  public let operationName: String = "contacts"

  public var accountID: GraphQLID

  public init(accountID: GraphQLID) {
    self.accountID = accountID
  }

  public var variables: GraphQLMap? {
    return ["accountID": accountID]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("contacts", arguments: ["accountID": GraphQLVariable("accountID")], type: .nonNull(.list(.nonNull(.object(Contact.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(contacts: [Contact]) {
      self.init(unsafeResultMap: ["__typename": "Query", "contacts": contacts.map { (value: Contact) -> ResultMap in value.resultMap }])
    }

    public var contacts: [Contact] {
      get {
        return (resultMap["contacts"] as! [ResultMap]).map { (value: ResultMap) -> Contact in Contact(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Contact) -> ResultMap in value.resultMap }, forKey: "contacts")
      }
    }

    public struct Contact: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Contact"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("firstName", type: .nonNull(.scalar(String.self))),
          GraphQLField("lastName", type: .nonNull(.scalar(String.self))),
          GraphQLField("jobTitle", type: .scalar(String.self)),
          GraphQLField("email", type: .scalar(String.self)),
          GraphQLField("phone", type: .scalar(String.self)),
          GraphQLField("salesforceID", type: .scalar(String.self)),
          GraphQLField("accountID", type: .scalar(String.self)),
          GraphQLField("state", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, firstName: String, lastName: String, jobTitle: String? = nil, email: String? = nil, phone: String? = nil, salesforceId: String? = nil, accountId: String? = nil, state: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Contact", "id": id, "firstName": firstName, "lastName": lastName, "jobTitle": jobTitle, "email": email, "phone": phone, "salesforceID": salesforceId, "accountID": accountId, "state": state])
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

      public var salesforceId: String? {
        get {
          return resultMap["salesforceID"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "salesforceID")
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

      public var state: String? {
        get {
          return resultMap["state"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "state")
        }
      }
    }
  }
}

public final class CreateAccountMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation createAccount($name: String!, $industry: String, $description: String, $numberOfEmployees: String, $annualRevenue: String, $billingCity: String, $billingState: String, $phone: String, $website: String, $type: String, $state: String, $notes: String) {
      createAccount(
        input: {name: $name, industry: $industry, description: $description, numberOfEmployees: $numberOfEmployees, annualRevenue: $annualRevenue, billingCity: $billingCity, billingState: $billingState, phone: $phone, website: $website, type: $type, state: $state, notes: $notes}
      ) {
        __typename
        id
        createdAt
        updatedAt
        deletedAt
        name
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

  public var name: String
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

  public init(name: String, industry: String? = nil, description: String? = nil, numberOfEmployees: String? = nil, annualRevenue: String? = nil, billingCity: String? = nil, billingState: String? = nil, phone: String? = nil, website: String? = nil, type: String? = nil, state: String? = nil, notes: String? = nil) {
    self.name = name
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
    return ["name": name, "industry": industry, "description": description, "numberOfEmployees": numberOfEmployees, "annualRevenue": annualRevenue, "billingCity": billingCity, "billingState": billingState, "phone": phone, "website": website, "type": type, "state": state, "notes": notes]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createAccount", arguments: ["input": ["name": GraphQLVariable("name"), "industry": GraphQLVariable("industry"), "description": GraphQLVariable("description"), "numberOfEmployees": GraphQLVariable("numberOfEmployees"), "annualRevenue": GraphQLVariable("annualRevenue"), "billingCity": GraphQLVariable("billingCity"), "billingState": GraphQLVariable("billingState"), "phone": GraphQLVariable("phone"), "website": GraphQLVariable("website"), "type": GraphQLVariable("type"), "state": GraphQLVariable("state"), "notes": GraphQLVariable("notes")]], type: .nonNull(.object(CreateAccount.selections))),
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

      public init(id: GraphQLID, createdAt: String, updatedAt: String, deletedAt: String? = nil, name: String, industry: String? = nil, description: String? = nil, numberOfEmployees: String? = nil, annualRevenue: String? = nil, billingCity: String? = nil, billingState: String? = nil, phone: String? = nil, website: String? = nil, type: String? = nil, state: String? = nil, notes: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Account", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "deletedAt": deletedAt, "name": name, "industry": industry, "description": description, "numberOfEmployees": numberOfEmployees, "annualRevenue": annualRevenue, "billingCity": billingCity, "billingState": billingState, "phone": phone, "website": website, "type": type, "state": state, "notes": notes])
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
      createContact(
        input: {firstName: $firstName, lastName: $lastName, jobTitle: $jobTitle, state: $state, email: $email, phone: $phone, accountID: $accountID}
      ) {
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
    mutation createContactAssignmentEntry($contactId: ID!, $assignedBy: String!, $assignedTo: String) {
      createContactAssignmentEntry(
        input: {contactId: $contactId, assignedBy: $assignedBy, assignedTo: $assignedTo}
      ) {
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

  public var contactId: GraphQLID
  public var assignedBy: String
  public var assignedTo: String?

  public init(contactId: GraphQLID, assignedBy: String, assignedTo: String? = nil) {
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

public final class SaveAccountsMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation saveAccounts($input: [NewAccount!]!) {
      saveAccounts(input: $input) {
        __typename
        id
        name
        salesforceID
        salesforceOwnerID
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

  public let operationName: String = "saveAccounts"

  public var input: [NewAccount]

  public init(input: [NewAccount]) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("saveAccounts", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.list(.nonNull(.object(SaveAccount.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(saveAccounts: [SaveAccount]) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "saveAccounts": saveAccounts.map { (value: SaveAccount) -> ResultMap in value.resultMap }])
    }

    public var saveAccounts: [SaveAccount] {
      get {
        return (resultMap["saveAccounts"] as! [ResultMap]).map { (value: ResultMap) -> SaveAccount in SaveAccount(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: SaveAccount) -> ResultMap in value.resultMap }, forKey: "saveAccounts")
      }
    }

    public struct SaveAccount: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Account"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("salesforceID", type: .scalar(String.self)),
          GraphQLField("salesforceOwnerID", type: .scalar(String.self)),
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

      public init(id: GraphQLID, name: String, salesforceId: String? = nil, salesforceOwnerId: String? = nil, industry: String? = nil, description: String? = nil, numberOfEmployees: String? = nil, annualRevenue: String? = nil, billingCity: String? = nil, billingState: String? = nil, phone: String? = nil, website: String? = nil, type: String? = nil, state: String? = nil, notes: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Account", "id": id, "name": name, "salesforceID": salesforceId, "salesforceOwnerID": salesforceOwnerId, "industry": industry, "description": description, "numberOfEmployees": numberOfEmployees, "annualRevenue": annualRevenue, "billingCity": billingCity, "billingState": billingState, "phone": phone, "website": website, "type": type, "state": state, "notes": notes])
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

      public var salesforceId: String? {
        get {
          return resultMap["salesforceID"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "salesforceID")
        }
      }

      public var salesforceOwnerId: String? {
        get {
          return resultMap["salesforceOwnerID"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "salesforceOwnerID")
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

public final class SaveContactsMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation saveContacts($input: [NewContact!]!) {
      saveContacts(input: $input) {
        __typename
        id
        firstName
        lastName
        jobTitle
        email
        phone
        salesforceID
        accountID
        state
      }
    }
    """

  public let operationName: String = "saveContacts"

  public var input: [NewContact]

  public init(input: [NewContact]) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("saveContacts", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.list(.nonNull(.object(SaveContact.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(saveContacts: [SaveContact]) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "saveContacts": saveContacts.map { (value: SaveContact) -> ResultMap in value.resultMap }])
    }

    public var saveContacts: [SaveContact] {
      get {
        return (resultMap["saveContacts"] as! [ResultMap]).map { (value: ResultMap) -> SaveContact in SaveContact(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: SaveContact) -> ResultMap in value.resultMap }, forKey: "saveContacts")
      }
    }

    public struct SaveContact: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Contact"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("firstName", type: .nonNull(.scalar(String.self))),
          GraphQLField("lastName", type: .nonNull(.scalar(String.self))),
          GraphQLField("jobTitle", type: .scalar(String.self)),
          GraphQLField("email", type: .scalar(String.self)),
          GraphQLField("phone", type: .scalar(String.self)),
          GraphQLField("salesforceID", type: .scalar(String.self)),
          GraphQLField("accountID", type: .scalar(String.self)),
          GraphQLField("state", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, firstName: String, lastName: String, jobTitle: String? = nil, email: String? = nil, phone: String? = nil, salesforceId: String? = nil, accountId: String? = nil, state: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Contact", "id": id, "firstName": firstName, "lastName": lastName, "jobTitle": jobTitle, "email": email, "phone": phone, "salesforceID": salesforceId, "accountID": accountId, "state": state])
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

      public var salesforceId: String? {
        get {
          return resultMap["salesforceID"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "salesforceID")
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

      public var state: String? {
        get {
          return resultMap["state"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "state")
        }
      }
    }
  }
}
