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
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.abKey.promact") else {
            print("App Group container is not available.")
            return
        }
        let fileURL = containerURL.appendingPathComponent("CustomKeyboard.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
    }
    
    // Create the table if it doesn't already exist
    private func createTable() {
//        let createTableString = "CREATE TABLE IF NOT EXISTS CustomKeys(Id INTEGER PRIMARY KEY AUTOINCREMENT, Key TEXT, Value TEXT);"
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
                // Key does not exist, insert new
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

    func updateValue(forKey key: String, newValue: String) {
        let updateStatementString = "UPDATE CustomKeys SET Value = ? WHERE Key = ?;"
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (newValue as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (key as NSString).utf8String, -1, nil)
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated value.")
                // Notify if needed
            } else {
                print("Could not update value.")
                // Handle error condition
            }
        } else {
            print("UPDATE statement could not be prepared.")
            // Handle error condition
        }
        sqlite3_finalize(updateStatement)
    }

    
    func update( key: String, value: String) {
        let updateStatementString = "UPDATE CustomKeys SET Key = ?, Value = ? WHERE Id = ?;"
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (key as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (value as NSString).utf8String, -1, nil)
//            sqlite3_bind_int(updateStatement, 3, Int32(id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
                NotificationCenter.default.post(name: NSNotification.Name("com.abKey.dataUpdated"), object: nil)
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared.")
        }
        sqlite3_finalize(updateStatement)
    }

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
