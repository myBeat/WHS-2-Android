# AppStoreに公開されているiOS向けアプリ内の計測データの利用について

直接、SQLite3を操作することでデータを取得できます。


### 1. Sqlite3をインストールする

### 2. iTunesを利用してMeasure.sqliteを取得する

### 3. Sqlite3で接続する
>Sqlite3 Measure.sql

### 4. 計測のID（ZMEASURE_ID）を取得する

```
> select ZMEASURE_ID, time(ZMEASURE_DT_START), time(ZMEASURE_DT_END) from zmeasure
```

(例) 
20140129090906|19:27:04|04:52:28

### 5. 計測データをCSV形式で取得する

```
> .mode csv
> .output ファイル名称.csv
```

- 心拍波形の場合

```
> select ZMEASURE_ID, ZPQRST, ZACCELERATION_X, ZACCELERATION_Y, ZACCELERATION_Z, ZTEMPERATURE, ZELAPSED_TIME, time(ZRECEIVED_DT) from ZPQRST where ZMEASURE_ID = '201401290909061'
```

- 心拍周期　加速度ピークホールドの場合

```
> select ZMEASURE_ID, ZRRI, ZACCELERATION_X_PLUS, ZACCELERATION_Y_PLUS, ZACCELERATION_Z_PLUS, ZACCELERATION_X_MINUS, ZACCELERATION_Y_MINUS, ZACCELERATION_Z_MINUS, ZTEMPERATURE, ZELAPSED_TIME, time(ZRECEIVED_DT) from ZRRIPEAK where ZMEASURE_ID = '201401290909061'
```

- 心拍周期　加速度移動平均の場合

```
> select ZMEASURE_ID, ZRRI, ZACCELERATION_X, ZACCELERATION_Y, ZACCELERATION_Z, ZTEMPERATURE, ZELAPSED_TIME, time(ZRECEIVED_DT) from ZRRIAVERAGE where ZMEASURE_ID = '201401290909061'
```
