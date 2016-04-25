//
//  ViewController.m
//  OperationQueue
//
//  Created by Gopal.Vaid on 18/04/16.
//  Copyright © 2016 Gopal.Vaid. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#define app ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface ViewController ()

// a bunch of objects which implement those methods

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
    NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
    
    //Example:  add operation on NSOperation queue using block
    
//    [myQueue addOperationWithBlock:^{
//        // Background work
//        [self background];
//        NSLog(@"background");
//        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            // Main thread work (UI usually)
//            [self setUpUI];
//             NSLog(@"thread");
//        }];
//    }];
    
    
    // Example: Add operation using  NSOperation subclass (i.e. NSBlockOperation and NSInvocationOperation) using block
    
    __block NSData *dataFromServer = nil;
    NSBlockOperation *downloadOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakDownloadOperation = downloadOperation;
    
    [weakDownloadOperation addExecutionBlock:^{
        // Download your stuff
        // Finally put it on the right place:
        [self background];
       
    }];
    
    NSBlockOperation *saveToDataBaseOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakSaveToDataBaseOperation = saveToDataBaseOperation;
    
    [weakSaveToDataBaseOperation addExecutionBlock:^{
        // Work with your NSData instance
        // Save your stuff
        [self setUpUI];
       
    }];
    
   // [saveToDataBaseOperation addDependency:downloadOperation];
   // [myQueue cancelAllOperations]; // cancel all operations
    
     [myQueue addOperation:saveToDataBaseOperation];
     [myQueue addOperation:downloadOperation];
   // [saveToDataBaseOperation cancel];   // cancel particular operations
    
  
    
    
 /*   dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
                   {
                       // Background work
                       [self background];
                       NSLog(@"background");
                       sleep(5);
                       dispatch_async(dispatch_get_main_queue(), ^(void)
                                      {
                                          // Main thread work (UI usually)
                                          [self setUpUI];
                                          NSLog(@"thread");
                                      });
                   });*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpUI {
    
     NSLog(@"thread");
    /* Add navigation title and his */
    self.navigationItem.title = @"My Profile";
    
    /* Add navigation left button */
    UIButton *buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonLeft.frame = CGRectMake(0, 0, 22, 22);
    buttonLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [buttonLeft setTitle:@"T" forState:UIControlStateNormal];
    [buttonLeft setBackgroundColor:[UIColor blueColor]];
    [buttonLeft addTarget:self action:@selector(Test) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonLeft=[[UIBarButtonItem alloc] init];
    [barButtonLeft setCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem=barButtonLeft;
    
    /* Add navigation right button */
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame = CGRectMake(0, 0, 22, 22);
    [buttonRight setSelected:NO];
    [buttonRight setTitle:@"B" forState:UIControlStateNormal];
    [buttonRight setBackgroundColor:[UIColor blueColor]];
    [buttonRight addTarget:self action:@selector(Test) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonRight=[[UIBarButtonItem alloc] init];
    [barButtonRight setCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem=barButtonRight;
   
}

-(void)Test{
 
    NSLog(@"Test button");
  
}

-(void)background{
     NSLog(@"background");

    //Init the NSURLSession with a configuration
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    //Create an URLRequest
    NSURL *url = [NSURL URLWithString:@"http://merchantapi.hiteshi.com/api/Consumer/GetCategory"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //Create POST Params and add it to HTTPBody
    [urlRequest setHTTPMethod:@"POST"];
    
    //Create task
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //Handle your response here
        @try{
            
            if(data.length > 0)
            {
                //success
                NSError *e=nil;
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options: 0 error: &e];
                
                if(result){
                    
                    if ([[result valueForKey:@"Success"] isEqualToString:@"0"]) {
                        
                        NSLog(@"Fail response :%@",[result valueForKey:@"Message"]);
                        
                    }else if([[result valueForKey:@"Success"] isEqualToString:@"1"]){
                        
                        NSLog(@"Success response :%@",[result valueForKey:@"Categories"]);
                    }
                    
                }
            }
            
        } @catch (NSException *exception) {
            NSLog(@"Error: %@",[exception description]);
        }
    }];
    
    [dataTask resume];

}

@end
