//
//  DYViewController.m
//  DYTableView
//
//  Created by htkg on 17/3/8.
//  Copyright © 2017年 Uranus. All rights reserved.
//

#import "DYViewController.h"
#import "DYModel.h"        

#import <objc/runtime.h>
char* const selectButtonKey = "selectButtonKey";
#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@interface DYViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataSource;
@end

@implementation DYViewController
//假数据
-(NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
        for (int i=0; i<3; i++) {
            DYModel * list = [DYModel new];
            for (int j=0; j<5; j++) {
                DYModel * model = [[DYModel alloc]init];
                model.name=[NSString stringWithFormat:@"index:%d-%d",i,j];
                [list.list addObject:model];
            }
            list.isExpand=NO;
            list.hasLevel=YES;
            [_dataSource addObject:list];
        }
        for (int j=0; j<5; j++) {
            DYModel * model = [[DYModel alloc]init];
            model.name=[NSString stringWithFormat:@"index:%d",j];
            model.hasLevel=NO;
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    // Do any additional setup after loading the view.
}
-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    DYModel * model = self.dataSource[indexPath.section];
    if (model.hasLevel) {
        DYModel * submodel = model.list[indexPath.row];
        cell.textLabel.text=submodel.name;
    }else{
        cell.textLabel.text=model.name;
    }
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    DYModel * model = self.dataSource [section];
    if (model.hasLevel) {
        return model.isExpand?model.list.count:0;
    }else
        return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    DYModel * model = self.dataSource[indexPath.section];
    if (model.hasLevel) {
        DYModel * subModel = model.list[indexPath.row];
        NSLog(@"%@",subModel.name);
    }else{
        NSLog(@"%@",model.name);
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    DYModel * model = self.dataSource[section];
    if (model.hasLevel) {
        UIView * view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        return view;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    DYModel * model = self.dataSource[section];
    if (model.hasLevel) {
        return 0.01f;//50.0f;
    }
    return 0.01f;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DYModel * model = self.dataSource[section];
    if (model.hasLevel) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        UIButton * select = [UIButton buttonWithType:UIButtonTypeSystem];
        select.tag=section;
        select.frame=view.frame;
        [select addTarget:self action:@selector(sectionDidSelect:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:select];
        [select setTitle:[NSString stringWithFormat:@"section:%ld",(long)section] forState:UIControlStateNormal];
        
        //箭头标注
        if (model.isExpand) {
            UIImageView * _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (50-8)/2, 12, 8)];
            [_imgView setImage:[UIImage imageNamed:@"arrow"]];
            [view addSubview:_imgView];
            CGAffineTransform currentTransform = _imgView.transform;
            CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, 0); // 在现在的基础上旋转指定角度
            _imgView.transform = newTransform;
            objc_setAssociatedObject(select, selectButtonKey, _imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
        }else{
            UIImageView * _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (50-8)/2, 12, 8)];
            [_imgView setImage:[UIImage imageNamed:@"arrow"]];
            [view addSubview:_imgView];
            CGAffineTransform currentTransform = _imgView.transform;
            CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, M_PI); // 在现在的基础上旋转指定角度
            _imgView.transform = newTransform;
            objc_setAssociatedObject(select, selectButtonKey, _imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
        }
        
        
        return view;
    }
    else
        return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    DYModel * model = self.dataSource[section];
    if (model.hasLevel) {
        return 50.0f;
    }else
    return 0.01f;
}
- (void)sectionDidSelect:(UIButton*)sender
{
    DYModel * model = self.dataSource[sender.tag];
    model.isExpand=!model.isExpand;
     [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
    
    UIImageView *imageView =  objc_getAssociatedObject(sender,selectButtonKey);    
    if (model.isExpand) {

        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            CGAffineTransform currentTransform = imageView.transform;
            CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, -M_PI); // 在现在的基础上旋转指定角度
            imageView.transform = newTransform;
        } completion:^(BOOL finished) {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
        }];
    }else{
        [UIView animateWithDuration:0.15 delay:0.0 options: UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionCurveLinear animations:^{
            CGAffineTransform currentTransform = imageView.transform;
            CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, M_PI); // 在现在的基础上旋转指定角度
            imageView.transform = newTransform;
        } completion:^(BOOL finished) {
        }];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
