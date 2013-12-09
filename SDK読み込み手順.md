SDK設定手順
-------------------------


(1) XcodeでSDKを利用する新規プロジェクトを開く

![1-1](img/1_1.png)

(2) GitHubから取得したWHS2-SDK.xcodeprojを、Finderを利用してプロジェクトにドラッグ&ドロップする

GitHubから取得したProject

![1-2](img/1-2.png)

ドラッグ&ドロップした結果

![1-3](img/1-3.png)

(3) プロジェクトのBuild PhasesタブのLink Binary With Librariesに、CoreBluetooth.frameworkとlibWHS2-SDK.aを追加する

![1-4](img/1-4.png)

(4) プロジェクトのBuild SettingsタブのSearch Paths -> Header Serch Pathsにsdk/WHS2-SDK/へのPathを追加する

![1-5](img/1-5.png)
