//
//  BodyPartGeometry.m
//  PainMe
//
//  Created by Garrett Christopher on 6/21/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "BodyPartGeometry.h"
#import "PainLocation.h"

@interface BodyPartGeometry() {
   CGPoint *_points;
}

@property (nonatomic, readonly) NSInteger pointCount;
@property (nonatomic, retain) UIBezierPath *bezierPath;

@property (nonatomic, retain) NSArray *painLocDetails;
@property (nonatomic, retain) NSMutableArray *painShapes;


@end

#define NUM_TO_DIVIDEX (1024.0*8)
#define NUM_TO_DIVIDEY (1024.0*17)

@implementation BodyPartGeometry

@synthesize pointCount = _pointCount, bezierPath = _bezierPath;
@synthesize painLocDetails = painLocDetails;



- (id) init {
   self = [super init];
   if (self) {
       
       self.painLocDetails = [[PainLocation painLocations]copy];
       self.painShapes = [NSMutableArray array];
       
       for (int i=0; i<[self.painLocDetails count]; i++) {
           
           NSDictionary *obj = [self.painLocDetails objectAtIndex:i];
           NSData *vertices = [obj valueForKey:@"shape"];
          
           int count = ([vertices length])/sizeof(CGPoint);
           
           [self setPointCount:count];
           _points = (CGPoint *)[vertices bytes];
           
           [self.painShapes addObject:[self bezierPath]];
       }
       
       
      // set point count
       
       /*
       float numToAddX = 3.0/8; // 3rd column
       float numToAddY = 6.0/17; // 6th row 
       
       [self setPointCount: 40];
       
       _points[0] = CGPointMake(numToAddX +(1014/NUM_TO_DIVIDEX), numToAddY +(446/NUM_TO_DIVIDEY));
       _points[1] = CGPointMake(numToAddX +(920/NUM_TO_DIVIDEX), numToAddY +(464/NUM_TO_DIVIDEY));
       _points[2] = CGPointMake(numToAddX +(870/NUM_TO_DIVIDEX), numToAddY +(486/NUM_TO_DIVIDEY));
       _points[3] = CGPointMake(numToAddX +(819/NUM_TO_DIVIDEX), numToAddY +(517/NUM_TO_DIVIDEY));
       _points[4] = CGPointMake(numToAddX +(776/NUM_TO_DIVIDEX), numToAddY +(555/NUM_TO_DIVIDEY));
       _points[5] = CGPointMake(numToAddX +(739/NUM_TO_DIVIDEX), numToAddY +(601/NUM_TO_DIVIDEY));
       _points[6] = CGPointMake(numToAddX +(710/NUM_TO_DIVIDEX), numToAddY +(652/NUM_TO_DIVIDEY));
       _points[7] = CGPointMake(numToAddX +(692/NUM_TO_DIVIDEX), numToAddY +(707/NUM_TO_DIVIDEY));
       _points[8] = CGPointMake(numToAddX +(683/NUM_TO_DIVIDEX), numToAddY +(766/NUM_TO_DIVIDEY));
       _points[9] = CGPointMake(numToAddX +(684/NUM_TO_DIVIDEX), numToAddY +(822/NUM_TO_DIVIDEY));
       _points[10] = CGPointMake(numToAddX +(695/NUM_TO_DIVIDEX), numToAddY +(880/NUM_TO_DIVIDEY));
       
       _points[11] = CGPointMake(numToAddX +(714/NUM_TO_DIVIDEX), numToAddY +(935/NUM_TO_DIVIDEY));
       _points[12] = CGPointMake(numToAddX +(744/NUM_TO_DIVIDEX), numToAddY +(984/NUM_TO_DIVIDEY));
       _points[13] = CGPointMake(numToAddX +(778/NUM_TO_DIVIDEX), numToAddY +(1023/NUM_TO_DIVIDEY));
       
       
       numToAddY = 7.0/17;
       
       _points[14] = CGPointMake(numToAddX +(782/NUM_TO_DIVIDEX), numToAddY +(4/NUM_TO_DIVIDEY));
       _points[15] = CGPointMake(numToAddX +(825/NUM_TO_DIVIDEX), numToAddY +(42/NUM_TO_DIVIDEY));
       _points[16] = CGPointMake(numToAddX +(874/NUM_TO_DIVIDEX), numToAddY +(71/NUM_TO_DIVIDEY));
       _points[17] = CGPointMake(numToAddX +(928/NUM_TO_DIVIDEX), numToAddY +(92/NUM_TO_DIVIDEY));
       _points[18] = CGPointMake(numToAddX +(986/NUM_TO_DIVIDEX), numToAddY +(104/NUM_TO_DIVIDEY));
       _points[19] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(103/NUM_TO_DIVIDEY));
       
       
       numToAddX = 4.0/8;
       
       _points[20] = CGPointMake(numToAddX +(3/NUM_TO_DIVIDEX), numToAddY +(104/NUM_TO_DIVIDEY));
       _points[21] = CGPointMake(numToAddX +(40/NUM_TO_DIVIDEX), numToAddY +(102/NUM_TO_DIVIDEY));
       _points[22] = CGPointMake(numToAddX +(95/NUM_TO_DIVIDEX), numToAddY +(92/NUM_TO_DIVIDEY));
       _points[23] = CGPointMake(numToAddX +(150/NUM_TO_DIVIDEX), numToAddY +(71/NUM_TO_DIVIDEY));
       _points[24] = CGPointMake(numToAddX +(199/NUM_TO_DIVIDEX), numToAddY +(41/NUM_TO_DIVIDEY));
       _points[25] = CGPointMake(numToAddX +(244/NUM_TO_DIVIDEX), numToAddY +(2/NUM_TO_DIVIDEY));
       
       numToAddY = 6.0/17;
       
       _points[26] = CGPointMake(numToAddX +(267/NUM_TO_DIVIDEX), numToAddY +(1001/NUM_TO_DIVIDEY));
       _points[27] = CGPointMake(numToAddX +(299/NUM_TO_DIVIDEX), numToAddY +(953/NUM_TO_DIVIDEY));
       
       _points[28] = CGPointMake(numToAddX +(324/NUM_TO_DIVIDEX), numToAddY +(899/NUM_TO_DIVIDEY));
       _points[29] = CGPointMake(numToAddX +(337/NUM_TO_DIVIDEX), numToAddY +(843/NUM_TO_DIVIDEY));
       _points[30] = CGPointMake(numToAddX +(341/NUM_TO_DIVIDEX), numToAddY +(783/NUM_TO_DIVIDEY));
       _points[31] = CGPointMake(numToAddX +(336/NUM_TO_DIVIDEX), numToAddY +(726/NUM_TO_DIVIDEY));
       _points[32] = CGPointMake(numToAddX +(320/NUM_TO_DIVIDEX), numToAddY +(673/NUM_TO_DIVIDEY));
       _points[33] = CGPointMake(numToAddX +(295/NUM_TO_DIVIDEX), numToAddY +(621/NUM_TO_DIVIDEY));
       _points[34] = CGPointMake(numToAddX +(262/NUM_TO_DIVIDEX), numToAddY +(573/NUM_TO_DIVIDEY));
       
       _points[35] = CGPointMake(numToAddX +(222/NUM_TO_DIVIDEX), numToAddY +(531/NUM_TO_DIVIDEY));
       _points[36] = CGPointMake(numToAddX +(175/NUM_TO_DIVIDEX), numToAddY +(497/NUM_TO_DIVIDEY));
       _points[37] = CGPointMake(numToAddX +(123/NUM_TO_DIVIDEX), numToAddY +(471/NUM_TO_DIVIDEY));
       _points[38] = CGPointMake(numToAddX +(68/NUM_TO_DIVIDEX), numToAddY +(456/NUM_TO_DIVIDEY));
       _points[39] = CGPointMake(numToAddX +(10/NUM_TO_DIVIDEX), numToAddY +(448/NUM_TO_DIVIDEY));
       
        */
       
       
       /*
       
       float numToAddX = 3.0/8; // column -1
       float numToAddY = 0.0/17; // row -1
       
       [self setPointCount: 104];

	   _points[0] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(175/NUM_TO_DIVIDEY));
       _points[1] = CGPointMake(numToAddX +(962/NUM_TO_DIVIDEX), numToAddY +(177/NUM_TO_DIVIDEY));
       _points[2] = CGPointMake(numToAddX +(920/NUM_TO_DIVIDEX), numToAddY +(181/NUM_TO_DIVIDEY));
       _points[3] = CGPointMake(numToAddX +(875/NUM_TO_DIVIDEX), numToAddY +(187/NUM_TO_DIVIDEY));
       _points[4] = CGPointMake(numToAddX +(831/NUM_TO_DIVIDEX), numToAddY +(198/NUM_TO_DIVIDEY));
       _points[5] = CGPointMake(numToAddX +(757/NUM_TO_DIVIDEX), numToAddY +(218/NUM_TO_DIVIDEY));
       _points[6] = CGPointMake(numToAddX +(694/NUM_TO_DIVIDEX), numToAddY +(245/NUM_TO_DIVIDEY));
       _points[7] = CGPointMake(numToAddX +(641/NUM_TO_DIVIDEX), numToAddY +(276/NUM_TO_DIVIDEY));
       _points[8] = CGPointMake(numToAddX +(587/NUM_TO_DIVIDEX), numToAddY +(314/NUM_TO_DIVIDEY));
       _points[9] = CGPointMake(numToAddX +(546/NUM_TO_DIVIDEX), numToAddY +(350/NUM_TO_DIVIDEY));
       _points[10] = CGPointMake(numToAddX +(507/NUM_TO_DIVIDEX), numToAddY +(390/NUM_TO_DIVIDEY));
       _points[11] = CGPointMake(numToAddX +(479/NUM_TO_DIVIDEX), numToAddY +(424/NUM_TO_DIVIDEY));
       _points[12] = CGPointMake(numToAddX +(444/NUM_TO_DIVIDEX), numToAddY +(475/NUM_TO_DIVIDEY));
       _points[13] = CGPointMake(numToAddX +(416/NUM_TO_DIVIDEX), numToAddY +(523/NUM_TO_DIVIDEY));
       _points[14] = CGPointMake(numToAddX +(391/NUM_TO_DIVIDEX), numToAddY +(576/NUM_TO_DIVIDEY));
       _points[15] = CGPointMake(numToAddX +(368/NUM_TO_DIVIDEX), numToAddY +(636/NUM_TO_DIVIDEY));
       _points[16] = CGPointMake(numToAddX +(353/NUM_TO_DIVIDEX), numToAddY +(681/NUM_TO_DIVIDEY));
       _points[17] = CGPointMake(numToAddX +(343/NUM_TO_DIVIDEX), numToAddY +(714/NUM_TO_DIVIDEY));
       _points[18] = CGPointMake(numToAddX +(332/NUM_TO_DIVIDEX), numToAddY +(760/NUM_TO_DIVIDEY));
       _points[19] = CGPointMake(numToAddX +(323/NUM_TO_DIVIDEX), numToAddY +(806/NUM_TO_DIVIDEY));
       _points[20] = CGPointMake(numToAddX +(315/NUM_TO_DIVIDEX), numToAddY +(847/NUM_TO_DIVIDEY));
       _points[21] = CGPointMake(numToAddX +(310/NUM_TO_DIVIDEX), numToAddY +(897/NUM_TO_DIVIDEY));
       _points[22] = CGPointMake(numToAddX +(305/NUM_TO_DIVIDEX), numToAddY +(930/NUM_TO_DIVIDEY));
       _points[23] = CGPointMake(numToAddX +(302/NUM_TO_DIVIDEX), numToAddY +(971/NUM_TO_DIVIDEY));
       _points[24] = CGPointMake(numToAddX +(300/NUM_TO_DIVIDEX), numToAddY +(1009/NUM_TO_DIVIDEY));       
       _points[25] = CGPointMake(numToAddX +(300/NUM_TO_DIVIDEX), numToAddY +(1023/NUM_TO_DIVIDEY));
       
       
       numToAddY = 1.0/17;
       
       _points[26] = CGPointMake(numToAddX +(302/NUM_TO_DIVIDEX), numToAddY +(4/NUM_TO_DIVIDEY));
       _points[27] = CGPointMake(numToAddX +(303/NUM_TO_DIVIDEX), numToAddY +(118/NUM_TO_DIVIDEY));
       _points[28] = CGPointMake(numToAddX +(300/NUM_TO_DIVIDEX), numToAddY +(120/NUM_TO_DIVIDEY));
       _points[29] = CGPointMake(numToAddX +(303/NUM_TO_DIVIDEX), numToAddY +(140/NUM_TO_DIVIDEY));
       _points[30] = CGPointMake(numToAddX +(235/NUM_TO_DIVIDEX), numToAddY +(163/NUM_TO_DIVIDEY));
       _points[31] = CGPointMake(numToAddX +(214/NUM_TO_DIVIDEX), numToAddY +(181/NUM_TO_DIVIDEY));
       _points[32] = CGPointMake(numToAddX +(193/NUM_TO_DIVIDEX), numToAddY +(207/NUM_TO_DIVIDEY));
       _points[33] = CGPointMake(numToAddX +(188/NUM_TO_DIVIDEX), numToAddY +(231/NUM_TO_DIVIDEY));
       _points[34] = CGPointMake(numToAddX +(189/NUM_TO_DIVIDEX), numToAddY +(245/NUM_TO_DIVIDEY));
       _points[35] = CGPointMake(numToAddX +(298/NUM_TO_DIVIDEX), numToAddY +(629/NUM_TO_DIVIDEY));
       _points[36] = CGPointMake(numToAddX +(317/NUM_TO_DIVIDEX), numToAddY +(662/NUM_TO_DIVIDEY));
       _points[37] = CGPointMake(numToAddX +(338/NUM_TO_DIVIDEX), numToAddY +(681/NUM_TO_DIVIDEY));
       _points[38] = CGPointMake(numToAddX +(360/NUM_TO_DIVIDEX), numToAddY +(691/NUM_TO_DIVIDEY));       
       _points[39] = CGPointMake(numToAddX +(394/NUM_TO_DIVIDEX), numToAddY +(692/NUM_TO_DIVIDEY));
       _points[40] = CGPointMake(numToAddX +(488/NUM_TO_DIVIDEX), numToAddY +(977/NUM_TO_DIVIDEY));
       _points[41] = CGPointMake(numToAddX +(508/NUM_TO_DIVIDEX), numToAddY +(1023/NUM_TO_DIVIDEY));
       
       numToAddY = 2.0/17;
       
       _points[42] = CGPointMake(numToAddX +(507/NUM_TO_DIVIDEX), numToAddY +(2/NUM_TO_DIVIDEY));
       _points[43] = CGPointMake(numToAddX +(562/NUM_TO_DIVIDEX), numToAddY +(105/NUM_TO_DIVIDEY));
       _points[44] = CGPointMake(numToAddX +(606/NUM_TO_DIVIDEX), numToAddY +(154/NUM_TO_DIVIDEY));
       _points[45] = CGPointMake(numToAddX +(633/NUM_TO_DIVIDEX), numToAddY +(183/NUM_TO_DIVIDEY));
       _points[46] = CGPointMake(numToAddX +(795/NUM_TO_DIVIDEX), numToAddY +(295/NUM_TO_DIVIDEY));
       _points[47] = CGPointMake(numToAddX +(917/NUM_TO_DIVIDEX), numToAddY +(371/NUM_TO_DIVIDEY));
       _points[48] = CGPointMake(numToAddX +(964/NUM_TO_DIVIDEX), numToAddY +(384/NUM_TO_DIVIDEY));
       _points[49] = CGPointMake(numToAddX +(1021/NUM_TO_DIVIDEX), numToAddY +(385/NUM_TO_DIVIDEY));
       
       numToAddX = 4.0/8;
       
       _points[50] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(385/NUM_TO_DIVIDEY));
   	   _points[51] = CGPointMake(numToAddX +(84/NUM_TO_DIVIDEX), numToAddY +(382/NUM_TO_DIVIDEY));
	   _points[52] = CGPointMake(numToAddX +(151/NUM_TO_DIVIDEX), numToAddY +(356/NUM_TO_DIVIDEY));
       _points[53] = CGPointMake(numToAddX +(245/NUM_TO_DIVIDEX), numToAddY +(293/NUM_TO_DIVIDEY));
       _points[54] = CGPointMake(numToAddX +(357/NUM_TO_DIVIDEX), numToAddY +(218/NUM_TO_DIVIDEY));
       _points[55] = CGPointMake(numToAddX +(408/NUM_TO_DIVIDEX), numToAddY +(179/NUM_TO_DIVIDEY));
       _points[56] = CGPointMake(numToAddX +(419/NUM_TO_DIVIDEX), numToAddY +(166/NUM_TO_DIVIDEY));
       _points[57] = CGPointMake(numToAddX +(463/NUM_TO_DIVIDEX), numToAddY +(121/NUM_TO_DIVIDEY));
       _points[58] = CGPointMake(numToAddX +(529/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       
       numToAddY = 1.0/17;
       
       _points[59] = CGPointMake(numToAddX +(532/NUM_TO_DIVIDEX), numToAddY +(1022/NUM_TO_DIVIDEY));
       _points[60] = CGPointMake(numToAddX +(560/NUM_TO_DIVIDEX), numToAddY +(951/NUM_TO_DIVIDEY));
       _points[61] = CGPointMake(numToAddX +(645/NUM_TO_DIVIDEX), numToAddY +(689/NUM_TO_DIVIDEY));
       _points[62] = CGPointMake(numToAddX +(676/NUM_TO_DIVIDEX), numToAddY +(689/NUM_TO_DIVIDEY));
       _points[63] = CGPointMake(numToAddX +(712/NUM_TO_DIVIDEX), numToAddY +(671/NUM_TO_DIVIDEY));
       _points[64] = CGPointMake(numToAddX +(743/NUM_TO_DIVIDEX), numToAddY +(625/NUM_TO_DIVIDEY));
       _points[65] = CGPointMake(numToAddX +(851/NUM_TO_DIVIDEX), numToAddY +(237/NUM_TO_DIVIDEY));
       _points[66] = CGPointMake(numToAddX +(842/NUM_TO_DIVIDEX), numToAddY +(199/NUM_TO_DIVIDEY));
       _points[67] = CGPointMake(numToAddX +(828/NUM_TO_DIVIDEX), numToAddY +(180/NUM_TO_DIVIDEY));
       _points[68] = CGPointMake(numToAddX +(804/NUM_TO_DIVIDEX), numToAddY +(163/NUM_TO_DIVIDEY));
       _points[69] = CGPointMake(numToAddX +(736/NUM_TO_DIVIDEX), numToAddY +(138/NUM_TO_DIVIDEY));
       _points[70] = CGPointMake(numToAddX +(741/NUM_TO_DIVIDEX), numToAddY +(112/NUM_TO_DIVIDEY));
       _points[71] = CGPointMake(numToAddX +(746/NUM_TO_DIVIDEX), numToAddY +(112/NUM_TO_DIVIDEY));
       _points[72] = CGPointMake(numToAddX +(748/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       
       numToAddY = 0.0/17;
       
       _points[73] = CGPointMake(numToAddX +(747/NUM_TO_DIVIDEX), numToAddY +(1017/NUM_TO_DIVIDEY));
       _points[74] = CGPointMake(numToAddX +(747/NUM_TO_DIVIDEX), numToAddY +(984/NUM_TO_DIVIDEY));
       _points[75] = CGPointMake(numToAddX +(744/NUM_TO_DIVIDEX), numToAddY +(950/NUM_TO_DIVIDEY));
       _points[76] = CGPointMake(numToAddX +(741/NUM_TO_DIVIDEX), numToAddY +(916/NUM_TO_DIVIDEY));
       _points[77] = CGPointMake(numToAddX +(737/NUM_TO_DIVIDEX), numToAddY +(876/NUM_TO_DIVIDEY));
       _points[78] = CGPointMake(numToAddX +(734/NUM_TO_DIVIDEX), numToAddY +(842/NUM_TO_DIVIDEY));
       _points[79] = CGPointMake(numToAddX +(727/NUM_TO_DIVIDEX), numToAddY +(801/NUM_TO_DIVIDEY));
       _points[80] = CGPointMake(numToAddX +(717/NUM_TO_DIVIDEX), numToAddY +(759/NUM_TO_DIVIDEY));
       _points[81] = CGPointMake(numToAddX +(707/NUM_TO_DIVIDEX), numToAddY +(713/NUM_TO_DIVIDEY));
       _points[82] = CGPointMake(numToAddX +(693/NUM_TO_DIVIDEX), numToAddY +(665/NUM_TO_DIVIDEY));
       _points[83] = CGPointMake(numToAddX +(683/NUM_TO_DIVIDEX), numToAddY +(636/NUM_TO_DIVIDEY));
       _points[84] = CGPointMake(numToAddX +(668/NUM_TO_DIVIDEX), numToAddY +(595/NUM_TO_DIVIDEY));
       _points[85] = CGPointMake(numToAddX +(652/NUM_TO_DIVIDEX), numToAddY +(556/NUM_TO_DIVIDEY));
       _points[86] = CGPointMake(numToAddX +(633/NUM_TO_DIVIDEX), numToAddY +(520/NUM_TO_DIVIDEY));
       _points[87] = CGPointMake(numToAddX +(610/NUM_TO_DIVIDEX), numToAddY +(478/NUM_TO_DIVIDEY));
       _points[88] = CGPointMake(numToAddX +(586/NUM_TO_DIVIDEX), numToAddY +(441/NUM_TO_DIVIDEY));
       _points[89] = CGPointMake(numToAddX +(562/NUM_TO_DIVIDEX), numToAddY +(409/NUM_TO_DIVIDEY));
       _points[90] = CGPointMake(numToAddX +(536/NUM_TO_DIVIDEX), numToAddY +(377/NUM_TO_DIVIDEY));
       _points[91] = CGPointMake(numToAddX +(505/NUM_TO_DIVIDEX), numToAddY +(342/NUM_TO_DIVIDEY));
       _points[92] = CGPointMake(numToAddX +(474/NUM_TO_DIVIDEX), numToAddY +(316/NUM_TO_DIVIDEY));
       _points[93] = CGPointMake(numToAddX +(442/NUM_TO_DIVIDEX), numToAddY +(292/NUM_TO_DIVIDEY));
       _points[94] = CGPointMake(numToAddX +(401/NUM_TO_DIVIDEX), numToAddY +(264/NUM_TO_DIVIDEY));
       _points[95] = CGPointMake(numToAddX +(362/NUM_TO_DIVIDEX), numToAddY +(244/NUM_TO_DIVIDEY));
       _points[96] = CGPointMake(numToAddX +(321/NUM_TO_DIVIDEX), numToAddY +(225/NUM_TO_DIVIDEY));
       _points[97] = CGPointMake(numToAddX +(279/NUM_TO_DIVIDEX), numToAddY +(207/NUM_TO_DIVIDEY));
       _points[98] = CGPointMake(numToAddX +(243/NUM_TO_DIVIDEX), numToAddY +(196/NUM_TO_DIVIDEY));
       _points[99] = CGPointMake(numToAddX +(198/NUM_TO_DIVIDEX), numToAddY +(185/NUM_TO_DIVIDEY));
       _points[100] = CGPointMake(numToAddX +(146/NUM_TO_DIVIDEX), numToAddY +(177/NUM_TO_DIVIDEY));
       _points[101] = CGPointMake(numToAddX +(92/NUM_TO_DIVIDEX), numToAddY +(171/NUM_TO_DIVIDEY));
       _points[102] = CGPointMake(numToAddX +(43/NUM_TO_DIVIDEX), numToAddY +(167/NUM_TO_DIVIDEY));
       _points[103] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(168/NUM_TO_DIVIDEY));
*/
       
       
/*       
       float numToAddX = 3.0/8; // column -1
       float numToAddY = 2.0/17; // row -1
       
       [self setPointCount: 50];
       
       _points[0] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(411/NUM_TO_DIVIDEY));
       _points[1] = CGPointMake(numToAddX +(960/NUM_TO_DIVIDEX), numToAddY +(410/NUM_TO_DIVIDEY));
       _points[2] = CGPointMake(numToAddX +(923/NUM_TO_DIVIDEX), numToAddY +(402/NUM_TO_DIVIDEY));
       _points[3] = CGPointMake(numToAddX +(787/NUM_TO_DIVIDEX), numToAddY +(322/NUM_TO_DIVIDEY));
       _points[4] = CGPointMake(numToAddX +(630/NUM_TO_DIVIDEX), numToAddY +(215/NUM_TO_DIVIDEY));
       _points[5] = CGPointMake(numToAddX +(569/NUM_TO_DIVIDEX), numToAddY +(156/NUM_TO_DIVIDEY));
       _points[6] = CGPointMake(numToAddX +(525/NUM_TO_DIVIDEX), numToAddY +(508/NUM_TO_DIVIDEY));
       _points[7] = CGPointMake(numToAddX +(499/NUM_TO_DIVIDEX), numToAddY +(583/NUM_TO_DIVIDEY));
       _points[8] = CGPointMake(numToAddX +(435/NUM_TO_DIVIDEX), numToAddY +(672/NUM_TO_DIVIDEY));
       _points[9] = CGPointMake(numToAddX +(341/NUM_TO_DIVIDEX), numToAddY +(749/NUM_TO_DIVIDEY));
       _points[10] = CGPointMake(numToAddX +(238/NUM_TO_DIVIDEX), numToAddY +(812/NUM_TO_DIVIDEY));
       _points[11] = CGPointMake(numToAddX +(153/NUM_TO_DIVIDEX), numToAddY +(851/NUM_TO_DIVIDEY));
       _points[12] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(912/NUM_TO_DIVIDEY));
       _points[13] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(963/NUM_TO_DIVIDEY));
       _points[14] = CGPointMake(numToAddX +(45/NUM_TO_DIVIDEX), numToAddY +(1020/NUM_TO_DIVIDEY));
       
       numToAddY = 3.0/17;
       
       _points[15] = CGPointMake(numToAddX +(49/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       _points[16] = CGPointMake(numToAddX +(109/NUM_TO_DIVIDEX), numToAddY +(69/NUM_TO_DIVIDEY));
       _points[17] = CGPointMake(numToAddX +(194/NUM_TO_DIVIDEX), numToAddY +(148/NUM_TO_DIVIDEY));
       _points[18] = CGPointMake(numToAddX +(288/NUM_TO_DIVIDEX), numToAddY +(220/NUM_TO_DIVIDEY));
       _points[19] = CGPointMake(numToAddX +(385/NUM_TO_DIVIDEX), numToAddY +(280/NUM_TO_DIVIDEY));
       _points[20] = CGPointMake(numToAddX +(489/NUM_TO_DIVIDEX), numToAddY +(331/NUM_TO_DIVIDEY));
       _points[21] = CGPointMake(numToAddX +(598/NUM_TO_DIVIDEX), numToAddY +(372/NUM_TO_DIVIDEY));
       _points[22] = CGPointMake(numToAddX +(710/NUM_TO_DIVIDEX), numToAddY +(401/NUM_TO_DIVIDEY));
       _points[23] = CGPointMake(numToAddX +(822/NUM_TO_DIVIDEX), numToAddY +(421/NUM_TO_DIVIDEY));
       _points[24] = CGPointMake(numToAddX +(938/NUM_TO_DIVIDEX), numToAddY +(431/NUM_TO_DIVIDEY));
       _points[25] = CGPointMake(numToAddX +(1020/NUM_TO_DIVIDEX), numToAddY +(432/NUM_TO_DIVIDEY));
       
       numToAddX = 4.0/8;
       
       _points[26] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(433/NUM_TO_DIVIDEY));
       _points[27] = CGPointMake(numToAddX +(89/NUM_TO_DIVIDEX), numToAddY +(431/NUM_TO_DIVIDEY));
       _points[28] = CGPointMake(numToAddX +(205/NUM_TO_DIVIDEX), numToAddY +(418/NUM_TO_DIVIDEY));
       _points[29] = CGPointMake(numToAddX +(319/NUM_TO_DIVIDEX), numToAddY +(398/NUM_TO_DIVIDEY));
       _points[30] = CGPointMake(numToAddX +(428/NUM_TO_DIVIDEX), numToAddY +(365/NUM_TO_DIVIDEY));
       _points[31] = CGPointMake(numToAddX +(563/NUM_TO_DIVIDEX), numToAddY +(308/NUM_TO_DIVIDEY));
       _points[32] = CGPointMake(numToAddX +(664/NUM_TO_DIVIDEX), numToAddY +(253/NUM_TO_DIVIDEY));
       _points[33] = CGPointMake(numToAddX +(781/NUM_TO_DIVIDEX), numToAddY +(171/NUM_TO_DIVIDEY));
       _points[34] = CGPointMake(numToAddX +(868/NUM_TO_DIVIDEX), numToAddY +(94/NUM_TO_DIVIDEY));
       _points[35] = CGPointMake(numToAddX +(953/NUM_TO_DIVIDEX), numToAddY +(2/NUM_TO_DIVIDEY));      
       
       numToAddY = 2.0/17;
       
       _points[36] = CGPointMake(numToAddX +(953/NUM_TO_DIVIDEX), numToAddY +(1023/NUM_TO_DIVIDEY));
	   _points[37] = CGPointMake(numToAddX +(1020/NUM_TO_DIVIDEX), numToAddY +(927/NUM_TO_DIVIDEY));
       _points[38] = CGPointMake(numToAddX +(744/NUM_TO_DIVIDEX), numToAddY +(806/NUM_TO_DIVIDEY));
       _points[39] = CGPointMake(numToAddX +(644/NUM_TO_DIVIDEX), numToAddY +(739/NUM_TO_DIVIDEY));
       _points[40] = CGPointMake(numToAddX +(561/NUM_TO_DIVIDEX), numToAddY +(661/NUM_TO_DIVIDEY));       
       _points[41] = CGPointMake(numToAddX +(498/NUM_TO_DIVIDEX), numToAddY +(546/NUM_TO_DIVIDEY));
       _points[42] = CGPointMake(numToAddX +(452/NUM_TO_DIVIDEX), numToAddY +(171/NUM_TO_DIVIDEY));
       _points[43] = CGPointMake(numToAddX +(412/NUM_TO_DIVIDEX), numToAddY +(209/NUM_TO_DIVIDEY));
       _points[44] = CGPointMake(numToAddX +(373/NUM_TO_DIVIDEX), numToAddY +(240/NUM_TO_DIVIDEY));
       _points[45] = CGPointMake(numToAddX +(311/NUM_TO_DIVIDEX), numToAddY +(281/NUM_TO_DIVIDEY));
       _points[46] = CGPointMake(numToAddX +(238/NUM_TO_DIVIDEX), numToAddY +(331/NUM_TO_DIVIDEY));
       _points[47] = CGPointMake(numToAddX +(150/NUM_TO_DIVIDEX), numToAddY +(387/NUM_TO_DIVIDEY));
       _points[48] = CGPointMake(numToAddX +(89/NUM_TO_DIVIDEX), numToAddY +(409/NUM_TO_DIVIDEY));
       _points[49] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(411/NUM_TO_DIVIDEY));
       
 */
       
       /*
       [self setPointCount: 51];
       
       float numToAddX = 2.0/8; // column -1
       float numToAddY = 2.0/17; // row -1

       
       _points[0] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(980/NUM_TO_DIVIDEY));
       _points[1] = CGPointMake(numToAddX +(989/NUM_TO_DIVIDEX), numToAddY +(926/NUM_TO_DIVIDEY));
       _points[2] = CGPointMake(numToAddX +(782/NUM_TO_DIVIDEX), numToAddY +(991/NUM_TO_DIVIDEY));
       _points[3] = CGPointMake(numToAddX +(782/NUM_TO_DIVIDEX), numToAddY +(1011/NUM_TO_DIVIDEY));
       
       numToAddY = 3.0/17;
       
       _points[4] = CGPointMake(numToAddX +(782/NUM_TO_DIVIDEX), numToAddY +(9/NUM_TO_DIVIDEY));
       _points[5] = CGPointMake(numToAddX +(782/NUM_TO_DIVIDEX), numToAddY +(1023/NUM_TO_DIVIDEY));
       
       numToAddY = 4.0/17;
       
       _points[6] = CGPointMake(numToAddX +(783/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       _points[7] = CGPointMake(numToAddX +(783/NUM_TO_DIVIDEX), numToAddY +(156/NUM_TO_DIVIDEY));
       _points[8] = CGPointMake(numToAddX +(794/NUM_TO_DIVIDEX), numToAddY +(156/NUM_TO_DIVIDEY));
       _points[9] = CGPointMake(numToAddX +(830/NUM_TO_DIVIDEX), numToAddY +(1023/NUM_TO_DIVIDEY));
       
        numToAddY = 5.0/17;
       
       _points[10] = CGPointMake(numToAddX +(831/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       _points[11] = CGPointMake(numToAddX +(833/NUM_TO_DIVIDEX), numToAddY +(39/NUM_TO_DIVIDEY));
       _points[12] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(38/NUM_TO_DIVIDEY));
       
       numToAddX = 3.0/8;
       
       _points[13] = CGPointMake(numToAddX +(16/NUM_TO_DIVIDEX), numToAddY +(39/NUM_TO_DIVIDEY));
       _points[14] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(39/NUM_TO_DIVIDEY));
       
       numToAddX = 4.0/8;
       
       _points[15] = CGPointMake(numToAddX +(2/NUM_TO_DIVIDEX), numToAddY +(39/NUM_TO_DIVIDEY));
       _points[16] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(39/NUM_TO_DIVIDEY));
       
       numToAddX = 5.0/8;
       
       _points[17] = CGPointMake(numToAddX +(2/NUM_TO_DIVIDEX), numToAddY +(39/NUM_TO_DIVIDEY));
       _points[18] = CGPointMake(numToAddX +(187/NUM_TO_DIVIDEX), numToAddY +(39/NUM_TO_DIVIDEY));
       _points[19] = CGPointMake(numToAddX +(190/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       
       numToAddY = 4.0/17;
       
       _points[20] = CGPointMake(numToAddX +(191/NUM_TO_DIVIDEX), numToAddY +(1023/NUM_TO_DIVIDEY));
       _points[21] = CGPointMake(numToAddX +(228/NUM_TO_DIVIDEX), numToAddY +(170/NUM_TO_DIVIDEY));
       _points[22] = CGPointMake(numToAddX +(228/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       
       numToAddY = 3.0/17;
       
       _points[23] = CGPointMake(numToAddX +(227/NUM_TO_DIVIDEX), numToAddY +(1023/NUM_TO_DIVIDEY));
       _points[24] = CGPointMake(numToAddX +(227/NUM_TO_DIVIDEX), numToAddY +(11/NUM_TO_DIVIDEY));
       
       numToAddY = 2.0/17;
       
       _points[25] = CGPointMake(numToAddX +(228/NUM_TO_DIVIDEX), numToAddY +(1010/NUM_TO_DIVIDEY));
       _points[26] = CGPointMake(numToAddX +(228/NUM_TO_DIVIDEX), numToAddY +(1001/NUM_TO_DIVIDEY));
       _points[27] = CGPointMake(numToAddX +(12/NUM_TO_DIVIDEX), numToAddY +(932/NUM_TO_DIVIDEY));
       _points[28] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(950/NUM_TO_DIVIDEY));
       
       numToAddX = 4.0/8;
       numToAddY = 3.0/17;
       
       _points[29] = CGPointMake(numToAddX +(971/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       _points[30] = CGPointMake(numToAddX +(898/NUM_TO_DIVIDEX), numToAddY +(81/NUM_TO_DIVIDEY));
       _points[31] = CGPointMake(numToAddX +(814/NUM_TO_DIVIDEX), numToAddY +(159/NUM_TO_DIVIDEY));
       _points[32] = CGPointMake(numToAddX +(721/NUM_TO_DIVIDEX), numToAddY +(229/NUM_TO_DIVIDEY));            
       _points[33] = CGPointMake(numToAddX +(623/NUM_TO_DIVIDEX), numToAddY +(290/NUM_TO_DIVIDEY));
	   _points[34] = CGPointMake(numToAddX +(518/NUM_TO_DIVIDEX), numToAddY +(344/NUM_TO_DIVIDEY));
       _points[35] = CGPointMake(numToAddX +(409/NUM_TO_DIVIDEX), numToAddY +(383/NUM_TO_DIVIDEY));
       _points[36] = CGPointMake(numToAddX +(320/NUM_TO_DIVIDEX), numToAddY +(409/NUM_TO_DIVIDEY));
       _points[37] = CGPointMake(numToAddX +(239/NUM_TO_DIVIDEX), numToAddY +(425/NUM_TO_DIVIDEY));       
       _points[38] = CGPointMake(numToAddX +(123/NUM_TO_DIVIDEX), numToAddY +(441/NUM_TO_DIVIDEY));
       _points[39] = CGPointMake(numToAddX +(6/NUM_TO_DIVIDEX), numToAddY +(446/NUM_TO_DIVIDEY));
       
       
       numToAddX = 3.0/8;
       
       _points[40] = CGPointMake(numToAddX +(1022/NUM_TO_DIVIDEX), numToAddY +(446/NUM_TO_DIVIDEY));
       _points[41] = CGPointMake(numToAddX +(914/NUM_TO_DIVIDEX), numToAddY +(443/NUM_TO_DIVIDEY));
       _points[42] = CGPointMake(numToAddX +(766/NUM_TO_DIVIDEX), numToAddY +(426/NUM_TO_DIVIDEY));
       _points[43] = CGPointMake(numToAddX +(650/NUM_TO_DIVIDEX), numToAddY +(401/NUM_TO_DIVIDEY));
       _points[44] = CGPointMake(numToAddX +(570/NUM_TO_DIVIDEX), numToAddY +(377/NUM_TO_DIVIDEY));
       _points[45] = CGPointMake(numToAddX +(462/NUM_TO_DIVIDEX), numToAddY +(332/NUM_TO_DIVIDEY));
       _points[46] = CGPointMake(numToAddX +(360/NUM_TO_DIVIDEX), numToAddY +(279/NUM_TO_DIVIDEY));
       _points[47] = CGPointMake(numToAddX +(261/NUM_TO_DIVIDEX), numToAddY +(215/NUM_TO_DIVIDEY));
       _points[48] = CGPointMake(numToAddX +(170/NUM_TO_DIVIDEX), numToAddY +(142/NUM_TO_DIVIDEY));
       _points[49] = CGPointMake(numToAddX +(87/NUM_TO_DIVIDEX), numToAddY +(61/NUM_TO_DIVIDEY));
       _points[50] = CGPointMake(numToAddX +(33/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       */
       
       /*
       [self setPointCount: 34];
       
       float numToAddX = 2.0/8; // column -1
       float numToAddY = 5.0/17; // row -1
       
       _points[0] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(52/NUM_TO_DIVIDEY));
       _points[1] = CGPointMake(numToAddX +(831/NUM_TO_DIVIDEX), numToAddY +(52/NUM_TO_DIVIDEY));
       _points[2] = CGPointMake(numToAddX +(842/NUM_TO_DIVIDEX), numToAddY +(426/NUM_TO_DIVIDEY));
       _points[3] = CGPointMake(numToAddX +(852/NUM_TO_DIVIDEX), numToAddY +(1023/NUM_TO_DIVIDEY));
       
       numToAddY = 6.0/17;
       
       _points[4] = CGPointMake(numToAddX +(852/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       _points[5] = CGPointMake(numToAddX +(852/NUM_TO_DIVIDEX), numToAddY +(80/NUM_TO_DIVIDEY));
       _points[6] = CGPointMake(numToAddX +(848/NUM_TO_DIVIDEX), numToAddY +(209/NUM_TO_DIVIDEY));
       _points[7] = CGPointMake(numToAddX +(832/NUM_TO_DIVIDEX), numToAddY +(349/NUM_TO_DIVIDEY));
       _points[8] = CGPointMake(numToAddX +(809/NUM_TO_DIVIDEX), numToAddY +(496/NUM_TO_DIVIDEY));
       _points[9] = CGPointMake(numToAddX +(786/NUM_TO_DIVIDEX), numToAddY +(605/NUM_TO_DIVIDEY));
       _points[10] = CGPointMake(numToAddX +(691/NUM_TO_DIVIDEX), numToAddY +(1023/NUM_TO_DIVIDEY));
                                 
       numToAddY = 7.0/17;                                    
       
       _points[11] = CGPointMake(numToAddX +(688/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       _points[12] = CGPointMake(numToAddX +(685/NUM_TO_DIVIDEX), numToAddY +(9/NUM_TO_DIVIDEY));
       _points[13] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(8/NUM_TO_DIVIDEY));
       
       numToAddX = 3.0/8;
       
       _points[14] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(8/NUM_TO_DIVIDEY));
       _points[15] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(8/NUM_TO_DIVIDEY));
       
       numToAddX = 4.0/8;
       
       _points[16] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(8/NUM_TO_DIVIDEY));
       _points[17] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(8/NUM_TO_DIVIDEY));
       
       numToAddX = 5.0/8;       
       
       _points[18] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(8/NUM_TO_DIVIDEY));
       _points[19] = CGPointMake(numToAddX +(321/NUM_TO_DIVIDEX), numToAddY +(8/NUM_TO_DIVIDEY));
       _points[20] = CGPointMake(numToAddX +(319/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       
       numToAddY = 6.0/17;
       
       _points[21] = CGPointMake(numToAddX +(320/NUM_TO_DIVIDEX), numToAddY +(1021/NUM_TO_DIVIDEY));
       _points[22] = CGPointMake(numToAddX +(206/NUM_TO_DIVIDEX), numToAddY +(502/NUM_TO_DIVIDEY));
       _points[23] = CGPointMake(numToAddX +(179/NUM_TO_DIVIDEX), numToAddY +(302/NUM_TO_DIVIDEY));
       _points[24] = CGPointMake(numToAddX +(169/NUM_TO_DIVIDEX), numToAddY +(194/NUM_TO_DIVIDEY));
       _points[25] = CGPointMake(numToAddX +(166/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       
       numToAddY = 5.0/17;
       
       _points[26] = CGPointMake(numToAddX +(165/NUM_TO_DIVIDEX), numToAddY +(1023/NUM_TO_DIVIDEY));
       _points[27] = CGPointMake(numToAddX +(166/NUM_TO_DIVIDEX), numToAddY +(836/NUM_TO_DIVIDEY));
       _points[28] = CGPointMake(numToAddX +(188/NUM_TO_DIVIDEX), numToAddY +(52/NUM_TO_DIVIDEY)); 
       _points[29] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(52/NUM_TO_DIVIDEY));
       
       numToAddX = 4.0/8;
       
       _points[30] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(52/NUM_TO_DIVIDEY));
       _points[31] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(52/NUM_TO_DIVIDEY));
       
       numToAddX = 3.0/8;
       
       _points[32] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(52/NUM_TO_DIVIDEY));
       _points[33] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(52/NUM_TO_DIVIDEY));
         
        */
       
/*
       float numToAddX = 3.0/8; // column -1
       float numToAddY = 2.0/17; // row -1
       
       [self setPointCount: 78];
       
	   _points[0] = CGPointMake(numToAddX +(1017/NUM_TO_DIVIDEX), numToAddY +(803/NUM_TO_DIVIDEY));
       _points[1] = CGPointMake(numToAddX +(952/NUM_TO_DIVIDEX), numToAddY +(801/NUM_TO_DIVIDEY));
       _points[2] = CGPointMake(numToAddX +(856/NUM_TO_DIVIDEX), numToAddY +(781/NUM_TO_DIVIDEY));
       _points[3] = CGPointMake(numToAddX +(778/NUM_TO_DIVIDEX), numToAddY +(753/NUM_TO_DIVIDEY));
       _points[4] = CGPointMake(numToAddX +(724/NUM_TO_DIVIDEX), numToAddY +(725/NUM_TO_DIVIDEY));
       _points[5] = CGPointMake(numToAddX +(648/NUM_TO_DIVIDEX), numToAddY +(670/NUM_TO_DIVIDEY));
       _points[6] = CGPointMake(numToAddX +(604/NUM_TO_DIVIDEX), numToAddY +(630/NUM_TO_DIVIDEY));
       _points[7] = CGPointMake(numToAddX +(521/NUM_TO_DIVIDEX), numToAddY +(529/NUM_TO_DIVIDEY));
       _points[8] = CGPointMake(numToAddX +(511/NUM_TO_DIVIDEX), numToAddY +(559/NUM_TO_DIVIDEY));
       _points[9] = CGPointMake(numToAddX +(489/NUM_TO_DIVIDEX), numToAddY +(604/NUM_TO_DIVIDEY));
       _points[10] = CGPointMake(numToAddX +(455/NUM_TO_DIVIDEX), numToAddY +(653/NUM_TO_DIVIDEY));
       _points[11] = CGPointMake(numToAddX +(402/NUM_TO_DIVIDEX), numToAddY +(703/NUM_TO_DIVIDEY));
       _points[12] = CGPointMake(numToAddX +(342/NUM_TO_DIVIDEX), numToAddY +(748/NUM_TO_DIVIDEY));
       _points[13] = CGPointMake(numToAddX +(268/NUM_TO_DIVIDEX), numToAddY +(795/NUM_TO_DIVIDEY));
       _points[14] = CGPointMake(numToAddX +(192/NUM_TO_DIVIDEX), numToAddY +(835/NUM_TO_DIVIDEY));
       _points[15] = CGPointMake(numToAddX +(107/NUM_TO_DIVIDEX), numToAddY +(872/NUM_TO_DIVIDEY));
       _points[16] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(912/NUM_TO_DIVIDEY));
       
       numToAddX = 2.0/8;
       
       _points[17] = CGPointMake(numToAddX +(1021/NUM_TO_DIVIDEX), numToAddY +(914/NUM_TO_DIVIDEY));
       _points[18] = CGPointMake(numToAddX +(928/NUM_TO_DIVIDEX), numToAddY +(945/NUM_TO_DIVIDEY));
       _points[19] = CGPointMake(numToAddX +(991/NUM_TO_DIVIDEX), numToAddY +(984/NUM_TO_DIVIDEY));
       _points[20] = CGPointMake(numToAddX +(1022/NUM_TO_DIVIDEX), numToAddY +(1006/NUM_TO_DIVIDEY));
       
       numToAddX = 3.0/8;
       numToAddY = 3.0/17;
       
       _points[21] = CGPointMake(numToAddX +(13/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       _points[22] = CGPointMake(numToAddX +(71/NUM_TO_DIVIDEX), numToAddY +(53/NUM_TO_DIVIDEY));
       _points[23] = CGPointMake(numToAddX +(125/NUM_TO_DIVIDEX), numToAddY +(130/NUM_TO_DIVIDEY));
       _points[24] = CGPointMake(numToAddX +(174/NUM_TO_DIVIDEX), numToAddY +(232/NUM_TO_DIVIDEY));       
       _points[25] = CGPointMake(numToAddX +(197/NUM_TO_DIVIDEX), numToAddY +(314/NUM_TO_DIVIDEY));
       _points[26] = CGPointMake(numToAddX +(209/NUM_TO_DIVIDEX), numToAddY +(376/NUM_TO_DIVIDEY));
       _points[27] = CGPointMake(numToAddX +(216/NUM_TO_DIVIDEX), numToAddY +(464/NUM_TO_DIVIDEY));
       _points[28] = CGPointMake(numToAddX +(213/NUM_TO_DIVIDEX), numToAddY +(548/NUM_TO_DIVIDEY));
       _points[29] = CGPointMake(numToAddX +(197/NUM_TO_DIVIDEX), numToAddY +(639/NUM_TO_DIVIDEY));
       _points[30] = CGPointMake(numToAddX +(174/NUM_TO_DIVIDEX), numToAddY +(718/NUM_TO_DIVIDEY));
       _points[31] = CGPointMake(numToAddX +(136/NUM_TO_DIVIDEX), numToAddY +(804/NUM_TO_DIVIDEY));
       _points[32] = CGPointMake(numToAddX +(96/NUM_TO_DIVIDEX), numToAddY +(877/NUM_TO_DIVIDEY));
       _points[33] = CGPointMake(numToAddX +(42/NUM_TO_DIVIDEX), numToAddY +(952/NUM_TO_DIVIDEY));
       _points[34] = CGPointMake(numToAddX +(4/NUM_TO_DIVIDEX), numToAddY +(997/NUM_TO_DIVIDEY));
       
       
       numToAddX = 2.0/8;
       numToAddY = 4.0/17;
       
       
       _points[35] = CGPointMake(numToAddX +(1003/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       _points[36] = CGPointMake(numToAddX +(899/NUM_TO_DIVIDEX), numToAddY +(98/NUM_TO_DIVIDEY));
       _points[37] = CGPointMake(numToAddX +(1021/NUM_TO_DIVIDEX), numToAddY +(415/NUM_TO_DIVIDEY));
       
       
       numToAddX = 3.0/8;
       
       _points[38] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(421/NUM_TO_DIVIDEY));       
       _points[39] = CGPointMake(numToAddX +(35/NUM_TO_DIVIDEX), numToAddY +(547/NUM_TO_DIVIDEY));
       _points[40] = CGPointMake(numToAddX +(69/NUM_TO_DIVIDEX), numToAddY +(688/NUM_TO_DIVIDEY));
       _points[41] = CGPointMake(numToAddX +(92/NUM_TO_DIVIDEX), numToAddY +(799/NUM_TO_DIVIDEY));       
       _points[42] = CGPointMake(numToAddX +(123/NUM_TO_DIVIDEX), numToAddY +(1023/NUM_TO_DIVIDEY));
       
       
       numToAddY = 5.0/17;
       
       _points[43] = CGPointMake(numToAddX +(123/NUM_TO_DIVIDEX), numToAddY +(2/NUM_TO_DIVIDEY));
       _points[44] = CGPointMake(numToAddX +(134/NUM_TO_DIVIDEX), numToAddY +(123/NUM_TO_DIVIDEY));
       _points[45] = CGPointMake(numToAddX +(138/NUM_TO_DIVIDEX), numToAddY +(239/NUM_TO_DIVIDEY));
       _points[46] = CGPointMake(numToAddX +(137/NUM_TO_DIVIDEX), numToAddY +(390/NUM_TO_DIVIDEY));
       _points[47] = CGPointMake(numToAddX +(124/NUM_TO_DIVIDEX), numToAddY +(532/NUM_TO_DIVIDEY));
       _points[48] = CGPointMake(numToAddX +(102/NUM_TO_DIVIDEX), numToAddY +(647/NUM_TO_DIVIDEY));
       _points[49] = CGPointMake(numToAddX +(64/NUM_TO_DIVIDEX), numToAddY +(758/NUM_TO_DIVIDEY));     
       _points[50] = CGPointMake(numToAddX +(20/NUM_TO_DIVIDEX), numToAddY +(841/NUM_TO_DIVIDEY));
   	   _points[51] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(871/NUM_TO_DIVIDEY));
       
       
       numToAddX = 2.0/8;
       
	   _points[52] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(875/NUM_TO_DIVIDEY));
       _points[53] = CGPointMake(numToAddX +(961/NUM_TO_DIVIDEX), numToAddY +(940/NUM_TO_DIVIDEY));
       _points[54] = CGPointMake(numToAddX +(900/NUM_TO_DIVIDEX), numToAddY +(974/NUM_TO_DIVIDEY));
       _points[55] = CGPointMake(numToAddX +(855/NUM_TO_DIVIDEX), numToAddY +(990/NUM_TO_DIVIDEY));
       _points[56] = CGPointMake(numToAddX +(855/NUM_TO_DIVIDEX), numToAddY +(1023/NUM_TO_DIVIDEY));
       
       
       numToAddY = 6.0/17;
       
       _points[57] = CGPointMake(numToAddX +(851/NUM_TO_DIVIDEX), numToAddY +(147/NUM_TO_DIVIDEY));
       _points[58] = CGPointMake(numToAddX +(844/NUM_TO_DIVIDEX), numToAddY +(259/NUM_TO_DIVIDEY));       
       _points[59] = CGPointMake(numToAddX +(910/NUM_TO_DIVIDEX), numToAddY +(297/NUM_TO_DIVIDEY));
       _points[60] = CGPointMake(numToAddX +(975/NUM_TO_DIVIDEX), numToAddY +(304/NUM_TO_DIVIDEY));
       _points[61] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(295/NUM_TO_DIVIDEY));
       
       
       numToAddX = 3.0/8;
       
       _points[62] = CGPointMake(numToAddX +(1/NUM_TO_DIVIDEX), numToAddY +(291/NUM_TO_DIVIDEY));
       _points[63] = CGPointMake(numToAddX +(52/NUM_TO_DIVIDEX), numToAddY +(260/NUM_TO_DIVIDEY));
       _points[64] = CGPointMake(numToAddX +(152/NUM_TO_DIVIDEX), numToAddY +(146/NUM_TO_DIVIDEY));
       _points[65] = CGPointMake(numToAddX +(253/NUM_TO_DIVIDEX), numToAddY +(3/NUM_TO_DIVIDEY));
       
       
       numToAddY = 5.0/17;
       
       
       _points[66] = CGPointMake(numToAddX +(236/NUM_TO_DIVIDEX), numToAddY +(1010/NUM_TO_DIVIDEY));
       _points[67] = CGPointMake(numToAddX +(457/NUM_TO_DIVIDEX), numToAddY +(675/NUM_TO_DIVIDEY));
       _points[68] = CGPointMake(numToAddX +(608/NUM_TO_DIVIDEX), numToAddY +(360/NUM_TO_DIVIDEY));
       _points[69] = CGPointMake(numToAddX +(675/NUM_TO_DIVIDEX), numToAddY +(234/NUM_TO_DIVIDEY));
       _points[70] = CGPointMake(numToAddX +(752/NUM_TO_DIVIDEX), numToAddY +(105/NUM_TO_DIVIDEY));
       _points[71] = CGPointMake(numToAddX +(799/NUM_TO_DIVIDEX), numToAddY +(36/NUM_TO_DIVIDEY));
       _points[72] = CGPointMake(numToAddX +(824/NUM_TO_DIVIDEX), numToAddY +(1/NUM_TO_DIVIDEY));
       
       
       numToAddY = 4.0/17;
       
       _points[73] = CGPointMake(numToAddX +(833/NUM_TO_DIVIDEX), numToAddY +(1017/NUM_TO_DIVIDEY));
       _points[74] = CGPointMake(numToAddX +(897/NUM_TO_DIVIDEX), numToAddY +(948/NUM_TO_DIVIDEY));
       _points[75] = CGPointMake(numToAddX +(947/NUM_TO_DIVIDEX), numToAddY +(913/NUM_TO_DIVIDEY));
       _points[76] = CGPointMake(numToAddX +(970/NUM_TO_DIVIDEX), numToAddY +(900/NUM_TO_DIVIDEY));
       _points[77] = CGPointMake(numToAddX +(1017/NUM_TO_DIVIDEX), numToAddY +(887/NUM_TO_DIVIDEY));

       
       [self bezierPath];
  */     
         }
   return self;
}

