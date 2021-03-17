//
//  DBManager.m
//  breaktimeapp
//
//  Created by Michael Tiel on 03/03/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"
#import <sqlite3.h>

@interface DBManager()

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *results;

-(NSString *)getDBFile;
-(void)copyDBIntoDirectory;
-(void)prepareBuffers;

-(BOOL)query:(const char *)query isExecutable:(BOOL)isExecutable;


@end

@implementation DBManager

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    if (self)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        self.databaseFilename = dbFilename;
        

        [self copyDBIntoDirectory];
    }
    return self;
}

-(NSString *)getDBFile
{
    return [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
}

-(void)copyDBIntoDirectory
{
    NSFileManager *man = [NSFileManager defaultManager];
    NSString *fullPath = [self getDBFile];
    if ([man fileExistsAtPath:fullPath])
    {
        return;
    }
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *sourcePath = [[bundle resourcePath] stringByAppendingPathComponent:self.databaseFilename];
    NSError *error;
    
    [man copyItemAtPath:sourcePath toPath:fullPath error:&error];

    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)prepareBuffers
{

    if (self.results != nil) {
        [self.results removeAllObjects];
        self.results = nil;
    }
    self.results = [[NSMutableArray alloc] init];
    
    // Initialize the column names array.
    if (self.columnNames != nil) {
        [self.columnNames removeAllObjects];
        self.columnNames = nil;
    }
    self.columnNames = [[NSMutableArray alloc] init];
}

-(BOOL)query:(const char *)query isExecutable:(BOOL)isExecutable
{
    sqlite3 *dbconn;
    [self prepareBuffers];
    
    NSString *dbPath = [self getDBFile];
    self.lastQuery = [NSString stringWithUTF8String:query];
    
    BOOL openConn = sqlite3_open([dbPath UTF8String], &dbconn);
    if (openConn != SQLITE_OK)
    {
        NSLog(@"Couldnt open DB");
        return NO;
    }
    
    sqlite3_stmt *statement;
    BOOL prepareStatement =  sqlite3_prepare_v2(dbconn, query, -1, &statement, NULL);
    if (prepareStatement != SQLITE_OK)
    {
        NSLog(@"Couldnt prepare statement");
        return NO;
    }
    
    if (isExecutable)
    {
        const int executeQueryResults = sqlite3_step(statement);
        if (executeQueryResults == SQLITE_DONE)
        {
            self.affectedRows = sqlite3_changes(dbconn);
            self.lastInsertedRowID = sqlite3_last_insert_rowid(dbconn);
        }
        else
        {
            NSLog(@"DB Error: %s", sqlite3_errmsg(dbconn));
            return NO;
        }
        
    }
    else
    {
        NSMutableArray *temp;
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            temp = [[NSMutableArray alloc] init];
            int nrofColumns = sqlite3_column_count(statement);
            for (int i=0; i < nrofColumns; ++i)
            {
                char *dbData = (char *)sqlite3_column_text(statement, i);

                if (dbData != NULL)
                {
                    [temp addObject:[NSString stringWithUTF8String:dbData]];
                    
                }
                
                
                if (self.columnNames.count != nrofColumns)
                {
                    dbData = (char *)sqlite3_column_name(statement, i);
                    [self.columnNames addObject:[NSString stringWithUTF8String:dbData]];
                }
            }
            
            if (temp.count > 0)
            {
                [self.results addObject:temp];
            }
        }
    }
    return YES;
}


-(NSArray *)getQuery:(NSString *)query
{
    BOOL queryIsOk = [self query:[query UTF8String] isExecutable:NO];
    if (queryIsOk)
    {
        return self.results;
    }
    return nil;
}

-(void)execQuery:(NSString *)query
{
    [self query:[query UTF8String] isExecutable:YES];
    
}




@end