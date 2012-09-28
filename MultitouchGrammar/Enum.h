#import <Cocoa/Cocoa.h>

#define EnumDecl(class, name)  + (class*) name;
#define EnumImpl(name)  + (id) _enum__##name {return nil;}  + (id) name {return nil;}

@interface Enum : NSObject <NSCoding>

@property (readonly) NSString* name;

// The ordering enum items are returned in is undefined.
+ (NSArray*) allEnumItems;
+ (Enum*) enumWithName:(NSString*) name;

@end
