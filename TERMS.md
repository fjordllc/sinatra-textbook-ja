# Sinatra 教科書 用語集

本書固有の用語と表記を定めます。FBC Press 共通の用語は [`../FBC_Press/TERMS.md`](../FBC_Press/TERMS.md) に従います。

| 採用する表記 | 避ける表記 | 方針 |
| --- | --- | --- |
| Web アプリケーション | Webアプリ、ウェブアプリ | 初出後も原則として省略しない |
| Web サーバー | ウェブサーバ、Webサーバ | 長音と和欧間スペースを統一する |
| ブラウザ | Web ブラウザ | 文脈上必要な場合を除き `ブラウザ` とする |
| リクエスト | 要求 | HTTP のリクエストを指す |
| レスポンス | 応答 | HTTP のレスポンスを指す |
| HTTP メソッド | HTTP 動詞、リクエストメソッド | `GET` などの分類名として使う |
| ステータスコード | HTTP ステータス | 初出では番号と理由句を併記する |
| ヘッダー | ヘッダ | HTTP と HTML のどちらでも長音を付ける |
| 本文 | body | HTTP メッセージの body は本文と書き、HTML の `body` 要素とは区別する |
| URL | アドレス | ブラウザでアクセスする場所全体を指す |
| URI | URL | REST を意識したリソースの識別子を論じる場面で使う |
| パス | URL、URI | `/movies` など、ホスト名より後ろの部分を指す |
| ルーティング | ルート | リクエストと処理を対応付ける仕組みを指す |
| ルート | ルーティング | `get "/movies"` など個別の定義を指す場合に限る |
| リソース | データ | REST の文脈で識別・操作の対象を指す |
| パラメーター | パラメータ | 地の文では長音を付ける。コードでは `params` を使う |
| リダイレクト | 転送 | 別の URL へアクセスするようレスポンスで指示する仕組みを指す |
| PRG パターン | Post/Redirect/Get パターン | 初出で英語の展開と目的を説明する |
| method override | メソッドオーバーライド | Sinatra・Rack の設定名と仕組みを指すため英小文字で統一する |
| エスケープ | サニタイズ、無害化 | HTML の文脈に応じた文字参照への変換を指す |
| クロスサイトスクリプティング（XSS） | XSS 攻撃 | 初出で日本語名と略称を併記し、以後は XSS とする |
| 入力チェック | バリデーション | 本書で扱うタイトル必須の確認には平易な表記を使う |
| アクセシビリティ | Accessibility | 一般概念としてはカタカナで書く |
| サイト | Site | 一般名詞としてはカタカナで書く。コードのクラス名 `site-title` などは変更しない |
| クラシックスタイル（Classic Style） | Classic Style | Sinatra の書き方として初出で英語を併記し、以後はカタカナを優先する |
| モジュラースタイル（Modular Style） | Modular Style | クラシックスタイルとの対比で出す場合だけ扱う |
| JSON ファイル | JSONデータ | 保存媒体を指す場合に使う |
| ID | 識別子 | 初出で「データを一意に識別する値」と説明する |
| UUID | UUID v4 | `SecureRandom.uuid` の結果を指し、方式や衝突確率は深掘りしない |
| 映画図鑑 | 映画カタログ、映画管理アプリ | サンプルアプリ名として統一する |
| 映画 | item、record | コードの変数名は `movie` / `movies` とする |
| 紹介文 | 説明、本文、あらすじ | `description` の画面上の名称として統一する |
| 公開年 | 年、制作年 | `year` の画面上の名称として統一する |
| Chrome DevTools | 開発者ツール、デベロッパーツール | 初出で Google Chrome の開発者向け機能と説明する |
| Network タブ | ネットワークタブ | Chrome の画面上の英語表記に合わせる |
| リクエストヘッダー | Request Headers | 一般概念としてはカタカナで書く。Chrome DevTools の画面ラベルを指す場合は `Request Headers` と書いてよい |
| レスポンスヘッダー | Response Headers | 一般概念としてはカタカナで書く。Chrome DevTools の画面ラベルを指す場合は `Response Headers` と書いてよい |
| フォームデータ | Form Data | 一般概念としてはカタカナで書く。Chrome DevTools の画面ラベルを指す場合は `Form Data` と書いてよい |

## 英語表記を残すもの

次のものは、公式名、コード、画面上のラベルとして英語表記を残します。

- Ruby、Sinatra、Rack、Puma、Bundler などの製品名・ライブラリ名
- HTML、CSS、HTTP、JSON、UUID などの技術名・略語
- `GET`、`POST`、`PATCH`、`DELETE` などの HTTP メソッド
- `Content-Type`、`Location` などのヘッダー名
- `Request URL`、`Request Method`、`Status Code`、`Payload`、`Response` など Chrome DevTools の画面ラベル
- ファイル名、ディレクトリ名、コード上のクラス名や変数名

## コード上の名前

| 対象 | 名前 |
| --- | --- |
| 映画の配列 | `movies` |
| 1 件の映画 | `movie` |
| JSON の保存先 | `data/movies.json` |
| タイトル | `title` |
| 監督 | `director` |
| 公開年 | `year` |
| ジャンル | `genre` |
| 紹介文 | `description` |
| HTML エスケープ用ヘルパー | `h` |
