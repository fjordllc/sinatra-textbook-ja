# 第3章 章設計

## 基本情報

- 章タイトル: HTML をレスポンスとして返す
- 対応する OUTLINE: `OUTLINE.md` 第3章
- 状態: 完了

## この章の主張

Web アプリケーションの画面は、サーバーが組み立てた HTML レスポンスです。Sinatra のルートから `erb :index` を返すと、`views/index.erb` と `views/layout.erb` を使って HTML が生成され、ブラウザはその HTML を解釈して画面を表示します。

## 学習ゴール

Ruby の配列とハッシュを ERB で HTML に埋め込み、レイアウトを使った映画一覧を表示できる。

## 読者が持ち帰る一文

`app.rb` はレスポンスに使うデータを用意し、`views/*.erb` はそのデータを HTML として組み立て、`layout.erb` は全画面に共通する HTML の外枠を担当する。

## 必要な前提知識

- 第2章を読み、`bundle exec ruby app.rb` で Sinatra アプリを起動できる。
- `GET /` が `/movies` へリダイレクトし、`GET /movies` がルートに一致することを説明できる。
- Ruby の配列、ハッシュ、繰り返し、インスタンス変数の基本を理解している。
- HTML の `html`、`head`、`body`、見出し、リスト、リンク、表の基本を理解している。
- CSS ファイルを HTML から読み込む基本を理解している。
- Chrome DevTools の Network パネルでレスポンス本文と Response Headers を確認できる。

## 前章から受け取るもの

- `app.rb` に `GET /` と `GET /movies` のルートがある。
- `GET /` は `/movies` へリダイレクトする。
- `GET /movies` は文字列 `"映画図鑑"` を返す。
- ルートブロックの戻り値がレスポンス本文になる、という理解がある。

## 次章へ渡すもの

- `views/` と `layout.erb` を使って HTML レスポンスを作る構成
- 映画図鑑の一覧画面として、タイトル、公開年、ジャンルだけを表示する設計
- 映画データは `id`、`title`、`director`、`year`、`genre`、`description` を最初から持つという前提
- `public/` は CSS などブラウザへ直接公開する静的ファイルの置き場所であり、保存データを置かないという理解
- 第4章で登録フォームへのリンクを追加し、ブラウザから値を送る必要性

## サンプルアプリへ加える変更

第2章の `GET /movies` は文字列を直接返していました。この章では、映画の配列を `app.rb` に用意し、ERB テンプレートで HTML として表示します。

章終了時点の構成は次の状態です。

```text
.
├── app.rb
├── public/
│   └── stylesheets/
│       └── application.css
└── views/
    ├── index.erb
    └── layout.erb
```

章終了時点の `GET /movies` は、次の役割を持ちます。

- `@movies` に映画の配列を代入する。
- `erb :index` で `views/index.erb` を描画する。
- `views/layout.erb` を通して HTML 文書全体を返す。
- 一覧にはタイトル、公開年、ジャンルだけを表示する。

この章では、映画データはまだファイルへ保存しません。`app.rb` 内の配列として用意します。第5章で `data/movies.json` へ移します。

## 映画データの扱い

映画は最初から次の 6 属性を持ちます。

- `id`
- `title`
- `director`
- `year`
- `genre`
- `description`

ただし、この章の一覧画面には `title`、`year`、`genre` だけを表示します。`director` と `description` は後の詳細画面で使います。章ごとに属性を増やす構成にはしません。

初期データは架空の映画を使います。映画ポスター、外部 API、長いあらすじ、レビュー記事は扱いません。

## 節ごとの展開

### 3.1 文字列ではなく HTML を返す

第2章の `"映画図鑑"` はレスポンス本文でしたが、HTML 要素を含まない単なる文字列でした。この節では、ブラウザに表示される画面もレスポンス本文の HTML から作られることを確認します。まず `get "/movies"` で HTML 文字列を直接返す小さな例を示し、長い HTML を Ruby 文字列に埋め込む読みにくさへつなげます。

### 3.2 `views/` と ERB テンプレート

HTML を Ruby 文字列から分離し、`views/index.erb` へ移します。`erb :index` が `views/index.erb` を使うことを説明します。ERB は HTML の中へ Ruby の処理を埋め込むテンプレートであり、`<% %>` と `<%= %>` の最小限の違いだけを扱います。

### 3.3 `layout.erb` が共通の HTML 構造を持つ理由

`views/layout.erb` を作り、`html`、`head`、`body`、共通ヘッダー、`<%= yield %>` を置きます。個別ビューには画面固有の内容だけを書くことで、各 ERB に `html` や `body` を重複させない理由を説明します。

### 3.4 映画一覧の静的な HTML

まずは `views/index.erb` に静的な映画一覧を書きます。一覧画面にはタイトル、公開年、ジャンルを表示し、詳細に使う監督と紹介文はまだ表示しません。詳細画面を作る理由を残すため、一覧にすべての属性を出さない設計だと説明します。

### 3.5 Ruby の配列とハッシュから映画を表示する

`app.rb` に架空の映画配列を用意し、`@movies` としてテンプレートへ渡します。`views/index.erb` で `@movies.each` を使い、同じ HTML 構造を映画の件数分だけ出力します。ここで初めて、サーバー側の Ruby データから HTML が組み立てられる流れを確認します。

### 3.6 映画は最初から 6 つの属性を持つ

画面上で利用者が入力する項目として、タイトル、監督、公開年、ジャンル、紹介文を紹介します。コード上は `id` も持ちますが、利用者が入力する項目ではありません。章タイトルの学習ゴールに合わせ、属性の意味を短く確認するだけに留めます。

