#ImageSize
##简介
	根据URL获取图片大小，支持PNG、JPG、GIF格式
##安装
	添加系统框架CoreGraphics.framework
##Demo
	
```
	[ImageSize calculateImageSizeWithURLString:@"http://pic12.nipic.com/20110118/1295091_171039317000_2.png" success:^(CGSize imageSize) {
        NSLog(@"%@",NSStringFromCGSize(imageSize));
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
```