- (UIBezierPath *) bezierPath {
    
    
   if (!_bezierPath) {

       _bezierPath = [UIBezierPath bezierPath];

       if (_pointCount > 2) {
         
//          [_bezierPath moveToPoint: _points[0]];
           [_bezierPath moveToPoint: CGPointMake(_points[0].x*NUM_TO_DIVIDEX,_points[0].y*NUM_TO_DIVIDEY ) ];

          for (int i=1; i<_pointCount; i++) {
             
             NSLog(@"Point is x:%f y:%f",_points[i].x, _points[i].y);
             
//            [_bezierPath addLineToPoint: _points[i]];
              [_bezierPath addLineToPoint:CGPointMake(_points[i].x*NUM_TO_DIVIDEX,_points[i].y*NUM_TO_DIVIDEY )];
         }
         [_bezierPath closePath];
     }
   }
   return _bezierPath;
}

- (void) setPointCount: (NSInteger) newPoints {
   
    if (_points) {free(_points);}
   _points = calloc(sizeof(CGPoint), newPoints);
   _pointCount = newPoints;
   self.bezierPath = nil;
    
}

- (void) dealloc {
   if (_points) free(_points);
}

- (BOOL) containsPoint: (CGPoint) point {
   // TODO:  Find an algorithm for quickly determining whether a polygon contains a point
        
    NSLog(@"The bounds of Bezierpath are %f %f", self.bezierPath.bounds.size.width,self.bezierPath.bounds.size.height);
    
    return [self.bezierPath containsPoint:CGPointMake(point.x*NUM_TO_DIVIDEX, point.y*NUM_TO_DIVIDEY)];
//    return (CGRectContainsPoint(self.bezierPath.bounds, point));
    
//    return [self.bezierPath containsPoint: point];
}

-(CGPoint *)getPoints{
    return _points;   
}

@end
