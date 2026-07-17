# レビュー統合

# 対象

第4章「フォームはリクエストを作る」

- 原稿: `manuscript/part2/chapter4.md`
- コード: `app.rb`, `views/index.erb`, `views/new.erb`, `public/stylesheets/application.css`
- 章設計: `docs/chapter-designs/chapter-04.md`

## 総評

6 観点のレビューでは、章の主張と説明順は妥当と判断された。`GET /movies/new`、フォーム HTML、`POST /movies`、`params`、Network パネルという流れは維持する。

修正が必要なのは、章末の完成状態、`params.inspect` の位置付け、`params` の文字列キー、Network 観察の具体性、リンクとボタンの意味の区別である。

## 統合した指摘

### must 1: 章末の完成状態に `views/index.erb` と CSS が不足している

- 該当レビュー:
  - `01-fbc-mentor.md`
  - `02-technical-editor.md`
  - `04-frontend.md`
  - `05-beginner.md`
- 問題: 4.8 で `app.rb` と `views/new.erb` だけを掲載しており、一覧リンクとフォーム CSS の最終状態を確認できない。
- 影響: 読者が章終了時点のファイルを照合できない。
- 方針: 採用する。
- 対応: 4.8 に `views/index.erb` の完成コードと、第4章で追加した CSS を掲載する。

### must 2: `params.inspect` が第4章だけの確認用であることが章末で弱い

- 該当レビュー:
  - `03-ruby-sinatra.md`
  - `06-fbc-graduate.md`
- 問題: 章末の完成コードに `params.inspect` が残るため、通常の完成実装と誤解される可能性がある。
- 影響: POST 後に値を表示するだけで完成と誤解される。
- 方針: 採用する。
- 対応: 4.5 と 4.8 に、第4章だけの確認用レスポンスであり、第5章で保存処理とリダイレクトに置き換えることを明記する。

## should

### should 1: HTML フォームの `method` 説明を限定する

- 該当レビュー:
  - `02-technical-editor.md`
- 方針: 採用する。
- 対応: 4.7 を「HTTP リクエストとしてサーバーへ送るフォームでは、`get` または `post` を使う」と修正する。

### should 2: `params` が文字列キーであることを明確にする

- 該当レビュー:
  - `03-ruby-sinatra.md`
  - `05-beginner.md`
- 方針: 採用する。
- 対応: 4.3 に、本書では `params["title"]` のように文字列キーで扱うこと、ハッシュのようにキーで値を取り出せることを追記する。

### should 3: `content_type :text` を Network 観察と結び付ける

- 該当レビュー:
  - `03-ruby-sinatra.md`
- 方針: 採用する。
- 対応: 4.6 の確認項目に Response Headers の `Content-Type: text/plain` を追加する。

### should 4: ボタン風リンクの意味を補足する

- 該当レビュー:
  - `04-frontend.md`
- 方針: 採用する。
- 対応: 4.1 に、見た目はボタン風でも HTML としてはリンクであり、`GET /movies/new` を送ると補足する。

### should 5: `select` の初期選択を補足する

- 該当レビュー:
  - `04-frontend.md`
- 方針: 採用する。
- 対応: 4.4 に、このフォームでは最初の選択肢「アクション」が初期選択になると追記する。

### should 6: 空欄送信の例を入れる

- 該当レビュー:
  - `01-fbc-mentor.md`
  - `05-beginner.md`
- 方針: 採用する。
- 対応: 4.5 に、タイトルを空欄で送ると `"title" => ""` のように空文字として届くことを追記する。

### should 7: Form Data と `params` の順序は重要ではないと補足する

- 該当レビュー:
  - `06-fbc-graduate.md`
- 方針: 採用する。
- 対応: 4.5 に、表示順ではなくキーと値が届いたことを見ると追記する。

## could

### could 1: POST は安全という誤解を潰す

- 該当レビュー:
  - `06-fbc-graduate.md`
- 方針: 採用する。
- 対応: 4.6 に、`POST` の送信内容も Network パネルで確認でき、`POST` にしただけで秘密になるわけではないと短く追記する。

### could 2: 送信後に戻る方法を補足する

- 該当レビュー:
  - `05-beginner.md`
- 方針: 採用する。
- 対応: 4.5 に、確認用レスポンスからはブラウザの戻るボタンでフォームへ戻れると追記する。

## 採用しなかった指摘

### `autocomplete` を扱う

- 出典:
  - `04-frontend.md`
- 理由: この章の主題はフォームから HTTP リクエストを作ることなので、ブラウザの補完属性へ広げない。

## 修正対象ファイル

- `manuscript/part2/chapter4.md`
