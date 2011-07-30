#import "VDMThemeChooserController.h"
#import "VDMEntryTheme.h"

@implementation VDMThemeChooserController
@synthesize didChooseThemeAction, selectedThemeId;

-(VDMEntryTheme *) theme:(int) themeId name:(NSString *) name description:(NSString *) description {
	VDMEntryTheme *t = [[[VDMEntryTheme alloc] init] autorelease];
	t.themeId = themeId;
	t.name = name;
	t.description = description;
	return t;
}

-(void) viewDidLoad {
	[super viewDidLoad];
	themes = [[NSArray arrayWithObjects:
		[self theme:2 name:@"amigos" description:@"Amigos"],
		[self theme:7 name:@"dinheiro" description:@"Dinheiro"],
		[self theme:6 name:@"estudos" description:@"Estudos"],
		[self theme:3 name:@"familia" description:@"Família"],
		[self theme:9 name:@"geral" description:@"Geral"],
		[self theme:4 name:@"relacionamento" description:@"Relacionamento"],
		[self theme:1 name:@"sexo" description:@"Sexo"], 
		[self theme:8 name:@"solidao" description:@"Solidão"],
		[self theme:5 name:@"trabalho" description:@"Trabalho"], nil] retain];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return themes.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellId = @"CellId";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
		cell.indentationWidth = 5;
		cell.indentationLevel = 1;
		cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
	}
	
	VDMEntryTheme *t = [themes objectAtIndex:indexPath.row];
	cell.textLabel.text = t.description;
	cell.accessoryType = t.themeId == selectedThemeId ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	cell.imageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", t.name]] resize:CGSizeMake(32, 32)];
	
	return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (didChooseThemeAction) {
		didChooseThemeAction([themes objectAtIndex:indexPath.row]);
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

-(void) dealloc {
	SafeRelease(didChooseThemeAction);
	[super dealloc];
}

@end
