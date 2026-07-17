# 再レビュー

# 対象

第3章「HTML をレスポンスとして返す」

- 原稿: `manuscript/part2/chapter3.md`
- コード: `app.rb`, `views/layout.erb`, `views/index.erb`, `public/stylesheets/application.css`
- 章設計: `docs/chapter-designs/chapter-03.md`

# 総評

初回レビューで指摘された重大な問題は解決している。章末に `app.rb`、`views/layout.erb`、`views/index.erb`、`public/stylesheets/application.css` の完成コードが追加され、初学者が章終了時点の状態を照合できるようになった。

`<%= %>` とエスケープの関係も、第3章の固定データと後章の利用者入力を明確に分ける説明が入り、`h` ヘルパーを先取りせずに安全性の前提を渡せている。

# 初回レビューへの対応確認

## must

### 章末の完成状態が不足している

- 状態: 解決
- 確認内容: 3.10 に `app.rb`、`views/layout.erb`、`views/index.erb`、`public/stylesheets/application.css` の完成コードが掲載されている。実ファイルと本文の主要構造も一致している。

### `<%= %>` とエスケープの関係が曖昧

- 状態: 解決
- 確認内容: 3.5 に、現在の映画データは教材内の固定データであり、利用者入力を表示するときはエスケープが必要で第6章で扱う、という説明が追加されている。

## should

### 第3章の開始位置を明示する

- 状態: 対応
- 判断の妥当性: 章冒頭に `git switch -c chapter-03-work chapter-02` が追加され、途中から始める読者の開始状態が明確になった。

### 3.6 の見出しを整理する

- 状態: 対応
- 判断の妥当性: 「映画は最初から 6 つの属性を持つ」へ変更され、`id` を含む属性と利用者入力 5 項目の違いが明確になった。

### `静的ファイル` の意味を補足する

- 状態: 対応
- 判断の妥当性: 3.7 に、Sinatra のルートで組み立てずそのまま配信するファイルだという説明が入った。

### `movies` の配置を補足する

- 状態: 対応
- 判断の妥当性: 3.5 に、`require "sinatra"` の下、ルート定義より前に置くと明記された。

### `Content-Type` の観察結果を具体化する

- 状態: 対応
- 判断の妥当性: 3.9 に `text/html` と `text/css` を含む値を確認する説明が追加され、実測結果とも一致している。

### 狭幅表示で表が崩れにくい CSS にする

- 状態: 対応
- 判断の妥当性: `.table-scroll` と `min-width` が追加され、CSS の説明範囲を広げすぎずに表の横はみ出しに対応している。

### `link` 要素と CSS の GET をつなげる

- 状態: 対応
- 判断の妥当性: 3.7 でブラウザが `href` を見て CSS 取得リクエストを送ると説明され、3.9 の Network 観察とつながった。

# 修正による新しい問題

- 未解決の重大問題はない。
- 第3章では `h` ヘルパーを導入していないが、これは章設計と既定方針どおりであり、第6章へ渡す前提として明記されている。
- Browser skill 用の Node 実行ツールがこのセッションに公開されていなかったため、実ブラウザによるスクリーンショット確認はできなかった。HTTP 応答、生成 HTML、CSS、mdBook、リンク検査で代替確認した。

# 原稿とコードの一致

確認した内容:

- `ruby -c app.rb`: 成功
- `bundle exec ruby app.rb`: Sinatra 4.2.1、Puma 8.0.2、Ruby 4.0.6 で起動
- `GET /`: `302 Found`、`Location: http://127.0.0.1:4567/movies`
- `GET /movies`: `200 OK`、`Content-Type: text/html;charset=utf-8`
- `GET /stylesheets/application.css`: `200 OK`、`Content-Type: text/css;charset=utf-8`
- 取得した HTML に `/stylesheets/application.css`、`.table-scroll`、`.movie-table`、`月面喫茶` が含まれることを確認
- 取得した CSS に `.table-scroll` と `.movie-table` が含まれることを確認
- `mdbook build`: 成功
- `./scripts/check-links.sh internal`: 成功
- `./scripts/check-links.sh web`: 成功

# 前後章との接続

- 前章からの接続: 第2章の `GET /movies` の文字列レスポンスを、HTML レスポンス、ERB、レイアウト、CSS へ自然に発展させている。
- 次章へ渡す前提: `views/`、`layout.erb`、一覧画面、映画データの属性、`public/` の役割が整い、第4章で登録フォームを追加できる。

# 完了判定

- 未解決の `must`: なし
- 初学者が進行不能となる箇所: なし
- サンプルアプリの動作確認: 済み
- 判定: 完了
