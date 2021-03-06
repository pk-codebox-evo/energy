//  Taken from here: http://www.codeilove.com/2011/09/ios-dev-strip-html-tags-from-nsstring.html
//  I've Cleaned it up, and ARC'd  ./


@interface NSString_stripHtml_XMLParsee : NSObject <NSXMLParserDelegate> {
   @private
    NSMutableArray *strings;
}
- (NSString *)getCharsFound;
@end


@implementation NSString_stripHtml_XMLParsee

- (id)init
{
    if ((self = [super init])) {
        strings = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [strings addObject:string];
}

- (NSString *)getCharsFound
{
    return [strings componentsJoinedByString:@""];
}
@end


@implementation NSString (StripHTML)

- (NSString *)stringByStrippingHTML
{
    // take this string obj and wrap it in a root element to ensure only a single root element exists
    NSString *string = [NSString stringWithFormat:@"<root>%@</root>", self];

    // not only do we want to avoid unwittingly stripping typography, but this process mangles
    // text surrounding these entities, i.e. "orta&rsquo;s house" becomes "orta"
    string = [string stringByReplacingOccurrencesOfString:@"&lsquo;" withString:@"’"];
    string = [string stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"‘"];
    string = [string stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
    string = [string stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
    string = [string stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"—"];
    string = [string stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"–"];
    string = [string stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"…"];


    // add the string to the xml parser
    NSStringEncoding encoding = string.fastestEncoding;
    NSData *data = [string dataUsingEncoding:encoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];

    // parse the content keeping track of any chars found outside tags (this will be the stripped content)
    NSString_stripHtml_XMLParsee *parsee = [[NSString_stripHtml_XMLParsee alloc] init];
    parser.delegate = parsee;
    [parser parse];

    // log any errors encountered while parsing
    //NSError * error = nil;
    //if((error = [parser parserError])) {
    //    NSLog(@"This is a warning only. There was an error parsing the string to strip HTML. This error may be because the string did not contain valid XML, however the result will likely have been decoded correctly anyway.: %@", error);
    //}

    // any chars found while parsing are the stripped content
    NSString *strippedString = [parsee getCharsFound];

    // get the raw text out of the parsee after parsing, and return it
    return strippedString;
}
@end
