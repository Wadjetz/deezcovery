//
//  DBManager.m
//  Deezcovery
//
//  Created by Vuzi on 03/01/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import "DBManager.h"

#define Persistance_Directory   @"Persistence"
#define SQlite_DB_Filename      @"Deezcovery.sqlite"

@interface DBManager ()

@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) NSManagedObjectModel *mom;
@property (strong, nonatomic) NSPersistentStoreCoordinator *psc;
@property (strong, nonatomic) NSPersistentStore *ps;

@end

@implementation DBManager

- (void)saveTrack:(Track *)track forArtist:(Artist *)artist {
    if (track) {
        Track * newTrack = [self createManagedObjectWithClass:[Track class]];
        newTrack.track_id = track.track_id;
        newTrack.title = track.title;
        newTrack.preview = track.preview;
        newTrack.album_title = track.album_title;
        newTrack.artist_id = artist.artist_id;
        NSLog(@"Save = %@", newTrack.title);
        [self persistData];
    } else {
        NSLog(@"No Save track nil");
    }
}

- (NSArray *)getTracks:(Artist *)artist {
    NSError * error;
    NSPredicate * filter = [NSPredicate predicateWithFormat:@"artist_id == %@", artist.artist_id];
    NSArray * result = [self fetchEntity:@"Track" predicate:filter prefetchedRelations:nil sortKey:nil ascending:YES error:&error];
    if(nil != error){
        NSLog(@"PersistData failed with errors: \n%@\n%@", error.localizedDescription, error.userInfo);
        return nil;
    }
    NSLog(@"getTracks result=%lu artist=%@", (unsigned long)result.count, artist.name);
    return result;
}

- (void)saveArtist:(Artist *)artist {
    if(artist && artist.name) {
        NSLog(@"Save = %@", artist);
        Artist * newArtist = [self createManagedObjectWithClass:[Artist class]];
        newArtist.artist_id = artist.artist_id;
        newArtist.name = artist.name;
        newArtist.nb_album = artist.nb_album;
        newArtist.nb_fan= artist.nb_fan;
        [self persistData];
    } else {
        NSLog(@"No Save Artist nil");
    }
}

- (void)saveArtist:(NSNumber *)artist_id with:(NSString*)name with:(NSNumber *)nb_album with:(NSNumber *)nb_fan {
    NSLog(@"Save = %@ %@ %@ %@", artist_id, name, nb_album, nb_fan);
    Artist * newArtist = [self createManagedObjectWithClass:[Artist class]];
    newArtist.artist_id = artist_id;
    newArtist.name = name;
    newArtist.nb_album = nb_album;
    newArtist.nb_fan= nb_fan;
    [self persistData];
}

- (NSArray *)fetchArtists {
    NSError * error;
    NSArray * result = [self fetchEntity:@"Artist" predicate:nil prefetchedRelations:nil sortKey:@"name" ascending:YES error:&error];
    if(nil != error){
        NSLog(@"PersistData failed with errors: \n%@\n%@", error.localizedDescription, error.userInfo);
        return nil;
    }
    return result;
}


- (Artist *)getArtist:(NSNumber *)artist_id {
    NSError * error;
    NSPredicate * filter = [NSPredicate predicateWithFormat:@"artist_id == %@", artist_id];
    NSArray * result = [self fetchEntity:@"Artist" predicate:filter prefetchedRelations:nil sortKey:@"name" ascending:YES error:&error];
    if(nil != error){
        NSLog(@"PersistData failed with errors: \n%@\n%@", error.localizedDescription, error.userInfo);
        return nil;
    }
    if ([result count] > 0) {
        return result[0];
    } else {
        return nil;
    }
}

