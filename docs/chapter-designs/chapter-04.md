# 第4章 章設計

## 基本情報

- 章タイトル: フォームはリクエストを作る
- 対応する OUTLINE: `OUTLINE.md` 第4章
- 状態: 完了

## この章の主張

HTML フォームは入力欄の集まりではなく、ブラウザに HTTP リクエストを作らせるための HTML です。`form` の `action` と `method` が送信先と HTTP メソッドを決め、各フォーム部品の `name` が Sinatra の `params` のキーになります。

## 学習ゴール

映画登録フォームを作り、フォームの HTML から送信先、HTTP メソッド、送信されるキーと値を説明できる。

## 読者が持ち帰る一文

フォームの `action`、`method`、各部品の `name` を読めば、ブラウザがどのリクエストを作り、Sinatra の `params` にどのキーと値が届くかを説明できる。

## 必要な前提知識

- 第3章を読み、`views/`、`layout.erb`、`index.erb` の役割を説明できる。
- HTML の `form`、`label`、`input`、`select`、`textarea`、`button` の基本を学習済みである。
- Ruby のハッシュと `inspect` の基本的な意味を理解している。
- Chrome DevTools の Network パネルで、Headers、Payload または Form Data、Response を確認できる。

## 前章から受け取るもの

- `GET /movies` で映画一覧を HTML として表示できる。
- `views/layout.erb` が共通の HTML 構造を持っている。
- `public/stylesheets/application.css` で最小限の CSS を読み込んでいる。
- 映画データは `id`、`title`、`director`、`year`、`genre`、`description` を持つ。

## 次章へ渡すもの

- `GET /movies/new` で登録フォームを表示する構成
- `POST /movies` でフォーム送信値を受け取る構成
- `params` に `title`、`director`、`year`、`genre`、`description` が入るという理解
- HTML フォームが直接送信できる HTTP メソッドは `GET` と `POST` であるという理解
- 第5章でフォーム送信値を保存し、タイトル必須チェックとリダイレクトへ進むための前提

## サンプルアプリへ加える変更

第3章の一覧画面に「新しい映画を登録」へのリンクを追加します。`GET /movies/new` で登録フォームを表示し、フォームの送信先を `POST /movies` にします。

章終了時点の構成は次の状態です。

```text
.
├── app.rb
├── public/
│   └── stylesheets/
│       └── application.css
└── views/
    ├── index.erb
    ├── layout.erb
    └── new.erb
```

章終了時点のルートは次の状態です。

- `GET /`: `/movies` へのリダイレクト
- `GET /movies`: 映画一覧
- `GET /movies/new`: 映画登録フォーム
- `POST /movies`: 送信された `params` を確認するための一時的なレスポンス

`POST /movies` はまだ映画を保存しません。送信値を観察するために `content_type :text` を指定し、`params.inspect` を返します。HTML として表示しないことで、第6章以降のエスケープ導入前に利用者入力を HTML として解釈させる状態を避けます。

## フォーム項目

登録フォームには次の入力項目を置きます。

- タイトル: `input type="text"`、`name="title"`
- 監督: `input type="text"`、`name="director"`
- 公開年: `input type="text"`、`name="year"`
- ジャンル: `select`、`name="genre"`
- 紹介文: `textarea`、`name="description"`

ジャンルの選択肢は、画面表示と送信値を同じ日本語にします。

- アクション
- コメディ
- ドラマ
- ホラー
- SF
- アニメーション
- その他

この章では、タイトル必須のサーバー側入力チェックは扱いません。`required` 属性もまだ使わず、空欄を送ると `params` にどう届くかを観察できるようにします。入力チェックは第5章で扱います。

## 節ごとの展開

### 4.1 登録画面 `GET /movies/new`

一覧画面に新規登録画面へのリンクを追加し、`GET /movies/new` のルートと `views/new.erb` を作ります。リンクで移動する `GET` と、後でフォームから送る `POST` を分けて説明します。

### 4.2 `form` の `action` と `method`

最小のフォームを使い、`action="/movies"` が送信先、`method="post"` が HTTP メソッドを決めることを説明します。`method` は HTML 上では小文字で書き、HTTP メソッドとしては `POST` と大文字で表記します。

### 4.3 `name` が `params` のキーになる

`input name="title"` の値が `params["title"]` として届くことを説明します。`id` は `label` と入力欄を結び付けるために使い、`name` は送信されるキーを決めるために使う、という違いを扱います。

### 4.4 映画の登録フォーム

タイトル、監督、公開年、ジャンル、紹介文を持つフォームを作ります。`select` と `option`、`textarea` の最小限の使い方を扱います。フォーム部品には対応する `label` を置きます。

