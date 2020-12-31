//
//  NSString+AES.m
//  
//
//  Created by Bear on 16/11/26.
//  Copyright © 2016年 Bear . All rights reserved.
//

#import "NSString+AES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

//static NSString *const PSW_AES_KEY = @"TESTPASSWORD";
static NSString *const AES_IV_PARAMETER = @"AES00IVPARAMETER";

@implementation NSString (AES)


- (NSString *)aci_encryptWithAES {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *psw_aes_key = [self getPassword];
    
    NSData *AESData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:psw_aes_key
                                         iv:AES_IV_PARAMETER];
    NSString *baseStr = [AESData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return baseStr;
}

- (NSString *)aci_decryptWithAES {
    
    NSData *baseData = [[NSData alloc] initWithBase64EncodedString:self options:0];

    NSString *psw_aes_key = [self getPassword];
    
    NSData *AESData = [self AES128operation:kCCDecrypt
                                       data:baseData
                                        key:psw_aes_key
                                         iv:AES_IV_PARAMETER];
    
    NSString *decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    
    return decStr;
}

- (NSString *)getPassword {
    NSString *sharedUserDefaultSuiteName = @"com.aim.component.Jason";
    NSString *mapKey = @"AIM_Jason";
    NSUserDefaults *sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:sharedUserDefaultSuiteName];
    NSString *password = [sharedUserDefaults objectForKey:mapKey];
    if (!password || [password isEqualToString:@""]) {
        return @"aim_123@";
    }
    return password;
    
}

/**
 *  AES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 *
 *  @return
 */
- (NSData *)AES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess) {
        NSLog(@"Success");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    } else {
        NSLog(@"Error");
    }
    
    free(buffer);
    return nil;
}

@end
