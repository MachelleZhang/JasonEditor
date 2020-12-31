//
//  NSData+AES.m
//  Jason
//
//  Created by MachelleZhang on 2020/4/26.
//  Copyright © 2020 Olivier Labs. All rights reserved.
//

#import "NSData+AES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#import <AppKit/AppKit.h>

static NSString *const D_PSW_AES_KEY = @"TESTPASSWORD";
static NSString *const D_AES_IV_PARAMETER = @"AES00IVPARAMETER";

@implementation NSData (AES)

- (NSData *)aci_encryptWithAES {

    NSData *AESData = [self AES128operation:kCCEncrypt
                                       data:self
                                        key:D_PSW_AES_KEY
                                         iv:D_AES_IV_PARAMETER];
    
    NSData *baseData = [AESData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return baseData;
}

- (NSData *)aci_decryptWithAES {
    
    NSData *baseData = [[NSData alloc] initWithBase64EncodedData:self options:0];

    NSData *AESData = [self AES128operation:kCCDecrypt
                                       data:baseData
                                        key:D_PSW_AES_KEY
                                         iv:D_AES_IV_PARAMETER];
    
    return AESData;
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
