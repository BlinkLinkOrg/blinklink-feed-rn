#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(BlinklinkScreenManager, RCTViewManager)
RCT_EXPORT_VIEW_PROPERTY(screenId, NSString)
@end

@interface RCT_EXTERN_MODULE(BlinklinkSuperFeedManager, RCTViewManager)
@end

@interface RCT_EXTERN_MODULE(BlinklinkFeedViewManager, RCTViewManager)
RCT_EXPORT_VIEW_PROPERTY(layout, NSString)
RCT_EXPORT_VIEW_PROPERTY(title, NSString)
RCT_EXPORT_VIEW_PROPERTY(stream, NSString)
RCT_EXPORT_VIEW_PROPERTY(placement, NSString)
@end
