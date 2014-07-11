//
//  RecordDataBase.m
//  AudioRecorder
//
//  Created by hdk on 2014. 7. 5..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "RecordDataBase.h"

@implementation RecordDataBase

- (void)dataBaseConnection:(sqlite3 **)tempDataBase // 데이터 베이스 연결
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); // Documents폴더 위치를 구합니다.
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
    
    [self dataBaseConnection:&pDataBase]; // 데이터 베이스 연결

    if (pDataBase == nil) {
        NSLog(@"Error Message : '%s'", sqlite3_errmsg(pDataBase));
        return;
    }
    
    // SQL text를 prepared statement로 변환합니다.
    const char *sql = "SELECT SEQ, RecordingTM, RecordFileNM FROM RecordTB ORDER BY SEQ =?";
    if (sqlite3_prepare_v2(pDataBase, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error Messages:'%s'", sqlite3_errmsg(pDataBase));
        sqlite3_close(pDataBase);
        pDataBase = nil;
        return;
    }
    
    if (_memoListArray == nil) {
        NSLog(@"메모 리스트배열이 없으면 초기화해줌");
        _memoListArray = [[NSMutableArray alloc]init];
    }
    
    if (_memoListArray != nil) {
        NSLog(@"있으면 값을 전부 지워줌");
        [_memoListArray removeAllObjects];
        
        NSLog(@"쿼리 실행");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            pSEQ = [[NSString alloc]initWithString:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)]];
            
            // 녹음시간
            pRecordingTM = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
            // 파일명
            pRecordFileNM = [[NSString alloc]initWithString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
            // 검색 결과를 ARRAY객체에 담습니다.
            [_memoListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:pSEQ, @"SEQ", pRecordingTM, @"RecordingTM", pRecordFileNM, @"RecordFileNM", nil]];
        }
    }

    sqlite3_reset(statement); // 객체를 초기화 합니다.
    sqlite3_finalize(statement); // 객체를 닫습니다.
    sqlite3_close(pDataBase); // 데이터베이스를 닫습니다.

    pDataBase = nil;
}

- (void)insertRecordData:(NSString *)pSEQ RecordingTM:(NSInteger)pRecordingTM RecordFileNM:(NSString *)pRecordFileNM // 저장
{
    NSLog(@"녹음파일 정보를 DB에 저장 %@, %d, %@", pSEQ, pRecordingTM, pRecordFileNM);

    sqlite3_stmt *statement = nil;
    sqlite3 *pDataBase;
    [self dataBaseConnection:&pDataBase]; // 데이터 베이스 연결
    
    if (pDataBase == nil) {
        NSLog(@"Error Messages:'%s'", sqlite3_errmsg(pDataBase));
        return;
    }
    
    // SQL text를 prepared statement로 변환합니다.
    const char *sql = "INSERT INTO RecordTB(SEQ, RecordingTM, RecordFileNM) VALUES(?, ?, ?)";
    if (sqlite3_prepare_v2(pDataBase, sql, -1, &statement, NULL) != SQLITE_OK) {
        sqlite3_close(pDataBase);
        pDataBase = nil;
        return;
    }

    // 조건을 바인딩합니다.
    sqlite3_bind_text(statement, 1, [pSEQ UTF8String], -1, SQLITE_TRANSIENT); // 파일ID
    sqlite3_bind_int(statement, 2, pRecordingTM); // 녹음시간
    sqlite3_bind_text(statement, 3, [pRecordFileNM UTF8String], -1, SQLITE_TRANSIENT); // 파일 이름
    
    // 쿼리를 실행합니다.
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSLog(@"Error Messages:'%s'", sqlite3_errmsg(pDataBase));
    }

    sqlite3_reset(statement); // 객체를 초기화 합니다.
    sqlite3_finalize(statement); // 객체를 닫습니다.
    sqlite3_close(pDataBase); // 데이터베이스를 닫습니다.
    
    pDataBase = nil;
}

- (void)deleteRecordData:(NSString *)pSEQ // 삭제
{
    sqlite3_stmt *statement = nil;
    sqlite3 *pDataBase;
    [self dataBaseConnection:&pDataBase]; // 데이터베이스 연결

    if (pDataBase == nil) {
        NSLog(@"Error Messages:'%s'", sqlite3_errmsg(pDataBase));
        return;
    }
    // SQL text를 prepared statement로 변환합니다.
    const char *sql = "DELETE FROM RecordTB WHERE SEQ = ?";
    if (sqlite3_prepare_v2(pDataBase, sql, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error Messages:'%s'", sqlite3_errmsg(pDataBase));
        sqlite3_close(pDataBase);
        pDataBase = nil;
        return;
    }
    
    // 조건을 바인딩 합니다.
    sqlite3_bind_text(statement, 1, [pSEQ UTF8String], -1, SQLITE_TRANSIENT); // 파일ID
    // 쿼리 실행
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSLog(@"Error Messages:'%s'", sqlite3_errmsg(pDataBase));
    }
    
    sqlite3_reset(statement); // 객체를 초기화 합니다.
    sqlite3_finalize(statement); // 객체를 닫습니다.
    sqlite3_close(pDataBase); // 데이터베이스를 닫습니다.
    
    pDataBase = nil;
}


@end
