#import "ALManagedObjectFactory.h"

@import CoreData;

@implementation ALManagedObjectFactory

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
                   andEntityDescriptionClass:(__unsafe_unretained Class)entityDescriptionClass
{
    if (self = [super init]) {
        self.managedObjectContext = managedObjectContext;
        self.entityDescriptionClass = entityDescriptionClass;
    }
    return self;
}

- (NSManagedObject*)createObjectForEntityClass:(__unsafe_unretained Class)entityClass
{
    return [self createObjectForEntityName:NSStringFromClass(entityClass)];
}

- (NSManagedObject*)createObjectForEntityName:(NSString*)entityName
{
    //create
    NSManagedObject *product = [self.entityDescriptionClass insertNewObjectForEntityForName:entityName
                                                                     inManagedObjectContext:self.managedObjectContext];
    
    return product;
}

@end
