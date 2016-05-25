//
//  ViewController.m
//  TestTextkit
//
//  Created by dengweihao on 15/10/10.
//  Copyright © 2015年 vcyber. All rights reserved.
//

#import "ViewController.h"
#import "MarkupTextStorage.h"
#import "MMTextAttachment.h"

@interface ViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGPoint gestureStartingPoint;
@property (nonatomic, assign) CGPoint gestureStartingCenter;

@end

@implementation ViewController

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        _imageView.image = [UIImage imageNamed:@"a.jpg"];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textStorage = [[MarkupTextStorage alloc] init];
        
        CGRect textViewRect = CGRectMake(20, 60, self.view.bounds.size.width-40, self.view.bounds.size.height - 100);
        
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(textViewRect.size.width, CGFLOAT_MAX)];
        [layoutManager addTextContainer:textContainer];
        [_textStorage addLayoutManager:layoutManager];
        
        _textView = [[UITextView alloc] initWithFrame:textViewRect
                                        textContainer:textContainer];
        _textView.delegate = self;
    }
    return _textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textView];
    [self LoadMarkupTextViewData];
    [self.view addSubview:self.imageView];
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imagePanned:)];
    [self.imageView addGestureRecognizer:panGes];
    
    // 排除路径
    self.textView.textContainer.exclusionPaths = @[[self translatedBezierPath]];
    
    //动态字体
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
}

- (void)preferredContentSizeChanged:(NSNotification *)notification {
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    NSLog(@"changeTextFont");
}

- (void)LoadMarkupTextViewData
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    NSString *content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"content" ofType:@"txt"]
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    MMTextAttachment *textAttachment = [[MMTextAttachment alloc] initWithData:nil ofType:nil];
    UIImage *smileImage = [UIImage imageNamed:@"a.jpg"];
    textAttachment.image = smileImage;
    NSAttributedString * textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
    [attributedString insertAttributedString:textAttachmentString atIndex:13];
    
    //凸版印刷体效果
    NSDictionary *TitleAttributes = @{
                                      NSForegroundColorAttributeName: [UIColor redColor],
                                      NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
                                      NSTextEffectAttributeName: NSTextEffectLetterpressStyle
                                      };
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"\nEND" attributes:TitleAttributes];
    [attributedString appendAttributedString:title];
    [self.textView.textStorage setAttributedString:attributedString];
}

- (UIBezierPath *)translatedBezierPath
{
    CGRect butterflyImageRect = [self.textView convertRect:self.imageView.frame fromView:self.view];
    UIBezierPath *newButterflyPath = [UIBezierPath bezierPathWithRect:butterflyImageRect];
    
    return newButterflyPath;
}

- (void)imagePanned:(id)sender
{
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *localSender = sender;
        
        if (localSender.state == UIGestureRecognizerStateBegan) {
            self.gestureStartingPoint = [localSender translationInView:self.textView];
            self.gestureStartingCenter = self.imageView.center;
        } else if (localSender.state == UIGestureRecognizerStateChanged) {
            CGPoint currentPoint = [localSender translationInView:self.textView];
            
            CGFloat distanceX = currentPoint.x - self.gestureStartingPoint.x;
            CGFloat distanceY = currentPoint.y - self.gestureStartingPoint.y;
            
            CGPoint newCenter = self.gestureStartingCenter;
            
            newCenter.x += distanceX;
            newCenter.y += distanceY;
            
            self.imageView.center = newCenter;
            
            self.textView.textContainer.exclusionPaths = @[[self translatedBezierPath]];
        } else if (localSender.state == UIGestureRecognizerStateEnded) {
            self.gestureStartingPoint = CGPointZero;
            self.gestureStartingCenter = CGPointZero;
        } 
    } 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
