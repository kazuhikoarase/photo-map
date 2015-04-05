# PhotoMap作成方法 #



# 1. はじめに #

デジタルカメラは、一度にたくさんの写真を撮ることができます。 また、不要な写真を削除するのも簡単です。

こうした特徴を生かして、撮影した場所を動き回れるリンクマップを作れないだろうか？ と思い、
実際にやってみることにしました。

# 2. 写真を撮る #

町に出て、写真を撮ります。

## 2-1. 直線の道 ##

道を歩きながら、1点につき二枚の写真を撮ります。

長い道では、20歩程度の間隔で撮ると良い感じです。

  1. 前方
  1. 後方

![http://photo-map.googlecode.com/svn/assets/p1.png](http://photo-map.googlecode.com/svn/assets/p1.png)

## 2-2. 交差点 ##

交差点では、4枚の写真を撮ります。

  1. 前方
  1. 後方
  1. 右側
  1. 左側

![http://photo-map.googlecode.com/svn/assets/p2.png](http://photo-map.googlecode.com/svn/assets/p2.png)

交差が複雑な場所などでは、この限りではありません。

# 3. 写真間のリンクを作成する #

## 3-1. リンクの張り方 ##

1枚の写真を、左側(同地点)、前方(次地点)、右側(同地点)とリンクします。
リンクした情報を、画像ファイル名 + '.xml' という名前で保存します。
例えば画像ファイル名が DSCF0001.JPG ならば、 DSCF0001.JPG.xml とします。

XML のフォーマットは次のような形式にします。

**フォーマット**

| **パス**						| **値**						|
|:----------------|:-------------|
| /photomap				| ルート						|
| /photomap/name			| 画像ファイルの url			|
| /photomap/left			| 画像ファイルの相対 url (左側)	|
| /photomap/front			| 画像ファイルの相対 url (前方)	|
| /photomap/right			| 画像ファイルの相対 url (右側)	|
| /photomap/title			| タイトル					|
| /photomap/description	| 説明						|

例 (DSCF0001.JPG.xml)
```
<?xml version="1.0" encoding="UTF-8"?>
<photomap>
  <name>DSCF0001.JPG</name>
  <left>DSCF0004.JPG</left>
  <front>DSCF0005.JPG</front>
  <right>DSCF0002.JPG</right>
  <title>タイトル＊＊＊＊</title>
  <description>説明＊＊＊＊＊＊</description>
</photomap>
```

![http://photo-map.googlecode.com/svn/assets/p3.png](http://photo-map.googlecode.com/svn/assets/p3.png)

## 3-2. PhotoMap(リンク用ツール)を使う ##

理屈は単純ですが、実際に大量の写真のリンクを作るのは大変な作業です。

そこで、[専用のツール](http://code.google.com/p/photo-map/downloads/list)を使用します。

### システム要件 ###

> Java6 以上

### 使用方法 ###

  1. photomap.jar と同じか、その下の階層のフォルダに、撮影した写真を用意します。
  1. photomap.jar をダブルクリックして、PhotoMap を起動します。
  1. フォルダ一覧から写真のあるフォルダを選択します。
  1. メニューから 'File - Resize All Images' を選択して、画像を縮小します。 高さ 2048 ピクセル以上の画像は 元の画像ファイルが書き換えられるので、 あらかじめバックアップを取っておくようにしてください。
  1. 画像一覧からメインエリアに写真をドラッグ＆ドロップするか、ダブルクリックして選択します。
  1. 画像一覧から任意のリンクエリアに写真をドラッグ＆ドロップして、リンクを作成します。
  1. リンクエリアの写真をダブルクリックすると、ダブルクリックした写真に遷移します。 この際、自動的に相互リンクが作成されます。
  1. 全てのリンクを張り終えたら、メニューから 'File - Exit' を選択して、ツールを終了します。

![http://photo-map.googlecode.com/svn/assets/pm.jpg](http://photo-map.googlecode.com/svn/assets/pm.jpg)

# 4. 実際にリンクを動き回る #

リンクが完成したら、あとは見せ方です。

ここでは Flash を使用します。

>> [サンプル](http://photo-map.googlecode.com/svn/assets/photomap/photomap.html)

必要な Flash のリソースは
[リンク用ツール](http://code.google.com/p/photo-map/downloads/list)
に含まれています。

# 5. コツ #

写真の撮れ具合が、できあがったマップの臨場感を左右します。

自分が撮って回った範囲で、気づいた点を挙げます。

  * どの地点でも、必ず時計回りに回りながら撮る。
  * 地点間で空（そら）を撮って、地点間の区切りにする。 これを忘れると地点間の区切りがわからなくなってしまい、 後のリンク作成が困難になります。
  * 撮影する前に、数歩下がる(一般的なカメラの画角は、人間の視野より狭い)。

**概念的な視野**

![http://photo-map.googlecode.com/svn/assets/p4.png](http://photo-map.googlecode.com/svn/assets/p4.png)

**実際の視野**

![http://photo-map.googlecode.com/svn/assets/p5.png](http://photo-map.googlecode.com/svn/assets/p5.png)