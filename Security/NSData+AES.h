//
//  NSData+AES.h
//  Jason
//
//  Created by MachelleZhang on 2020/4/26.
//  Copyright © 2020 Olivier Labs. All rights reserved.
//

#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (AES)

/**< 加密方法 */
- (NSData *)aci_encryptWithAES;

/**< 解密方法 */
- (NSData *)aci_decryptWithAES;

@end

NS_ASSUME_NONNULL_END
