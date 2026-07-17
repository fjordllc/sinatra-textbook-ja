# レビュー統合

# 対象

第3章「HTML をレスポンスとして返す」

- 原稿: `manuscript/part2/chapter3.md`
- コード: `app.rb`, `views/layout.erb`, `views/index.erb`, `public/stylesheets/application.css`
- 章設計: `docs/chapter-designs/chapter-03.md`

## 総評

6 観点のレビューは、章の流れ自体をおおむね妥当と判断している。第2章の文字列レスポンスから、HTML、ERB、`layout.erb`、静的な映画データ、`public/` の CSS へ進む順序は維持する。

修正が必要なのは、章終了時点の照合情報、ERB 出力とエスケープの橋渡し、章開始位置、狭幅表示、Network 観察の具体性である。

## 統合した指摘

### must 1: 章末の完成状態が不足している

- 該当レビュー:
  - `01-fbc-mentor.md`
  - `02-technical-editor.md`
  - `04-frontend.md`
  - `05-beginner.md`
  - `06-fbc-graduate.md`
- 問題: 3.10 で `app.rb` の完成コードしか示していない。
- 影響: 初学者が `layout.erb`、`index.erb`、CSS の最終状態を照合できない。
- 方針: 採用する。
- 対応: 3.10 に章終了時点のファイル構成、`views/layout.erb`、`views/index.erb`、`public/stylesheets/application.css` の完成コードを追加する。

### must 2: `<%= %>` とエスケープの関係が曖昧

- 該当レビュー:
  - `03-ruby-sinatra.md`
  - `06-fbc-graduate.md`
- 問題: `<%= movie["title"] %>` を値の出力として教えているが、利用者入力をそのまま出力してよいかの前提がない。
- 影響: Sinatra の ERB が自動エスケープされる、または `<%= %>` が安全な出力である、という誤解につながる。
- 方針: 採用する。
- 対応: 3.5 に「この章の映画データは教材が用意した固定データなのでそのまま出力している。利用者入力の表示ではエスケープが必要で、第6章で扱う」と明記する。第3章では `h` ヘルパーを先取りしない。

## should

### should 1: 第3章の開始位置を明示する

- 該当レビュー:
  - `01-fbc-mentor.md`
  - `05-beginner.md`
- 方針: 採用する。
- 対応: 章冒頭に、第2章から続けている場合はそのまま進み、途中から始める場合は `chapter-02` タグから `chapter-03-work` ブランチを作る説明を追加する。

### should 2: 3.6 の見出しを整理する

- 該当レビュー:
  - `02-technical-editor.md`
- 方針: 採用する。
- 対応: 3.6 と章設計の見出しを「映画は最初から 6 つの属性を持つ」に変更し、利用者が入力する項目は 5 つだと本文で区別する。

### should 3: `静的ファイル` の意味を補足する

- 該当レビュー:
  - `02-technical-editor.md`
- 方針: 採用する。
- 対応: 3.7 の説明に、ここでいう静的ファイルは Sinatra のルートで組み立てず、そのまま返すファイルであることを補う。

### should 4: `movies` の配置を補足する

- 該当レビュー:
  - `03-ruby-sinatra.md`
  - `05-beginner.md`
- 方針: 採用する。
- 対応: 3.5 で `movies` は起動時に用意する仮データとして、ルート定義より前に置くと説明する。スコープの詳細には踏み込まない。

### should 5: `Content-Type` の観察結果を具体化する

- 該当レビュー:
  - `03-ruby-sinatra.md`
  - `06-fbc-graduate.md`
- 方針: 採用する。
- 対応: 3.9 に `text/html` と `text/css` を含む `Content-Type` を確認する説明を追加する。

### should 6: 狭幅表示で表が崩れにくい CSS にする

- 該当レビュー:
  - `04-frontend.md`
- 方針: 採用する。
- 対応: 表を囲む `.table-scroll` を追加し、狭い画面で横スクロールできるようにする。`index.erb` と CSS、本文の完成コードを更新する。

### should 7: `link` 要素と CSS の GET をつなげる

- 該当レビュー:
  - `04-frontend.md`
- 方針: 採用する。
- 対応: 3.7 の `link` 要素説明の直後に、ブラウザが `href` を見て CSS を取得するための別リクエストを送ることを追加する。

## could

### could 1: 章末の一文確認

- 該当レビュー:
  - `01-fbc-mentor.md`
- 方針: 採用する。
- 対応: 3.10 の末尾に、`app.rb`、`layout.erb`、`index.erb` の責務を自分の言葉で説明する確認を追加する。

### could 2: 3.1 の一時例が最終コードではないことを明記

- 該当レビュー:
  - `02-technical-editor.md`
- 方針: 採用する。
- 対応: 3.1 の HTML 文字列例は一時的な確認であり、最終的には ERB へ移すことを明記する。

### could 3: `erb :index` と文字列引数の違い

- 該当レビュー:
  - `03-ruby-sinatra.md`
- 方針: 不採用。
- 理由: 正確ではあるが、この章の初学者には ERB の引数の種類が増えると主題が散る。公式資料への導線で十分とする。

### could 4: ホバー時のリンク下線

- 該当レビュー:
  - `04-frontend.md`
- 方針: 採用する。
- 対応: `.site-title:hover` に `text-decoration: underline` を追加する。

### could 5: ERB エラー時にターミナルログを見る

- 該当レビュー:
  - `05-beginner.md`
  - `06-fbc-graduate.md`
- 方針: 採用する。
- 対応: 3.5 の後に、ERB の書き間違いで 500 が出たときは起動中のターミナルログも見ると短く補足する。詳しいデバッグは第11章へ送る。

## 対立・保留した指摘

- 第3章で `h` ヘルパーを先取りする案は採用しない。第6章で安全な表示の基準として導入する既定方針を維持する。第3章では固定データであることと、利用者入力ではエスケープが必要になることだけを説明する。
- 図版追加は保留する。レビューでは必須指摘になっておらず、表と完成コードで十分に説明できる。

## 修正対象ファイル

- `manuscript/part2/chapter3.md`
- `docs/chapter-designs/chapter-03.md`
- `views/index.erb`
- `public/stylesheets/application.css`
