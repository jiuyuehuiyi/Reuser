//
//  MarkupTextStorage.m
//  TestTextkit
//
//  Created by dengweihao on 15/10/12.
//  Copyright © 2015年 vcyber. All rights reserved.
//

#import "MarkupTextStorage.h"

@interface MarkupTextStorage ()

@property (nonatomic, strong) NSMutableAttributedString *backingStore;
@property (nonatomic, strong) NSDictionary *replacements;

@end

@implementation MarkupTextStorage

- (id)init
{
    self = [super init];
    if (self) {
        _backingStore = [[NSMutableAttributedString alloc] init];
        [self createMarkupStyledPatterns];
    }
    return self;
}

// 返回保存的文字
- (NSString *)string
{
    return [_backingStore string];
}

// 获取指定范围内的文字属性
- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location effectiveRange:range];
}

// 修改指定范围内的文字
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes
           range:range changeInLength:str.length - range.length];
    [self endEditing];
}

// 设置指定范围内的文字属性
- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes
           range:range changeInLength:0];
    [self endEditing];
}

// 编辑结束后调用
- (void)processEditing
{
    NSLog(@"编辑长度:%lu, 编辑位置:%lu", [self editedRange].length, [self editedRange].location);
    [self performReplacementsForRange:[self editedRange]];
    [super processEditing];
}

- (void)performReplacementsForRange:(NSRange)changedRange
{
    NSRange extendedRange = NSUnionRange(changedRange, [[_backingStore string]
                                                        lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[_backingStore string]
                                                lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    NSLog(@"扩展编辑长度:%lu, 扩展编辑位置:%lu", extendedRange.length, extendedRange.location);
    [self applyStylesToRange:extendedRange];
}

- (NSDictionary*)createAttributesForFontStyle:(NSString*)style
                                    withTrait:(uint32_t)trait {
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor
                                        preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    
    UIFontDescriptor *descriptorWithTrait = [fontDescriptor
                                             fontDescriptorWithSymbolicTraits:trait];
    
    UIFont* font =  [UIFont fontWithDescriptor:descriptorWithTrait size: 0.0];
    return @{ NSFontAttributeName : font };
}

// 创建匹配条件
- (void)createMarkupStyledPatterns
{
    UIFontDescriptor *scriptFontDescriptor =
    [UIFontDescriptor fontDescriptorWithFontAttributes:
     @{UIFontDescriptorFamilyAttribute: @"Bradley Hand"}];
    
    // 1. base our script font on the preferred body font size
    UIFontDescriptor* bodyFontDescriptor = [UIFontDescriptor
                                            preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    NSNumber* bodyFontSize = bodyFontDescriptor.
    fontAttributes[UIFontDescriptorSizeAttribute];
    UIFont* scriptFont = [UIFont
                          fontWithDescriptor:scriptFontDescriptor size:[bodyFontSize floatValue]];
    
    // 2. create the attributes
    NSDictionary* boldAttributes = [self
                                    createAttributesForFontStyle:UIFontTextStyleBody
                                    withTrait:UIFontDescriptorTraitBold];
    NSDictionary* italicAttributes = [self
                                      createAttributesForFontStyle:UIFontTextStyleBody
                                      withTrait:UIFontDescriptorTraitItalic];
    NSDictionary* strikeThroughAttributes = @{ NSStrikethroughStyleAttributeName : @1,
                                               NSForegroundColorAttributeName: [UIColor redColor]};
    NSDictionary* scriptAttributes = @{ NSFontAttributeName : scriptFont,
                                        NSForegroundColorAttributeName: [UIColor blueColor]
                                        };
    NSDictionary* redTextAttributes =
    @{ NSForegroundColorAttributeName : [UIColor redColor]};
    
    _replacements = @{
                      @"(\\*\\*\\w+(\\s\\w+)*\\*\\*)" : boldAttributes, // **字符之间的文本加粗显示
                      @"(_\\w+(\\s\\w+)*_)" : italicAttributes,         // __字符之间的文本以斜体字显示
                      @"(~~\\w+(\\s\\w+)*~~)" : strikeThroughAttributes, // ~~字符之间的文本以被横线穿透样式显示
                      @"(`\\w+(\\s\\w+)*`)" : scriptAttributes,    // ``字符之间的文本以蓝色scriptFont字体显示
                      @"\\s([A-Z]{2,})\\s" : redTextAttributes     // 全大写的文本以红色字体显示
                      };
}

- (void)applyStylesToRange:(NSRange)searchRange
{
    NSDictionary* normalAttrs = @{NSFontAttributeName:
                                      [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    
    // iterate over each replacement
    for (NSString* key in _replacements) {
//        NSLog(@"key:%@", key);
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:key
                                      options:0
                                      error:nil];
        
        NSDictionary* attributes = _replacements[key];
        
        [regex enumerateMatchesInString:[_backingStore string]
                                options:0
                                  range:searchRange
                             usingBlock:^(NSTextCheckingResult *match,
                                          NSMatchingFlags flags,
                                          BOOL *stop){
                                 // apply the style
//                                 NSLog(@"Match:%@", [[_backingStore attributedSubstringFromRange:[match rangeAtIndex:1]] string]);
                                 NSRange matchRange = [match rangeAtIndex:1];
                                 [self addAttributes:attributes range:matchRange];
                                 
                                 // reset the style to the original
                                 if (NSMaxRange(matchRange)+1 < self.length) {
                                     [self addAttributes:normalAttrs
                                                   range:NSMakeRange(NSMaxRange(matchRange)+1, 1)];
                                 }
                             }];
    }
}


@end
