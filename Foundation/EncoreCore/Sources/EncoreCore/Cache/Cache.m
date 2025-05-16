//
//  Cache.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "Cache.h"

@implementation Cache
+ (instancetype _Nonnull)shared {
    static Cache* _Nonnull sharedInstance = nil;
    static dispatch_once_t onceToken = 0;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[Cache alloc] init];
    });

    return sharedInstance;
}

- (instancetype _Nonnull)init {
    self = [super init];

    if (self) {
        [self openDatabase];
        [self prepareTables];
    }

    return self;
}

- (void)openDatabase {
    _databaseFilePath = [@"/Users/agoettlicher/Downloads/" stringByAppendingPathComponent:@"cache.sqlite"];

    if (SQLITE_OK != sqlite3_open([_databaseFilePath UTF8String], &_database)) {
        NSLog(@"bruh not open");
    }
}

- (void)prepareTables {
    const char* sql = "CREATE TABLE IF NOT EXISTS cache (id INT PRIMARY KEY);";
    char* errorMessage;
    if (SQLITE_OK != sqlite3_exec(_database, sql, NULL, NULL, &errorMessage)) {
        NSLog(@"bruh table smth %s", errorMessage);
    }
}

- (void)dealloc {
    sqlite3_close(_database);
}
@end
