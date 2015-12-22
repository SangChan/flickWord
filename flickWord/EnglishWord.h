//
//  EnglishWord.h
//  flickWord
//
//  Created by LeeSangchan on 2015. 12. 20..
//  Copyright © 2015년 sangchan. All rights reserved.
//

#import <Realm/Realm.h>

@interface EnglishWord : RLMObject

@property NSNumber<RLMInt> *wordID;
@property NSString *word;
@property NSString *wordDescription;

@end
