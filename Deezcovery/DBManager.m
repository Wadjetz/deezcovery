//
//  DBManager.m
//  Deezcovery
//
//  Created by Vuzi on 03/01/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import "DBManager.h"

@interface DBManager()

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *results;

-(void)copyDatabaseIntoDocumentsDirectory;
-(void)runQuery:(const char*)query isQueryExecutable:(BOOL)queryExecutable;

@end


@implementation DBManager

-(void) copyDatabaseIntoDocumentsDirectory {
    
    NSString* destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // The file doesn't exist
    if([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        if(!error) {
            NSLog(@"Error : %@", [error description]);
        }
    }
}


-(instancetype) initWithDatabaseFilename:(NSString*) dbFilename {
    self = [super init];
    
    if(self) {
        // Set the document directory
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // Set the database filename
        self.databaseFilename = dbFilename;
        
        [self copyDatabaseIntoDocumentsDirectory];
    }
    
    return self;
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable {
    // Create the sqlite object
    sqlite3 *sqliteDatabase;
    
    // Database path
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];

    // Init array result
    if(self.results) {
        [self.results removeAllObjects];
        self.results = nil;
    }
    
    self.results = [[NSMutableArray alloc] init];
    
    if(self.arrColumnNames) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    // SQL query
    int openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqliteDatabase);
    
    if(openDatabaseResult == SQLITE_OK) {
        sqlite3_stmt *compiledStatement;
        
        int preparedStatementResult = sqlite3_prepare_v2(sqliteDatabase, query, -1, &compiledStatement, NULL);
        
        if(preparedStatementResult == SQLITE_OK) {
            
            if(queryExecutable) {
                //  Execute the query
                int executeQueryRequest = sqlite3_step(compiledStatement);
                
                if(executeQueryRequest == SQLITE_DONE) {
                    // Keep the affected rows
                    self.affectedRows = sqlite3_changes(sqliteDatabase);
                    
                    // Keep the last ID
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqliteDatabase);
                    
                    // Close and free
                    sqlite3_finalize(compiledStatement);
                    sqlite3_close(sqliteDatabase);
                    
                    return;
                }
            } else {
                NSMutableArray *arrDataRow;
                
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    for(int i = 0; i < totalColumns; i++) {
                        // Column data
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        if(dbDataAsChars) {
                            [arrDataRow addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // Column name
                        if(self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    if(arrDataRow.count > 0) {
                        [self.results addObject:arrDataRow];
                    }
                    
                    // Close and free
                    sqlite3_finalize(compiledStatement);
                    sqlite3_close(sqliteDatabase);
                    
                    return;
                }
            }
        }
    }
    
    NSLog(@"Error SQLite : %s", sqlite3_errmsg(sqliteDatabase));
}

// Load all the artists form the database
-(ArtistList*) loadArtistsFromDBfrom:(int) from size:(int)size {
    
    
    
    return nil;
}

// Load an artist form the database with its ID
-(Artist*) loadArtistFromDB:(int) ID {
    
    
    
    return nil;
}

// Save an artist from the database
-(void) saveArtist:(Artist*) artist {
    
}

// Delete an artist from the database
-(void) deleteArtist:(Artist*) artist  {
    
}


@end
