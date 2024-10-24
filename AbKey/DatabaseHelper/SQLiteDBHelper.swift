//
//  SQLiteDBHelper.swift
//  AbKey
//
//  Created by Divyanah on 13/03/24.
//

import Foundation
import SQLite3

protocol SQLiteDBHelperDelegate: AnyObject {
    func databaseDidChange()
}

class SQLiteDBHelper {
    static let shared = SQLiteDBHelper() // Singleton instance
    private var db: OpaquePointer?

    weak var delegate: SQLiteDBHelperDelegate?
    
    private init() {
        openDatabase()
        createTable()
    }
    
    private func openDatabase() {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.AppGroupSuiteName) else {
            print("App Group container is not available.")
            return
        }
        let fileURL = containerURL.appendingPathComponent(Constants.DBFileName)

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
    }
    
    // Create the table if it doesn't already exist
    private func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS CustomKeys(Id INTEGER PRIMARY KEY AUTOINCREMENT, Key TEXT, Value TEXT, KeyboardType TEXT);"
        var createTableStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("CustomKeys table created.")
            } else {
                print("CustomKeys table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    // Insert an entry in the DB
    func insert(key: String, value: String, keyboardType: String) {
        let insertStatementString = "INSERT INTO CustomKeys (Key, Value, KeyboardType) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (key as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (value as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (keyboardType as NSString).utf8String, -1, nil)

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
            sqlite3_finalize(insertStatement)
        } else {
            print("INSERT statement could not be prepared.")
        }
    }
    
    // Insert or update an entry in the DB
    func insertOrUpdate(key: String, value: String, keyboardType: String) {
        // First, check if the key exists
        let queryStatementString = "SELECT * FROM CustomKeys WHERE Key = ?;"
        var queryStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (key as NSString).utf8String, -1, nil)

            if sqlite3_step(queryStatement) == SQLITE_ROW {
                // Key exists, so update
                sqlite3_finalize(queryStatement) // Finalize the query statement first

                let updateStatementString = "UPDATE CustomKeys SET Value = ?, KeyboardType = ? WHERE Key = ?;"
                var updateStatement: OpaquePointer?

                if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                    sqlite3_bind_text(updateStatement, 1, (value as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 2, (keyboardType as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 3, (key as NSString).utf8String, -1, nil)

                    if sqlite3_step(updateStatement) == SQLITE_DONE {
                        print("Successfully updated row.")
                    } else {
                        print("Could not update row.")
                    }
                    sqlite3_finalize(updateStatement)
                }
            } else {
                // Key does not exist, so insert new one
                sqlite3_finalize(queryStatement) // Finalize the query statement first

                let insertStatementString = "INSERT INTO CustomKeys (Key, Value, KeyboardType) VALUES (?, ?, ?);"
                var insertStatement: OpaquePointer?

                if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                    sqlite3_bind_text(insertStatement, 1, (key as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 2, (value as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 3, (keyboardType as NSString).utf8String, -1, nil)

                    if sqlite3_step(insertStatement) == SQLITE_DONE {
                        print("Successfully inserted row.")
                    } else {
                        print("Could not insert row.")
                    }
                    sqlite3_finalize(insertStatement)
                }
            }
        } else {
            print("SELECT statement could not be prepared.")
        }
    }
    
    // Get single value of a key
    func value(forKey key: String) -> String? {
        let queryStatementString = "SELECT Value FROM CustomKeys WHERE Key = ?;"
        var queryStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (key as NSString).utf8String, -1, nil)

            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let value = String(cString: sqlite3_column_text(queryStatement, 0))
                sqlite3_finalize(queryStatement)
                return value
            } else {
                print("Key not found.")
            }
            sqlite3_finalize(queryStatement)
        } else {
            print("SELECT statement could not be prepared.")
        }
        return nil
    }
    
    // Get an array of values for a particular key
    func values(forKey key: String) -> [String] {
        let queryStatementString = "SELECT Value FROM CustomKeys WHERE Key = ?;"
        var queryStatement: OpaquePointer?
        var values: [String] = []

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (key as NSString).utf8String, -1, nil)

            while sqlite3_step(queryStatement) == SQLITE_ROW {
                if let value = sqlite3_column_text(queryStatement, 0) {
                    let valueString = String(cString: value)
                    values.append(valueString)
                }
            }
            sqlite3_finalize(queryStatement)
        } else {
            print("SELECT statement could not be prepared.")
        }

        if values.isEmpty {
            print("No values found for key: \(key).")
        }

        return values
    }

    // Get an array of entries for a specific keyboard type
    func read(forKeyboardType keyboardType: String? = nil) -> [(id: Int, key: String, value: String, keyboardType: String)] {
        var queryStatementString = "SELECT * FROM CustomKeys"
        if let keyboardType = keyboardType {
            queryStatementString += " WHERE KeyboardType = '\(keyboardType)'"
        }
        var queryStatement: OpaquePointer?
        var result: [(Int, String, String, String)] = []

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let key = String(cString: sqlite3_column_text(queryStatement, 1))
                let value = String(cString: sqlite3_column_text(queryStatement, 2))
                let keyboardType = String(cString: sqlite3_column_text(queryStatement, 3))
                result.append((id, key, value, keyboardType))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return result
    }
    
    // Get all the entries stored in the database
    func readAllValues() -> [(id: Int, key: String, value: String, keyboardType: String)] {
        let queryStatementString = "SELECT * FROM CustomKeys"
        var queryStatement: OpaquePointer?
        var result: [(Int, String, String, String)] = []
        
        // Prepare the SQL statement
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // Execute the query and iterate over the result set
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let key = String(cString: sqlite3_column_text(queryStatement, 1))
                let value = String(cString: sqlite3_column_text(queryStatement, 2))
                let keyboardType = String(cString: sqlite3_column_text(queryStatement, 3))
                result.append((id, key, value, keyboardType))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // Finalize and close the query statement
        sqlite3_finalize(queryStatement)
        
        return result
    }
    
    // Update value for a particular key using its id
    func updateValueUsingID(forID id: Int, newValue: String) {
        let updateStatementString = "UPDATE CustomKeys SET Value = ? WHERE ID = ?;"
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (newValue as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated value for ID \(id).")
                // Notify if needed
            } else {
                print("Could not update value for ID \(id).")
                // Handle error condition
            }
        } else {
            print("UPDATE statement could not be prepared.")
        }
        sqlite3_finalize(updateStatement)
    }

    // Delete a particular key using its id
    func delete(id: Int) {
        let deleteStatementString = "DELETE FROM CustomKeys WHERE Id = ?;"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
                NotificationCenter.default.post(name: NSNotification.Name("com.abKey.dataUpdated"), object: nil)
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared.")
        }
        sqlite3_finalize(deleteStatement)
    }

    // Close the database connection
    deinit {
        sqlite3_close(db)
    }
}
