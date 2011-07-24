#import "VDMEntryXMLParser.h"
#import "TBXMLEx.h"
#import "NSString+HTML.h"
#import "VDMEntry.h"

@implementation VDMEntryXMLParser

-(NSArray *) parse:(NSString *) xmlContents {
	NSMutableArray *result = [NSMutableArray array];
	
	TBXMLEx *xml = [TBXMLEx parserWithXML:xmlContents];
	if (xml.rootElement) {
		TBXMLElementEx *entryNode = [xml.rootElement child:@"entry"];
		
		while ([entryNode next]) {
			VDMEntry *e = [[VDMEntry alloc] init];
			
			e.entryId = [[entryNode child:@"id"].value intValue];
			e.contents = [[entryNode child:@"contents"].value stringByDecodingHTMLEntities];
			e.agreeCount = [[entryNode child:@"agree-count"].value intValue];
			e.deserveCount = [[entryNode child:@"deserved-count"].value intValue];
			e.commentsCount = [[entryNode child:@"comments-count"].value intValue];
			
			[result addObject:e];
			SafeRelease(e);
		}
	}
	
	return result;
}

@end
