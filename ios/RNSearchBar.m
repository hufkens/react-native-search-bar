#import "RNSearchBar.h"

#import <React/UIView+React.h>
#import <React/RCTEventDispatcher.h>

@interface RNSearchBar() <UISearchBarDelegate>

@end

@implementation RNSearchBar
{
    RCTEventDispatcher *_eventDispatcher;
    NSInteger _nativeEventCount;
}

RCT_NOT_IMPLEMENTED(-initWithFrame:(CGRect)frame)
RCT_NOT_IMPLEMENTED(-initWithCoder:(NSCoder *)aDecoder)

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher
{
#if (TARGET_OS_TV)
    _eventDispatcher = eventDispatcher;
    self.delegate = self;
    return self;
    
#else
    if ((self = [super initWithFrame:CGRectMake(0, 0, 1000, 44)])) {
        _eventDispatcher = eventDispatcher;
        self.delegate = self;
    }
    return self;
    
#endif
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_eventDispatcher sendTextEventWithType:RCTTextEventTypeBlur
                                   reactTag:self.reactTag
                                       text:searchBar.text
                                        key:nil
                                 eventCount:_nativeEventCount];
    
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
#if !(TARGET_OS_TV)
    [self setShowsCancelButton:self._jsShowsCancelButton animated:YES];
#endif
    
    [_eventDispatcher sendTextEventWithType:RCTTextEventTypeFocus
                                   reactTag:self.reactTag
                                       text:searchBar.text
                                        key:nil
                                 eventCount:_nativeEventCount];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _nativeEventCount++;
    
    [_eventDispatcher sendTextEventWithType:RCTTextEventTypeChange
                                   reactTag:self.reactTag
                                       text:searchText
                                        key:nil
                                 eventCount:_nativeEventCount];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.onSearchButtonPress(@{
                               @"target": self.reactTag,
                               @"button": @"search",
                               @"searchText": searchBar.text
                               });
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.text = @"";
    [self resignFirstResponder];
#if !(TARGET_OS_TV)
    [self setShowsCancelButton:NO animated:YES];
#endif
    
    self.onCancelButtonPress(@{});
}

@end
