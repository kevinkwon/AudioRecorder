//
//  RecordDataBase.m
//  AudioRecorder
//
//  Created by hdk on 2014. 7. 5..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "RecordDataBase.h"

@implementation RecordDataBase

- (void)DataBaseConnection:(sqlite3 **)tempDataBase // 데이터 베이스 연결
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES); // Documents폴더 위치를 구합니다.
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *myPath = [documentDirectory stringByAppendingPathComponent:@"RecordDB.sqlite"];
    
    // 데이터 베이스 연결
    if (sqlite3_open([myPath UTF8String], tempDataBase) != SQLITE_OK) {
        *tempDataBase = nil;
        return;
    }
}

- (void)getRecordList // 녹음파일 정보 검색
{
    NSString *pSEQ; // 녹음 파일 ID
    NSNumber *pRecordingTM; // 녹음 시간
    NSString *pRecordFileNM; // 파일명
    sqlite3 *pDataBase;
    sqlite3_stmt *statement = nil;
    
    [self DataBaseConnection:&pDataBase]; // 데이터 베이스 연결

    if (pDataBase == nil) {
        NSLog(@"Error Message : s", sqlite3_errmsg(pDataBase));
        return;
    }
    
    // SQL text를 prepared로 변환합니다.
    const char *sql = "SELECT SEQ, RecordingTM, RecordFileNM FROM RecordTB ORDER BY SEQ =?";

    if (sqlite3_prepare_v2(pDataBase, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error Messages:'%s'", sqlite3_errmsg(pDataBase));
        sqlite3_close(pDataBase);
        pDataBase = nil;
        return;
    }
    
    // 조건을 바인딩합니다.
    sqlite3_bind_text(statement, 1, [pSEQ UTF8String], -1, SQLITE_TRANSIENT);
    
    // 쿼리를 실행합니다.
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSLog(@"Error Messages:'%s'", sqlite3_errmsg(pDataBase));
    }
    sqlite3_reset(statement); // 객체를 초기화 합니다.
    sqlite3_finalize(statement); // 객체를 닫습니다.
    sqlite3_close(pDataBase); // 데이터베이스를 닫습니다.

    pDataBase = nil;
}

- (void)insertRecordData:(NSString *)pSEQ RecordingTM:(NSInteger)pRecordingTM RecordFileNM:(NSString *)pRecordFileNM // 저장
{
    
}

- (void)deleteRecordData:(NSString *)pSEQ // 삭제
{
    
}


@end
