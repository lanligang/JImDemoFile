//
//  ChatContaintViewController.m
//  JIMTest
//
//  Created by ios2 on 2017/11/30.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "ChatContaintViewController.h"
//文字消息
#import "ChatTextTableViewCell.h"
//语音消息
#import "ChatVoiceTableViewCell.h"
//时间间隔
#import "ChatTimeTableViewCell.h"
//聊天图片cell
#import "ChatImageTableViewCell.h"


#import "ChatBaseModel.h"
#import "CDPAudioRecorder.h"

@interface ChatContaintViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UIGestureRecognizerDelegate>


@property (nonatomic,strong)UIRefreshControl *refreshControl;
@property (nonatomic,strong)UITableView *tableView;


@property (nonatomic,strong)NSMutableArray *dataSource;

//------------ 页码 -----------//
@property(nonatomic,assign)NSInteger pageNum;
//------------每一页的上线 ---------//
@property(nonatomic,assign)NSInteger limitNum;

@end

@implementation ChatContaintViewController

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
 if (self.dataSource.count>0)
{
    if (self.dataSource)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
 }
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    
}

#pragma mark 系统的下拉刷新
- (void)creatRefreshing
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refreshAction)forControlEvents:UIControlEventValueChanged];
}
-(void)refreshAction
{
    _pageNum+=_limitNum;
    __weak ChatContaintViewController *weakSelf = self;
    [self requestMsgFromLocal:^{
        [weakSelf.tableView reloadData];
        [weakSelf.refreshControl endRefreshing];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    //创建下拉刷新
    [self creatRefreshing];

    if (@available (iOS 10.0,*)) {
        self.tableView.refreshControl = self.refreshControl;
    }else{
        [self.tableView addSubview:self.refreshControl];
    }
    
    if (@available (iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //设置加载一页的数据为 20
    _limitNum = 20;
    
    //发送消息的回执
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(messageSendCallBackNotification:) name:@"messageSendCallBack" object:nil];
    //发送消息的回执
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessageNotification:) name:@"receiveMessage" object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

-(void)setConversation:(JMSGConversation *)conversation
{
    _conversation = conversation;
    [self loadMessage];
    [self.tableView reloadData];
}

//获取本地信息 异步获取
-(void)requestMsgFromLocal:(void(^)(void))completion;
{
    __weak ChatContaintViewController *weakSelf  = self;
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [weakSelf loadMessage];
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            //异步返回主线程，根据获取的数据，更新UI
            dispatch_async(mainQueue, ^{
                if (completion) {
                    completion();
                }
            });
    });
}
//直接获取
-(void)loadMessage
{
    NSArray * msgArray =  [self.conversation messageArrayFromNewestWithOffset:@(_pageNum) limit:@(_limitNum)];
    NSMutableArray *tmpArray = [self.dataSource mutableCopy];
    if (self.pageNum==0)
    {
        //移除所有的数据
        [tmpArray removeAllObjects];
    }
    //信息条数加到了多少条

 
    
    NSInteger lastMsgTimeLine = 0;
    for (int i = 0; i<msgArray.count; i++)
    {
        JMSGMessage *message = msgArray[i];
        ChatBaseModel *model = [[ChatBaseModel alloc]init];
        model.isSender = !message.isReceived;
        model.fromId = message.fromName;
        //这是服务器端下发消息时的真实时间戳，单位为毫秒
        if (i==0) {
            lastMsgTimeLine = [message.timestamp integerValue];
        }else{
          //时间戳的差距
          NSInteger spaceTimeLine =  lastMsgTimeLine - [message.timestamp integerValue];
            if (spaceTimeLine>(1*60*1000))
            {
                ChatBaseModel *model = [[ChatBaseModel alloc]init];
                model.messageType = timeLineType;
                //记录前一个的
                model.jMessage = msgArray[i-1];
                [tmpArray insertObject:model atIndex:0];
                lastMsgTimeLine = [message.timestamp integerValue];
            }
        }
        model.jMessage = message;
        if (message.contentType==kJMSGContentTypeText)
        {
            //文本消息类型
            JMSGTextContent *textContent  =(JMSGTextContent *)message.content;
            model.message = textContent.text;
            //是否是收到的也就是是不是发送者 的对立面
        }else if (message.contentType==kJMSGContentTypeVoice){
            //语音消息
            JMSGVoiceContent *voiceContent = (JMSGVoiceContent *)message.content;
            model.voiceDuration = [voiceContent.duration floatValue]*100.0f;
        }else if (message.contentType==kJMSGContentTypeImage){
            //图片消息
            //JMSGImageContent *imageContent = (JMSGImageContent *)message.content;
            model.messageType = photoType;
        }

        [tmpArray insertObject:model atIndex:0];

    }
    self.dataSource = tmpArray;
    self.pageNum += msgArray.count;
}
/**
 * 通知 的noti.object  NSDictionary @{message:JMSGMessage类型,error :NSError  error 存在标识出错 根据Tool 判断 }
 */
-(void)messageSendCallBackNotification:(NSNotification *)noti
{
    if (noti.object)
    {
        NSDictionary *dic = noti.object;
        NSError *error = dic[@"error"];
//        JMSGMessage *message = dic[@"message"];
//        JMSGUser *user = self.conversation.target;
        if (error)
        {
         //消息发送出现问题
        }else{
            _pageNum = 0;
            __weak ChatContaintViewController *weakSelf = self;
            [self requestMsgFromLocal:^{
                if (weakSelf.dataSource.count>0) {
                    [weakSelf.tableView reloadData];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
                    [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }else{
                    [weakSelf.tableView reloadData];
                }
            }];
        }
    }
}

-(void)receiveMessageNotification:(NSNotification *)noti
{
    if (noti.object)
    {
        NSDictionary *dic = noti.object;
        NSError *error = dic[@"error"];
        JMSGMessage *message = dic[@"message"];
        JMSGUser *user = self.conversation.target;
        if (![message.fromName isEqualToString:user.username])
        {//接收到的消息是不是当前会话的者的消息
            return;
        }
        if (error)
        {
          //消息发送出现问题
        }else{
            _pageNum = 0;
            __weak ChatContaintViewController *weakSelf = self;
            [self requestMsgFromLocal:^{
                if (weakSelf.dataSource.count>0) {
                    [weakSelf.tableView reloadData];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
                    [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }else{
                    [weakSelf.tableView reloadData];
                }
            }];
        }
    }
}

-(void)sendMessage:(id)message
{
    if ([message isKindOfClass:[NSString class]])
    {
        [self.conversation sendTextMessage:message];
	 }else if ([message isKindOfClass:[RecorderModel class]]){
         RecorderModel * recorderModel =(RecorderModel *)message;
         NSData *data = [NSData dataWithContentsOfFile:recorderModel.localUrl];
      [self.conversation sendVoiceMessage:data duration:@(recorderModel.duration/100.0)];
     }else if ([message isKindOfClass:[UIImage class]]){
         //这里应该发送图片的暂时先使用该值
         [self.conversation sendImageMessage:UIImageJPEGRepresentation(message, 1)];
     }
    /*
    _pageNum = 0;
    __weak ChatContaintViewController *weakSelf = self;
    [self requestMsgFromLocal:^{
        if (weakSelf.dataSource.count>0) {
            [weakSelf.tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }else{
            [weakSelf.tableView reloadData];
        }
    }];
     */
}

#pragma mark 点击tableView
-(void)tapAction:(UITapGestureRecognizer *)tap
{
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(didTapChatMessageView:)])
        {
            [_delegate didTapChatMessageView:self];
        }
        return NO;
    }else{
        return YES;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatBaseTableViewCell *cell = nil;
 ChatBaseModel *model = self.dataSource[indexPath.row];
 switch (model.messageType) {
  case TextType:
	//文字模式
	    cell =  [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
	break;
	  case voiceType:
	//声音模式
	cell =  [tableView dequeueReusableCellWithIdentifier:@"VoiceCell" forIndexPath:indexPath];
	break;
	case photoType:
	//图片模式
         cell = [tableView dequeueReusableCellWithIdentifier:@"chatImageCell" forIndexPath:indexPath];
	break;
    case timeLineType:
        cell  =  [tableView dequeueReusableCellWithIdentifier:@"timeLineCell" forIndexPath:indexPath];
    break;
         
  default:
	break;
 }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (model.messageType!=timeLineType) {
            cell.chatModel = self.dataSource[indexPath.row];
    }else{
        ChatTimeTableViewCell *timeCell = (ChatTimeTableViewCell *)cell;
        timeCell.model = model;
    }

    cell.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatBaseModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[ChatTextTableViewCell class] forCellReuseIdentifier:@"TextCell"];
        
        [_tableView registerClass:[ChatVoiceTableViewCell class] forCellReuseIdentifier:@"VoiceCell"];
        
        [_tableView registerClass:[ChatTimeTableViewCell class] forCellReuseIdentifier:@"timeLineCell"];
        
        [_tableView registerClass:[ChatImageTableViewCell class] forCellReuseIdentifier:@"chatImageCell"];
        
    }
    return _tableView;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
