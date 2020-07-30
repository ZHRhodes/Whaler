//
//  CSVParser.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/21/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

struct CSVParser {
  typealias CSV = [[String: String]]
  
  static func parseCSV(fileUrl: URL, encoding: String.Encoding) -> CSV? {
    // Load the CSV file and parse it
    let delimiter = ","

    guard let contents = try? String(contentsOf: fileUrl, encoding: encoding) else { return nil }
    var keys = [String]()
    var items = [[String: String]]()
    let lines: [String] = contents.components(separatedBy: .newlines)
    
    for (i, line) in lines.enumerated() {
      var values: [String] = []
      if line != "" {
        // For a line with double quotes
        // we use NSScanner to perform the parsing
        if line.range(of: "\"") != nil {
            var textToScan:String = line
            var value:NSString?
            var textScanner:Scanner = Scanner(string: textToScan)
            while textScanner.string != "" {

                if (textScanner.string as NSString).substring(to: 1) == "\"" {
                    textScanner.scanLocation += 1
                    textScanner.scanUpTo("\"", into: &value)
                    textScanner.scanLocation += 1
                } else {
                    textScanner.scanUpTo(delimiter, into: &value)
                }

                // Store the value into the values array
                values.append(value! as String)

                // Retrieve the unscanned remainder of the string
                if textScanner.scanLocation < textScanner.string.count {
                    textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                } else {
                    textToScan = ""
                }
                textScanner = Scanner(string: textToScan)
            }

        // For a line without double quotes, we can simply separate the string
        // by using the delimiter (e.g. comma)
        } else  {
            values = line.components(separatedBy: delimiter)
        }
        
        if i == 0 {
          keys = values
        } else {
          // Put the values into the tuple and add it to the items array
          var item = [String: String]()
          for (key, value) in zip(keys, values) {
            item[key] = value
          }
          items.append(item)
        }
      }
    }
    return items
  }
  
  static func parseAccountsAndContacts(from csv: CSV) -> ([Account], [Contact]) {
    var accounts = [Account]()
    var contacts = [Contact]()
    var parsedAccounts = Set<String>()
    for row in csv {
      guard let accountID = row["Account ID"],
            row["Account Name"] != nil else { continue }
      let contact = Contact(dictionary: row)
      contacts.append(contact)
      
      var account: Account
      if !parsedAccounts.contains(accountID) {
        parsedAccounts.insert(accountID)
        account = Account(dictionary: row)
        account.contacts[contact.state]?.append(contact)
        accounts.append(account)
      } else {
        account = accounts.first(where: { $0.id == accountID }) ?? Account()
        account.contacts[contact.state]?.append(contact)
      }
    }
    return (accounts, contacts)
  }
}