### 3.7 `public/` に置くものと置かないもの

CSS を `public/stylesheets/application.css` に置き、`/stylesheets/application.css` として読み込むことを説明します。`public` というディレクトリ名は URL に含めないこと、`public/` はブラウザから直接参照できるファイルの置き場所であることを確認します。保存用 JSON を `public/` に置かない理由への前振りにします。

### 3.8 最小限の CSS

映画一覧、ナビゲーション、本文、リンクの見分けが付く程度の CSS を追加します。デザイン学習には広げず、画面の役割を読み取りやすくするための CSS として扱います。紹介文の改行表示や `white-space` は、第6章以降で紹介文を表示する必要が出たときに扱います。

### 3.9 Network パネルで HTML と CSS のレスポンスを見る

`GET /movies` が `200 OK` と HTML を返すこと、`Content-Type` が HTML であること、CSS ファイルへ別の `GET` が発生することを確認します。第2章の文字列レスポンスとの違いを、画面だけでなく Network パネルで観察します。

### 3.10 この章のコードを確認する

章終了時点の `app.rb`、`views/layout.erb`、`views/index.erb`、`public/stylesheets/application.css` を確認します。次章では表示だけでなく、映画を登録するフォームを作り、ブラウザから値を送ることを予告します。

## 本文中へ組み込む確認

- 3.1: HTML 文字列を直接返し、Network パネルの Response で HTML がレスポンス本文として届いていることを確認する。
- 3.2: `views/index.erb` へ移しても、ブラウザに表示される内容が同じであることを確認する。
- 3.3: `layout.erb` の `<%= yield %>` の位置に `index.erb` の内容が入ることを確認する。
- 3.5: 映画の配列へ 1 件追加すると、ERB の繰り返しによって一覧の行が増えることを確認する。
- 3.7: `/stylesheets/application.css` を直接開き、`public` を URL に含めないことを確認する。
- 3.9: Network パネルで `GET /movies` と `GET /stylesheets/application.css` が別のリクエストであることを確認する。
- 章末: `app.rb`、`views/index.erb`、`views/layout.erb` のそれぞれの責務を一文で説明する。

## 図・表

### 表 `app.rb`、ERB、ブラウザの関係

- `app.rb`: リクエストに合うルートを実行し、表示に使う Ruby のデータを用意する。
- `views/index.erb`: その画面固有の HTML を組み立てる。
- `views/layout.erb`: HTML 文書全体の共通構造を持つ。
- ブラウザ: 返ってきた HTML と CSS を解釈して画面を表示する。

### 表 映画の属性

- `id`: 映画を一意に識別する値。利用者は入力しない。
- `title`: タイトル。一覧に表示する。
- `director`: 監督。詳細画面で表示する。
- `year`: 公開年。一覧に表示する。
- `genre`: ジャンル。一覧に表示する。
- `description`: 紹介文。詳細画面で表示する。

図版は追加しません。第3章ではファイル構成と表で十分に説明できます。HTML と ERB の関係がレビューで分かりにくいと判断された場合は、後から小さな模式図を追加します。

## この章では扱わないこと

- 登録フォーム、`POST`、`params`
- JSON ファイルへの保存
- `SecureRandom.uuid`
- タイトル必須の入力チェック
- 詳細画面 `/movies/:id`
- `h` ヘルパーと HTML エスケープ
- XSS の脆弱例と対策
- method override、`PATCH`、`DELETE`
- PRG パターン
- 404 ページ
- CSS の詳細な設計
- JavaScript
- ERB 以外のテンプレートエンジン
- Sinatra のレイアウトオプションの網羅

## 先回りして防ぐ誤解

- `erb :index` は `index.html` という静的ファイルをそのまま返す。
- `views/index.erb` に `html`、`head`、`body` を毎回書く必要がある。
- `layout.erb` は見た目だけのファイルで、HTML 文書構造とは関係ない。
- `<% %>` と `<%= %>` はどちらも画面に出力する。
- 一覧画面には持っている属性をすべて表示するべきである。
- `public/stylesheets/application.css` は `/public/stylesheets/application.css` でアクセスする。
- `public/` はアプリが保存するデータを置く安全な場所である。
- CSS ファイルは HTML に埋め込まれて一つのレスポンスとして返る。

## 技術確認に使う資料

- Sinatra 公式「Views / Templates」「Static Files」: <https://sinatrarb.com/intro.html>
- Sinatra 公式「Configuring Settings」: <https://sinatrarb.com/configuration.html>
- Ruby 公式 ERB ドキュメント: <https://docs.ruby-lang.org/en/4.0/ERB.html>
- MDN `Content-Type`: <https://developer.mozilla.org/ja/docs/Web/HTTP/Headers/Content-Type>
- MDN CSS の基本: <https://developer.mozilla.org/ja/docs/Learn/CSS/First_steps>

## 執筆開始条件

- [x] `erb :index` が `views/index.erb` を描画することを Sinatra 公式資料で確認した。
- [x] `views/layout.erb` が既定のレイアウトとして使われることを Sinatra 公式資料で確認した。
- [x] `public/` 配下の静的ファイルが URL では `public` を含まず配信されることを Sinatra 公式資料で確認した。
- [x] 第3章終了時点の `app.rb`、ERB、CSS を実装し、起動して HTTP 応答を確認する。
- [x] mdBook のビルドとリンク検査を実行する。
