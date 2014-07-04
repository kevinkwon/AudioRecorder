//
//  RecordDataBase.h
//  AudioRecorder
//
//  Created by hdk on 2014. 7. 5..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

// RecordDataBase 클래스는 4개의 메서드로 구성됩니다.
@interface RecordDataBase : NSObject
{
    NSMutableArray *memoListArray; // 데이터베이스에서 검색된 녹음 파일 정보를 저장하는 Array객체입니다.
}

- (void)DataBaseConnection:(sqlite3 **)tempDataBase; // 데이터 베이스 연결
- (void)getRecordList; // 녹음파일 정보 검색
- (void)insertRecordData:(NSString *)pSEQ RecordingTM:(NSInteger)pRecordingTM RecordFileNM:(NSString *)pRecordFileNM; // 저장
- (void)deleteRecordData:(NSString *)pSEQ; // 삭제
@end
