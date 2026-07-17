# 再レビュー

# 対象

第4章「フォームはリクエストを作る」

- 原稿: `manuscript/part2/chapter4.md`
- コード: `app.rb`, `views/index.erb`, `views/new.erb`, `public/stylesheets/application.css`
- 章設計: `docs/chapter-designs/chapter-04.md`

# 総評

初回レビューで指摘された重大な問題は解決している。章末に `views/index.erb` と第4章で追加した CSS が追加され、読者が導線、フォーム、見た目の変更を照合できるようになった。

`params.inspect` についても、第4章だけの確認用コードであり、第5章で保存処理とリダイレクトへ置き換えると明記された。フォームが HTTP リクエストを作り、`params` に届くことを学ぶ章として、範囲は保たれている。

# 初回レビューへの対応確認

## must

### 章末の完成状態に `views/index.erb` と CSS が不足している

- 状態: 解決
- 確認内容: 4.8 に `views/index.erb` の完成コードと、第4章で追加した CSS が掲載されている。

### `params.inspect` が第4章だけの確認用であることが章末で弱い

- 状態: 解決
- 確認内容: 4.5 と 4.8 に、第4章だけの確認用コードであり、第5章で保存処理とリダイレクトへ置き換えることが明記されている。

## should

### HTML フォームの `method` 説明を限定する

- 状態: 対応
- 判断の妥当性: 4.7 が「HTTP リクエストとしてサーバーへ送る HTML フォームでは」と限定され、`dialog` への補足と矛盾しない表現になった。

### `params` が文字列キーであることを明確にする

- 状態: 対応
- 判断の妥当性: 4.3 に `params["title"]` のように文字列キーで扱う説明が追加された。

### `content_type :text` を Network 観察と結び付ける

- 状態: 対応
- 判断の妥当性: 4.6 に Response Headers の `Content-Type: text/plain` が確認対象として追加された。

### ボタン風リンクの意味を補足する

- 状態: 対応
- 判断の妥当性: 4.1 に、見た目はボタン風でも HTML としてはリンクであり `GET /movies/new` を送ると説明された。

### `select` の初期選択を補足する

- 状態: 対応
- 判断の妥当性: 4.4 に最初の選択肢「アクション」が初期状態で選ばれていると追加された。

### 空欄送信の例を入れる

- 状態: 対応
- 判断の妥当性: 4.5 に `"title" => ""` の例が追加され、第5章の入力チェックへ自然につながっている。

### Form Data と `params` の順序は重要ではないと補足する

- 状態: 対応
- 判断の妥当性: 4.5 に、表示順ではなくキーと値が届いていることを見ると追記された。

# 修正による新しい問題

- 未解決の重大問題はない。
- 第4章では `required` 属性を使っていないが、空欄送信の観察と第5章のサーバー側入力チェックにつなげるため、章設計どおりである。
- `params.inspect` を本文とコードに残しているが、第4章だけの確認用であることが明記されている。

# 原稿とコードの一致

確認した内容:

- `ruby -c app.rb`: 成功
- `bundle exec ruby app.rb`: Sinatra 4.2.1、Puma 8.0.2、Ruby 4.0.6 で起動
- `GET /movies/new`: `200 OK`、`Content-Type: text/html;charset=utf-8`
- `POST /movies`: `200 OK`、`Content-Type: text/plain;charset=utf-8`
- `POST /movies` のレスポンスに `title`、`director`、`year`、`genre`、`description` のキーと入力値が含まれることを確認
- タイトル空欄送信で `"title" => ""` と表示されることを確認
- 取得したフォーム HTML に `action="/movies"`、`method="post"`、`name="title"`、`name="genre"`、`textarea`、送信ボタンが含まれることを確認
- `mdbook build`: 成功
- `./scripts/check-links.sh internal`: 成功
- `./scripts/check-links.sh web`: 成功

# 前後章との接続

- 前章からの接続: 第3章で作った一覧画面とレイアウトに、登録画面へのリンクと `views/new.erb` を自然に追加している。
- 次章へ渡す前提: `params` に映画フォームの値が届くこと、`POST` だけでは保存されないこと、空文字も届くことが確認でき、第5章の JSON 保存とタイトル必須チェックへ進める。

# 完了判定

- 未解決の `must`: なし
- 初学者が進行不能となる箇所: なし
- サンプルアプリの動作確認: 済み
- 判定: 完了
