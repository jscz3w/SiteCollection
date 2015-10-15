//
//  SharedDataBaseManager.m
//  SiteCollection
//
//  Created by WangZhengHong on 15/10/13.
//  Copyright © 2015年 WangZhengHong. All rights reserved.
//

#import "SharedDataBaseManager.h"


@implementation SharedDataBaseManager

static FMDatabase * db=nil;
SysData initData;

- (BOOL) isTableOK:(NSString *)tableName DbName:(FMDatabase *) db2
{
    FMResultSet *rs = [db2 executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        
        NSInteger count = [rs intForColumn:@"count"];
        //NSLog(@"isTableOK %ld", count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}



+ (SharedDataBaseManager *)sharedManager
{
    static SharedDataBaseManager *sharedDbManagerInstance = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedDbManagerInstance = [[self alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        //dbPath： 数据库路径，在Document中。
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"url.db"];
        NSLog(@"%@",dbPath);
        db= [FMDatabase databaseWithPath:dbPath] ;
        if (![db open]) {
            NSLog(@"Could not open db.");
            return ;
        }
        else{
            //NSLog(@"Open db.");
            
            
            if (![sharedDbManagerInstance isTableOK:@"url" DbName:db]) {
                
                [db executeUpdate:@"CREATE TABLE url (id text, url text,url_txt text,hits integer,px integer)"];
                [db executeUpdate:@"INSERT INTO url (id,url,url_txt) VALUES (?,?,?)",@"1",@"http://www.sohu.com",@"sohu",1,1] ;
                [db executeUpdate:@"INSERT INTO url (id,url,url_txt) VALUES (?,?,?)",@"2",@"http://www.sina.cn",@"sina",1,2] ;
                
                [db executeUpdate:@"INSERT INTO url (id,url,url_txt) VALUES (?,?,?)",@"3",@"http://www.baidu.com",@"百度",1,3] ;
            }
            
          if (![sharedDbManagerInstance isTableOK:@"person_url" DbName:db]) {
                [db executeUpdate:@"CREATE TABLE person_url (id text, url text,url_txt text,hits integer,px integer)"];
                [db executeUpdate:@"INSERT INTO person_url (id,url,url_txt) VALUES (?,?,?)",@"1",@"http://10.229.128.25:8080/mis",@"MIS",1,1] ;
                [db executeUpdate:@"INSERT INTO person_url (id,url,url_txt) VALUES (?,?,?)",@"2",@"http://10.229.128.8",@"公司主页",1,2] ;
                [db executeUpdate:@"INSERT INTO person_url (id,url,url_txt) VALUES (?,?,?)",@"3",@"http://portalwg.shenhua.cc/oimdiy/login.jsp?appname=webcenter",@"邮箱",1,3] ;
                
                
                [db executeUpdate:@"INSERT INTO person_url (id,url,url_txt) VALUES (?,?,?)",@"3",@"http://www.shenhuagroup.com.cn",@"集团",1,4] ;

                
            }
            
            if (![sharedDbManagerInstance isTableOK:@"sys_values" DbName:db]) {
                [db executeUpdate:@"CREATE TABLE sys_values (id text, font_size text,open_stuts text,sort_status text,row_h text,show_status)"];
                [db executeUpdate:@"INSERT INTO sys_values (id,font_size,open_stuts,sort_status,row_h,show_status) VALUES (?,?,?,?,?,?)",@"1",@"20.0",@"0",@"0",@"40",@"1"] ;
            }
           
            
        }

        
        
        
    });
    return sharedDbManagerInstance;
}
-(FMDatabase * )returnShareDb{
    
    if (db!=nil) {
        return db;
    }
    return nil;
}

-(SysData )returnInitValues{
    if (db!=nil){
    FMResultSet *rs=[db executeQuery:@"SELECT * FROM sys_values"];
    while ([rs next]){
        //NSLog(@"font_size == %@",[rs stringForColumn:@"font_size"]);
        initData.font_size=[[rs stringForColumn:@"font_size"] floatValue];;
        initData.open_stuts=[[rs stringForColumn:@"open_stuts"] intValue];
        
        initData.sort_status=[[rs stringForColumn:@"sort_status"] intValue];
        initData.show_status=[[rs stringForColumn:@"show_status"] intValue];
        initData.row_height=[[rs stringForColumn:@"row_h"] intValue];

        //NSLog(@"open_stuts=%d",initData.open_stuts);
        
    }
    }
    return initData;
}
-(void)closeDB{
    if (db!=nil){
        [db close];
    }
    
}


@end