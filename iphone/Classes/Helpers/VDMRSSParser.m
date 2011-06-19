#import "VDMRSSParser.h"
#import "TBXMLEx.h"
#import "VDMEntry.h"
#import "NSString+HTML.h"

@implementation VDMRSSParser

-(NSArray *) parse:(NSString *) xmlContents {
	NSMutableArray *items = [NSMutableArray array];
	
	TBXMLEx *xml = [TBXMLEx parserWithXML:xmlContents];
	if (xml.rootElement) {
		TBXMLElementEx *itemNode = [[xml.rootElement child:@"channel"] child:@"item"];
		
		while ([itemNode next]) {
			VDMEntry *entry = [[VDMEntry alloc] init];

			entry.contents = [[[itemNode child:@"description"].value stringByDecodingHTMLEntities] stringByDecodingHTMLEntities];
			entry.link = [itemNode child:@"link"].value;
			
			[items addObject:entry];
			SafeRelease(entry);
		}
	}
	
	return items;
}

@end
