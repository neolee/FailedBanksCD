//
//  DebugMacros.h
//  Could be put in precompiled header
//
//  Created by Neo on 8/25/11.
//  Copyright (c) 2011 Ragnarok. All rights reserved.
//

#import "LoggerClient.h"

#define LOG_LEVEL_INFO      7
#define LOG_LEVEL_DEBUG     5
#define LOG_LEVEL_WARNING   3
#define LOG_LEVEL_ERROR     1

#ifdef DEBUG

#define LOG_APP(...)		LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"app", ##__VA_ARGS__)
#define LOG_CONFIG(...)		LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"config", ##__VA_ARGS__)
#define LOG_CACHE(...)		LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"cache", ##__VA_ARGS__)
#define LOG_NETWORK(...)	LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"network", ##__VA_ARGS__)
#define LOG_EXCEPTION(...)	LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"exception", 0, ##__VA_ARGS__)
#define LOG_TIMERS(...)		LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"timers", ##__VA_ARGS__)
#define LOG_VIDEO(...)		LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"video", ##__VA_ARGS__)

#else

#define LOG_APP(...)		do {} while(0)
#define LOG_CONFIG(...)		do {} while(0)
#define LOG_CACHE(...)		do {} while(0)
#define LOG_NETWORK(...)	do {} while(0)
#define LOG_TIMERS(...)		do {} while(0)
#define LOG_VIDEO(...)		do {} while(0)
#define LOG_EXCEPTION(...)	do {} while(0)

#endif