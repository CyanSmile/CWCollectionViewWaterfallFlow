//
//  ViewController.m
//  CWCollectionList
//
//  Created by wangcyan on 16/12/2.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ViewController.h"
#import "CWCollectionViewLayout.h"
#import "CWCollectionViewCell.h"

#define Wide self.view.frame.size.width-20
#define Height self.view.frame.size.height-30

@interface ViewController () <CWCollectionViewLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)btnReload:(UIButton *)sender;

//@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController
static NSString * const Identifier =  @"cellIdentitier";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CWCollectionViewLayout *layout = [[CWCollectionViewLayout alloc] init];
    layout.layoutDelegate = self;
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 20, Wide, Height) collectionViewLayout:layout];
//    collectionView.backgroundColor = [UIColor lightGrayColor];
//    collectionView.dataSource = self;
//    [self.view addSubview:collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"CWCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:Identifier];
//    self.collectionView = collectionView;
    _collectionView.collectionViewLayout = layout;
    
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return random()%15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionViewLayout:(CWCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((Wide-30)/2, rand()%200);
}

- (BOOL)updateViewFrameInWaterflowLayout:(CWCollectionViewLayout *)collectionViewLayout {
    
    //默认为NO,不会改变CollectionView的高度
    return YES;
}

- (IBAction)btnReload:(UIButton *)sender {
    
    [self.collectionView reloadData];
}

@end