### 4.5 `POST /movies` で送信値を確認する

`post "/movies"` を追加し、`content_type :text` と `params.inspect` で送信値を確認します。ここでは保存、リダイレクト、入力チェックは行いません。フォーム送信後にテキストでパラメーターが表示されるだけの一時的な確認用レスポンスであることを明記します。

### 4.6 Network パネルで Form Data を見る

フォームに値を入れて送信し、Network パネルで `POST /movies`、Status Code、Request Headers、Form Data、Response を確認します。フォームの `name` と `params` のキー、送信した値が対応することを観察します。

### 4.7 HTML フォームが直接送れるメソッドは GET と POST

HTML の `form` の `method` 属性で使う値として、この章では `get` と `post` を扱います。更新・削除で使う `PATCH` と `DELETE` は HTML フォームから直接送れないため、第7章で method override を使うと予告します。`dialog` は `<dialog>` 要素内の特殊な用途であり、本書の HTTP リクエスト送信としては扱いません。

### 4.8 この章のコードを確認する

章終了時点の `app.rb`、`views/index.erb`、`views/new.erb`、CSS の変更箇所を確認します。次章では、`params.inspect` で見ていた値を映画データとして保存することを予告します。

## 本文中へ組み込む確認

- 4.1: 一覧のリンクから `GET /movies/new` へ移動し、Network パネルで `GET` を確認する。
- 4.2: フォームの `action` と `method` を見て、送信先と HTTP メソッドを予想する。
- 4.3: `name="title"` を一時的に変えると `params` のキーが変わることを小さく確認する。ただし最終コードは `title` に戻す。
- 4.5: `params.inspect` のレスポンスで、入力した値が Sinatra に届いたことを確認する。
- 4.6: Network パネルの Form Data と `params.inspect` を照合する。
- 4.7: `method="patch"` や `method="delete"` はこの章では使わず、第7章の method override へ送る理由を言語化する。

## 図・表

### 表 フォーム HTML と HTTP リクエストの対応

- `form action="/movies"`: リクエストの送信先
- `form method="post"`: HTTP メソッド
- `input name="title"`: 送信されるキー
- 入力欄に入力した値: 送信される値
- Sinatra の `params["title"]`: サーバー側で受け取る値

### 表 映画フォームの項目

- タイトル: `title`
- 監督: `director`
- 公開年: `year`
- ジャンル: `genre`
- 紹介文: `description`

図版は追加しません。フォーム HTML と Network パネルの対応は表と本文中の観察で扱います。レビューで関係が分かりにくいと判断された場合は、後から小さな模式図を追加します。

## この章では扱わないこと

- JSON ファイルへの保存
- `SecureRandom.uuid`
- タイトル必須の入力チェック
- エラーメッセージと入力済みの値の保持
- 登録後のリダイレクト
- PRG パターン
- 詳細画面 `/movies/:id`
- `h` ヘルパーと HTML エスケープ
- XSS の脆弱例と対策
- method override、`PATCH`、`DELETE`
- ファイルアップロード
- JavaScript
- 複雑なフォームバリデーション

## 先回りして防ぐ誤解

- フォームは画面上の入力欄であり、HTTP リクエストとは関係ない。
- `action` は送信後に表示したい画面名を指定する属性である。
- `method="post"` と書けば、送信値は URL に必ず見えなくなるので安全である。
- `id` 属性が Sinatra の `params` のキーになる。
- `label` の文字列が Sinatra の `params` のキーになる。
- `select` の表示文字列と送信値は常に別である。
- `textarea` の初期値を `value` 属性に書く。
- `params.inspect` で表示されたので、映画データとして保存された。
- HTML フォームから `PATCH` や `DELETE` を直接送れる。

## 技術確認に使う資料

- MDN `<form>`: <https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/form>
- MDN Sending form data: <https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Sending_and_retrieving_form_data>
- MDN Forms and buttons in HTML: <https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Structuring_content/HTML_forms>
- MDN `POST`: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Methods/POST>
- Sinatra 公式「Accessing Variables in Templates」「Routes」: <https://sinatrarb.com/intro.html>

## 執筆開始条件

- [x] HTML フォームの `action` と `method`、`name` と送信値の関係を MDN で確認した。
- [x] HTML フォームの `method` に許可される主な HTTP 送信値が `get` と `post` であることを MDN で確認した。
- [x] `POST` のフォーム送信が `application/x-www-form-urlencoded` を既定で使うことを MDN で確認した。
- [x] 第4章終了時点の `app.rb`、ERB、CSS を実装し、起動して HTTP 応答と `params` を確認する。
- [x] mdBook のビルドとリンク検査を実行する。
