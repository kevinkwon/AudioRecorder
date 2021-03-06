//
//  RecordListViewController.m
//  AudioRecorder
//
//  Created by hdk on 2014. 7. 2..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "RecordListViewController.h"
#import "UIMemoListCell.h"

#define ROW_HEIGHT 65

@interface RecordListViewController ()

@end

@implementation RecordListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _pDataBase = [[RecordDataBase alloc] init];
    [_pListView setRowHeight:ROW_HEIGHT]; // 셀의 높이 지정
    
}

// 데이터를 로드 하는 부분을 추가한다.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadRecordList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadRecordList
{
    [_pDataBase getRecordList]; // 데이터베이스 조회
    [_pListView reloadData]; // 테이블뷰 새로 고침
}

#pragma mark - UITableView Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_pDataBase.memoListArray count]; // 데이터베이스에 저장된 녹음 파일 개수 리턴
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MemoListCell"; // 재활용을 위한 셀 식별자
    
    UIMemoListCell *cell = (UIMemoListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"UIMemoListCell" owner:nil options:nil];
        cell = [arr objectAtIndex:0];
        // 또는
//        for (id object in arr) {
//            if ([object isKindOfClass:[UIMemoListCell class]]) {
//                cell = (UIMemoListCell *)object;
//            }
//        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *pSeq = [[_pDataBase.memoListArray objectAtIndex:indexPath.row] objectForKey:@"SEQ"];

    int pRecordingTime = [(NSNumber *)[[_pDataBase.memoListArray objectAtIndex:indexPath.row] objectForKey:@"RecordingTM"] intValue];
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%@-%@-%@",
                           [pSeq substringWithRange:NSMakeRange(0, 4)],
                           [pSeq substringWithRange:NSMakeRange(4, 2)],
                           [pSeq substringWithRange:NSMakeRange(6, 2)]];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@시 %@분 %@초",
                           [pSeq substringWithRange:NSMakeRange(8, 2)],
                           [pSeq substringWithRange:NSMakeRange(10, 2)],
                           [pSeq substringWithRange:NSMakeRange(12, 2)]];
    
    cell.recordingTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",
                                    (pRecordingTime/3600),
                                    (pRecordingTime % 3600) / 60,
                                    (pRecordingTime % 60)];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *pSEQ = [[_pDataBase.memoListArray objectAtIndex:indexPath.row] objectForKey:@"SEQ"];
    [_pDataBase deleteRecordData:pSEQ];// 데이터 베이스의 삭제
    [_pDataBase.memoListArray removeObjectAtIndex:indexPath.row];
    [_pListView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - AVAudioPlayer Delegate Methods
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"재생이 끝남");
//    [self.pAudioPlayer release];
    _pAudioPlayer = nil;
    _playerButton.title = @"듣기";
}

- (IBAction)AudioPlayingClick:(id)sender
{
    NSLog(@"듣기 버튼 눌림");
    int index = (int)[[_pListView indexPathForSelectedRow] row];
    
    if (_pDataBase.memoListArray.count == 0) {
        NSLog(@"들을 수 있는 목록이 없으므로 리턴");
        return;
    }
    
    NSString *pRecordFileName = [[_pDataBase.memoListArray objectAtIndex:index] objectForKey:@"RecordFileNM"];
    NSLog(@"들을려는 파일이름 : %@", pRecordFileName);
    
    if (_pAudioPlayer == nil || !_pAudioPlayer.playing)
    {
        NSLog(@"오디오 플레이어가 없거나, 있지만 듣는 중이 아닌경우는 준비하고 실행한다.");
        _pAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:pRecordFileName] error:nil];
        _pAudioPlayer.delegate = self;
        [_pAudioPlayer prepareToPlay];
        [_pAudioPlayer play];
        _playerButton.title = @"멈춤";
    }
    else {
        NSLog(@"듣는 중이라면, 플레이어를 정지하고, '듣기'로 버튼 타이틀을 바꾼다.");
        [_pAudioPlayer stop];
        _playerButton.title = @"듣기";
        //[pAudioPlayer release];
        _pAudioPlayer = nil;
    }
}
@end
