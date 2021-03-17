//
//  DBManager.h
//  breaktimeapp
//
//  Created by Michael Tiel on 03/03/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//

#ifndef breaktimeapp_DBManager_h
#define breaktimeapp_DBManager_h

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *columnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long lastInsertedRowID;
@property (nonatomic, strong) NSString *lastQuery;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

-(NSArray *)getQuery:(NSString *)query;

-(void)execQuery:(NSString *)query;

@end


#endif
