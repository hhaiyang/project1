static BOOL isDebugMode = NO;

#define WX_APP_ID @"wx8ed4a2fdc7124b38"
#define WX_H5_APP_ID @"wx3d5e3cdd9b6f8589"
#define WX_MCH_ID @"1310495401"

#define JPUSH_KEY @"a748a4360161ed3553e8c8f8"
#define JPUSH_SECRET @"2e2efbc3575e04a0a983dbe4"

#define BASE_URL_DEBUG @"http://xjx.ngrok.natapp.cn"
#define FILE_URL_DEBUG @"http://xjx_files.ngrok.natapp.cn"
#define PAGE_URL_DEBUG @"http://xjx_pages.ngrok.natapp.cn"
#define ADMIN_URL_DEBUG @"http://xjx_admin.ngrok.natapp.cn"


typedef void (^onAPIRequestDone)(id res,NSString *err);

typedef enum{
    kMessageCellTypeMessage = 0,
    kMessageCellTypeCreditsChanged = 1,
    kMessageCellTypeCrowdFundingMessage = 2,
    kMessageCellTypeShippingStatusChange = 3
}XJXMessageCellType;

#define BASE_URL_ONLINE @"http://hnhwedding.cn"
#define FILE_URL_ONLINE @"http://hnhwedding.cn:8888"
#define PAGE_URL_ONLINE @"http://hnhwedding.cn:800"
#define ADMIN_URL_ONLINE @"http://hnhwedding.cn:888"

#define BASE_URL isDebugMode ? BASE_URL_DEBUG : BASE_URL_ONLINE
#define FILE_URL isDebugMode ? FILE_URL_DEBUG : FILE_URL_ONLINE
#define PAGE_URL isDebugMode ? PAGE_URL_DEBUG : PAGE_URL_ONLINE
#define ADMIN_URL isDebugMode ? ADMIN_URL_DEBUG : ADMIN_URL_ONLINE

#define MAX_BRNADS_MATCHING 6

#define ORDER_EXPIRED_INTERVAL 2 * 60 * 60

#define SERVER_FILE_WRAPPER(url) [NSString stringWithFormat:@"%@/%@",FILE_URL,url]

#define PRODUCT_HTML_URL_WRAPPER(serialno) [NSString stringWithFormat:@"%@/product/%@/product_desc.html",PAGE_URL,serialno]

#define ARTICLE_HTML_URL_WRAPPER(serialno) [NSString stringWithFormat:@"%@/article/%@/index.html",PAGE_URL,serialno]

#define INVITATION_HTML_URL_WRAPPER(wedding_id,serialno) [NSString stringWithFormat:@"%@/userdata/invitation/wedding/%@.html?serial=%@",BASE_URL,wedding_id,serialno]

#define BIND_PERSON_URL_WRAPPER(wedding_id) [NSString stringWithFormat:@"%@/bind/index.html?wid=%lu",BASE_URL,wedding_id]

#define TEMPLATE_HTML(htmlcode) [[NSString readFromFile:@"template.html"] stringByReplacingOccurrencesOfString:@"#htmlcontent" withString:htmlcode]

#define QJLINK_ID @"cijzuu4od02yrkevi2u36qn4g"
