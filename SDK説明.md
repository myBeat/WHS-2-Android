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
@property (nonatomic) MBLeManager *leManager;

@end
```

ViewController.m
```objectivec
#import "ViewController.h"
#import "MBLeManager.h"

NSString* const ObserverKeyFindDevice = @"foundPeripheral";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _leManager = [[MBLeManager alloc]init];
    
    [self addBluetoothObserver];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.leManager removeObserver:self forKeyPath:ObserverKeyFindDevice];
}

//デバイスのスキャンを開始
- (IBAction)touchScanButton:(id)sender
{
    [_leManager startScan];
}

//デバイス発見の監視
- (void)addBluetoothObserver
{
    [self.leManager addObserver:self
                     forKeyPath:ObserverKeyFindDevice
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
}

//デバイス発見時の処理
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if([keyPath isEqualToString:ObserverKeyFindDevice]) {
    }
}
```

####2.2 WHS-2に接続と受信####

発見されたWHS-2(peripheral)を引数にconnectPeripheralを呼ぶ事でWHS-2に接続します。
接続処理が成功すると自動的に受信が開始されます。
```objectivec
[_leManager connectPeripheral:peripheral];
```

手動で受信を開始する場合は、setNotifyを呼び出してください。
```objectivec
[_leManager setNotify:YES peripheral:peripheral];
```

####2.3 WHS-2の設定の書き込み####

以下の(1)〜(5)の手順に、WHS-2に設定を書き込みます。
設定値の読み込みについても同様の手順となります。
コマンド一覧は、「3. 付録」に記載します。

#####(1).計測モード(計測値を受信している状態)から設定モードに変更する#####

```objectivec
[_leWriter sendCommand:typeCommandSettingModeStart];
```

#####(2).設定値を書き込む#####

```objectivec
[_leWriter sendCommand:typeCommandBehaviorRead];
```

#####(3).書き込み結果を受信する#####

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

#####(4).設定モードを終了する#####

```objectivec
[_leWriter sendCommand:typeCommandSettingModeEnd];
```

#####(5).計測モードを開始する#####

```objectivec
[_leWriter sendCommand:typeCommandMeasureModeStart];
```

####2.4 WHS-2との切断####

```objectivec
[_leManager disconnectPeripheral:peripheral];
```


3 付録
-----------------------

####3.1 コマンド一覧####

```objectivec
typedef NS_ENUM(int, BleCommand){
    typeCommandSettingModeStart=0,          //設定モード開始
    typeCommandSettingModeEnd=1,            //設定モード終了
    typeCommandMeasureModeStart=2,          //計測モード開始
    typeCommandBehaviorAllRead=3,           //動作モード、加速度モード読み込み
    typeCommandBehaviorRead=8,              //動作モード読み込み
    typeCommandBehaviorWritePqrst=9,        //動作モードをPQRSTに設定する
    typeCommandBehaviorWriteRri=10,         //動作モードをRRIに設定する
    typeCommandAccelerationRead=11,         //加速度モード読み込み
    typeCommandAccelerationWriteAverage=12, //加速度モードを移動平均に設定する
    typeCommandAccelerationWritePeak=13,    //加速度モードをピークホールドに設定する
    typeCommandExteriorRead=14,             //外装シリアル番号を読み込む
    typeCommandSubstrateRead=15,            //基板シリアル番号を読み込む
    typeCommandMainFarmRead=16,             //メインファームバージョンを読み込む
    typeCommandBleFarmRead=17,              //BLEファームバージョンを読み込む
};
```
