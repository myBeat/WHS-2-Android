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

####2.2 WHS-2に接続と受信####

以下の接続処理が成功すると自動的に受信が開始されます。

```objectivec

[_leManager connectPeripheral:peripheral];

```

手動で受信を開始する場合は、setNotifyを呼び出してください。

```objectivec

[_leManager setNotify:YES peripheral:peripheral];

```

####2.3 WHS-2の設定の書き込み####

WHS-2の設定を変更する手順

#####1.計測モード(計測値を受信している状態)から設定モードに変更する#####

```objectivec
[_leWriter sendCommand:typeCommandSettingModeStart];
```

#####2.設定値を書き込む#####

- 書き込み処理

```objectivec
[_leWriter sendCommand:typeCommandBehaviorRead];
```

#####3.書き込み結果を受信する#####

- Observerの登録

```objectivec
[_leWriter.commandQue addObserver:self
                       forKeyPath:[NSString stringWithFormat:@"%i",typeCommandBehaviorRead]
                          options:NSKeyValueObservingOptionNew  context:NULL];
```

- 結果の受信

```objectivec
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:[NSString stringWithFormat:@"%i",typeCommandBehaviorRead]]){
        if ([[self.leWriter whsDevice] behavior] != nil){
            ・・・
        }
    }
}
```

#####4.設定モードを終了する#####

```objectivec
[_leWriter sendCommand:typeCommandSettingModeEnd];
```

#####5.計測モードを開始する#####

```objectivec
[_leWriter sendCommand:typeCommandMeasureModeStart];
```

####2.4 WHS-2との切断####

```objectivec

[_leManager disconnectPeripheral:peripheral];

```
