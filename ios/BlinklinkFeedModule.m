#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(BlinklinkFeedModule, RCTEventEmitter)

RCT_EXTERN_METHOD(configure:(NSDictionary *)options)
RCT_EXTERN_METHOD(setUser:(NSString *)ref)
RCT_EXTERN_METHOD(clearUser)
RCT_EXTERN_METHOD(handleUniversalLink:(NSString *)urlString
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end
