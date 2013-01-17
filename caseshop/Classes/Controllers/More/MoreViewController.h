//
//  MoreViewController.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 24..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"
#import "MailController.h"

@interface MoreViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>{
    IBOutlet UITableView *_tableView;
}

@end
