1 はじめに
--------------

####1.1 開発環境####


Mac OS X 10.9 以降と, 統合開発環境 (IDE) としてXcode5.0 を使用することを推奨します.

####1.2 SDKの読み込み方法####

[SDK読み込み手順](SDK読み込み手順.md)を参照のこと


2 WHS-2の検出、接続、受信、設定、切断
--------------

####2.1 WHS-2の検索と検出結果の取得####

ViewController.h
```objectivec
@class MBLeManager;

@interface ViewController : UITableViewController
@property (weak, nonatomic) MBLeManager *leManager;

@end
```

ViewController.m
```objectivec
#import "ViewController.h"
#import "MBLeManager.h"

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _leManager = [[MBLeManager alloc]init];
    
    //デバイスのスキャンを開始
    [_leManager startScan];
}

//デバイス発見の監視
- (void)addBluetoothObserver {
    [self.leManager addObserver:self
                     forKeyPath:ObserverKeyFindDevice
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
}

//デバイス発見時の処理
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if([keyPath isEqualToString:ObserverKeyFindDevice]) {
       ・・・・
    }
}
```

####2.2 WHS-2に接続####

```objectivec

[_leManager connectPeripheral:peripheral];

```

####2.3 計測データの受信####

```objectivec

[_leManager setNotify:YES peripheral:peripheral];

```

####2.4 WHS-2の設定####

####2.5 WHS-2との切断####

```objectivec

[_leManager disconnectPeripheral:peripheral];

```
