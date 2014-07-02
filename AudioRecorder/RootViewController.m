//
//  RootViewController.m
//  AudioRecorder
//
//  Created by hdk on 2014. 7. 2..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

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
    // Do any additional setup after loading the view.
    
    // RecordViewController를 생성해서 recordViewController변수에 할당(저장)
    RecordViewController *viewController = [[RecordViewController alloc]initWithNibName:@"RecordViewController" bundle:nil];
    self.recordViewController = viewController;
    
    // infoButton뒤로 recordViewController를 넣습니다.
    [self.view insertSubview:viewController.view belowSubview:_infoButton];

    //    ARC프로젝트이므로 release는 하지 않습니다.
    //    [viewController release]
    
    // 책은 코드가 끝나고 [super viewDidLoad]를 했지만, 초기화시에는 [super viewDidLoad]를 먼저하고 현재 화면을 초기화 해주는 것이 기본입니다.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Public Methods
// infoButton 눌렸을때
- (IBAction)recordInfoClick:(id)sender
{
    // audioRecorderInfo 가 nil이면 초기화 시켜준다.
    // 미리 생성하지 않고 필요할때 생성하는 이유는 메모리 관리를 위해서 그렇게 한다.
    if (_audioRecorderInfo == nil) {
        AudioRecorderInfo *viewController = [[AudioRecorderInfo alloc] initWithNibName:@"AudioRecorderInfo" bundle:nil];
        self.audioRecorderInfo = viewController;
        
        // ARC프로젝트이므로 release는 하지 않습니다.
        // [viewController release];
    }
    
    UIView *recordView = _recordListViewController.view; // 녹음 리스트 뷰를 지역변수로 선언
    UIView *audioRecorderInfoView = _audioRecorderInfo.view; // 녹음기 앱정보 뷰를 지역변수로 선언
    
    // 화면전환 시작
    [UIView beginAnimations:nil context:NULL]; // 애니메이션 정의 시작
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:recordView.subviews?UIViewAnimationTransitionFlipFromRight:UIViewAnimationTransitionFlipFromLeft
                           forView:self.view
                             cache:YES]; // 화면전환 효과 설정
    
    // 슈퍼뷰에서 제거하여 더이상 화면에 나타나지 않게 합니다.
    if (recordView.superview != nil) {
        [recordView removeFromSuperview];
        [self.view addSubview:audioRecorderInfoView];
    }
    else {
        [audioRecorderInfoView removeFromSuperview];
        [self.view insertSubview:recordView belowSubview:_infoButton];
    }
    [UIView commitAnimations]; // 에니메이션 종료
}

- (IBAction)audioListClick:(id)sender
{
    if (_recordListViewController == nil) {
        RecordListViewController *viewController = [[RecordListViewController alloc]initWithNibName:@"RecordListViewController" bundle:nil];
        self.recordListViewController = viewController;
        // [viewController release];
    }
    
    UIView *recordView = _recordListViewController.view; // 녹음 리스트 뷰를 지역변수로 선언
    UIView *recordListView = _recordListViewController.view; // 녹음기 앱정보 뷰를 지역변수로 선언

    // 화면 전환 설정
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:recordView.subviews?UIViewAnimationTransitionCurlUp:UIViewAnimationTransitionCurlDown
                           forView:self.view
                             cache:YES]; // 화면전환 효과 설정
    
    if (recordView.superview != nil) {
        [recordView removeFromSuperview];
        [self.view addSubview:recordListView];
        
        [self.recordListViewController viewDidAppear:YES];
        [self.recordViewController viewDidAppear:NO];
    }
    else {
        [recordListView removeFromSuperview];
        [self.view insertSubview:recordView belowSubview:_infoButton];
        [self.recordListViewController viewDidAppear:NO];
        [self.recordViewController viewDidAppear:YES];
    }
    
    [UIView commitAnimations]; // 애니메이션 종료

}


@end
