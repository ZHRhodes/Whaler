// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

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