-(void)createPersistentStore{
    if ([[_psc persistentStores] count] > 0){
        NSLog(@"addPersistentStoreToCoordinator : store coordinator already has one store");
        return;
    }
    
    NSURL *storePathURL = [[NSURL alloc] initFileURLWithPath:[self getPersistentStorePathWithType:NSSQLiteStoreType]];
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption: [NSNumber numberWithBool:YES],
                              NSInferMappingModelAutomaticallyOption: [NSNumber numberWithBool:YES]
                              };
    NSError *error;
    _ps = [_psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storePathURL options:options error:&error];
    
    if(_ps == nil){
        NSLog(@"StoreURL: %@", storePathURL.absoluteString);
        NSLog(@"Adding persistentStore to the coordinator failed with error:\n %@, %@", error.localizedDescription, error.userInfo);
        return;
    }
}

- (BOOL)persistData{
    NSError *error = nil;
    [_moc save:&error];
    
    if(nil != error){
        NSLog(@"PersistData failed with errors: \n%@\n%@", error.localizedDescription, error.userInfo);
        return NO;
    }
    NSLog(@"Data saved.");
    return YES;
}

- (void)refreshObject:(NSManagedObject *)managedObject mergeChanges:(BOOL)flag{
    [_moc refreshObject:managedObject mergeChanges:flag];
}

#pragma mark - Tools -
-(NSArray *)fetchEntity:(NSString *)entityName predicate:(NSPredicate *)predicate prefetchedRelations:(NSArray *)prefetchedRelationKeys sortKey:(NSString *)sortKey ascending:(BOOL)ascending error:(NSError **)error
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:_moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entityDescription;
    
    if (predicate)
        request.predicate = predicate;
    
    if (sortKey){
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        request.sortDescriptors = @[sortDescriptor];
    }
    
    if (prefetchedRelationKeys)
        [request setRelationshipKeyPathsForPrefetching:prefetchedRelationKeys];
    
    NSArray *result = [_moc executeFetchRequest:request error:error];
    if (error && *error != nil)
        NSLog(@"fetchEntity failed with errors: \n%@\n%@", [(*error) localizedDescription], [(*error) userInfo]);
    
    return result;
}

#pragma mark - Entity creation
- (id)createManagedObjectWithName:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:_moc];
}

- (id)createManagedObjectWithClass:(Class)entityClass
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(entityClass)
                                         inManagedObjectContext:_moc];
}

- (id)createTemporaryObjectWithClass:(Class)entityClass
{
    return [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:NSStringFromClass(entityClass)
                                                               inManagedObjectContext:_moc] insertIntoManagedObjectContext:nil];
}

#pragma mark - Generic Core data entity deletion
- (void)deleteManagedObject:(NSManagedObject *)object
{
    [_moc deleteObject:object];
}

#pragma mark - Utils -
#pragma mark - standards iOS directories
- (NSString *)getDocumentDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSString *)getLibraryDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSString *)getCacheDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

#pragma mark - CoreData db path
- (NSString *)getPersistentStorePathWithType:(NSString *)type
{
    if ([type isEqualToString:NSSQLiteStoreType])
    {
        NSString *path = [[self getLibraryDirectoryPath] stringByAppendingPathComponent:Persistance_Directory];
        
        [self createDirIfNotExists:path];
        return [path stringByAppendingPathComponent:SQlite_DB_Filename];
    }
    NSLog(@"Unrecognized Persistent store type.");
    return nil;
}

-(BOOL)createDirIfNotExists:(NSString *)path
{
    NSError *error = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDir;
    if(![manager fileExistsAtPath:path isDirectory:&isDir])
    {
        if(![manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Creating photos directory failed with error: %@, %@", error.localizedDescription, error.userInfo);
            return NO;
        }
    }
    return YES;
}

#pragma mark - singleton creation pattern
static DBManager *sharedInstance = nil;

+ (id)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (sharedInstance == nil)
            sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}
+ (id)allocWithZone:(NSZone *)zone{
    return [self sharedInstance];
}
- (id)copyWithZone:(NSZone *)zone{
    return self;
}
- (id)init{
    if(nil != (self = [super init])){
        _moc = [[NSManagedObjectContext alloc] init];
        _mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"]];
        _psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_mom];
        
        [_moc setPersistentStoreCoordinator:_psc];
        [self createPersistentStore];
    }
    return self;
}

@end

