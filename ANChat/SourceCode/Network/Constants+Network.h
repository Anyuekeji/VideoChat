#ifndef AYNovel_Constants_Network_h
#define AYNovel_Constants_Network_h

#pragma mark - Network environment
// 服务器环境，0-生产环境 1-UAT环境 2-测试环境 3-开发环境
#ifndef SERVER_TYPE
#define SERVER_TYPE 2
#endif

// 生产环境
#if SERVER_TYPE == 0

#define BASE_URL_HTTPS   @"https://apijapan.qrxs.cn/"

// 测试环境
#elif SERVER_TYPE == 2

#define BASE_URL_HTTPS   @"https://apijapan.qrxs.cn/"

#endif

/** 服务器版本号 */
#define SERVER_VERSION @"2.42"

#endif
