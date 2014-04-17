# Packer

## ブログ記事インポート・エクスポート Plug-in for MovableType

* Author:: Yuichi Takeuchi <uzuki05@takeyu-web.com>
* Website:: [http://takeyu-web.com/](http://takeyu-web.com/)
* Copyright:: Copyright 2014 Yuichi Takeuchi
* License:: MIT-License

バックアップや記事移動に便利な、ブログ記事/ウェブページ単位のインポート・エクスポート機能を提供します。

バージョン1.0未満はEntryExporterという名称でしたが、名前かぶりが激しいので「Packer」に改称しました。

![ブログ記事インポート・エクスポート](https://f.cloud.github.com/assets/60980/235657/110d9b28-87b7-11e2-8be9-211f47798c43.png)

エクスポートされた記事は、カテゴリ（ブログ記事）、フォルダ（ウェブページ）、記事アイテムも同時に書き出され、インポート先にて復元されます。

## 機能

+ ブログ記事/ウェブページ一覧からのエクスポート・Zipアーカイブダウンロード
+ 記事･･･出力ファイル名と記事作成時刻をもとに同一記事かを判定、インポート
  + 繰り返しインポートしても重複登録されない
  + インポート先に同一記事が存在し、そちらの更新時刻が新しい場合ログに記録しスキップ
  + カスタムフィールドのインポート／エクスポートに対応
+ カテゴリ･･･階層構造、メインカテゴリの選択を維持（移転先に存在しない場合は、階層構造を維持して復元）
+ 記事アイテム･･･ブログ記事に関連付けられたアイテムをエクスポートし、インポート先のブログ記事アイテムとして自動登録します。
  + アイテムに子アイテムが存在する場合は、子アイテムもエクスポート（記事中に埋め込まれたサムネイルなど）
  + 本文、追記中に含まれるアイテムURLの自動書き換え
  + 記事アイテム（アイテム、オーディオ、ビデオ、画像）型カスタムフィールドに対応
+ ブラウザインポート
+ コマンドラインインポート


## 動作（するかもしれない）環境

+ MovableType 5.1 5.2 6.0
+ 以下のPerlモジュールが必要
  + Archive::Zip

YAML::Tiny でエラーが発生する場合は YAML::Syck をお試しください。


## 使い方

※ウェブページの場合は、「ブログ記事」を読み替えてください。

### インストール

1. `plugins/Packer`を`MT_DIR/plugins`ディレクトリにアップロード
2. `tools/import-entries`を`MT_DIR/tools`ディレクトリにアップロード（※コマンドラインインポートを使用する場合のみでOK）

アップロード後、システムのプラグイン一覧に「Packer」が追加されているか確認。

### エクスポート

エクスポートしたいブログ記事を一覧から選んで、プラグインアクション「ブログ記事のエクスポート」。
エクスポート完了後、自動的にZipアーカイブのダウンロードが開始されます。（件数や画像の枚数などによっては時間がかかります）

### インポート

ブラウザからと、コマンドラインからのインポートに対応しています。

+ ブラウザから ･･･ 手軽、だがサーバーやブラウザの設定等の影響でタイムアウトしたりと厄介な問題も発生しがち
+ コマンドラインから ･･･ 大きなファイルのインポートはこちらの方が確実

#### ブラウザからインポートする

インポートしたいブログの記事一覧リストの上に表示される「ブログ記事のインポート」から、インポートしたいZipアーカイブをアップロード。

#### コマンドラインインポート

対象が多く、ブラウザからのインポートではタイムアウトなどの問題がある場合、コマンドラインでのインポートが便利です。

    perl tools/import-entries --user_id=1 --blog_id=2 path-th-archive/entries-YYYYMMDDHHMMSS.zip


## うまくいかないとき

### アップロードが途中で止まる

#### タイムアウトする

少しずつエクスポートするか、WebサーバーのCGIタイムアウト値を一時的に大きくしてください。

+ WebサーバーのCGIタイムアウト値を一時的に大きくする
+ ブラウザの設定を変更してHTTPコネクションのタイムアウトを長くする

またはコマンドラインでのインポートスクリプトをお試しください。

#### アップロードサイズ制限にひっかかる

nginxの場合 client_max_body_size を確認して下さい。


### 「ブログ記事間の関連を追加する」ようなプラグインの、関連が維持されない

本エクスポート機能では、他のプラグインで追加された「関連」は対応できません。
（PowerCMSのオブジェクトを関連付けるカスタムフィールドとか）

対応予定はありません。

## 仕様

+ オブジェクト間の関連を実装するサードパーティ製プラグインによるカスタムフィールドに対応できない

## 未実装（実装したいが永遠に未実装の可能性あり）

+ 記事のコメント
+ カテゴリ、アイテム等、記事以外に設定したカスタムフィールド
+ カスタムフィールドのフィールド定義のコピー（現在コピー先で同じベースネームのカスタムフィールドが設定されている必要がある）

その他、私が欲しくなった機能

## 既知の不具合

+ ~~MT6において、ウェブサイトに所属するブログ記事についてはエクスポートできません。（MT5の名残）~~
  対応しました。（Packer v1.0～）
+ 記事作成日時とベースネームを同一判定基準にしているので、同じベースネームと作成日時の重複があると上書きされてしまうかも

## ご注意

* このプラグインはどなたでも無料で利用できますが、無保証です。このプラグインを使用したことでいかなる損害が発生しても、制作者（竹内雄一）は一切責任を負いません。


## Contributing to Packer

Fork, fix, then send me a pull request.


## Copyright

© 2014 Yuichi Takeuchi, released under the MIT license
