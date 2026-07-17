# レビュー担当

Ruby・Sinatra・Rack に詳しい技術者

# 対象

- 第2章「Sinatra をはじめる」
- `app.rb`
- `Gemfile` と `Gemfile.lock`
- 図 2-1

# 総評

Ruby 4.0.6、Sinatra 4.2.1、Puma 8.0.2、Rack 3.2.6、rackup 2.3.1 の固定環境で、掲載コードと実際の応答は一致しています。Classic Style、ルートの戻り値、`redirect`、`bundle exec` の説明も、現在の Sinatra と Bundler の挙動に沿っています。`GET /` が 302 と `Location` を返し、その後の `GET /movies` が 200 を返すことも再現できます。

主な問題は図 2-1 です。Rack を Puma と Sinatra の間にある独立した箱として描いているため、本文で否定している「Rack という別プロセスを順番に通過する」という理解を視覚的に強めます。

# 良い点

- `require "sinatra"` とトップレベルのルート定義を Classic Style と明示している。
- ルートは HTTP メソッドとパスの組み合わせで選ばれると正確に説明している。
- ルートブロックの最後に評価された文字列がレスポンス本文に使われる説明は、Sinatra 4.2.1 の挙動と一致する。
- `redirect "/movies"` をルート呼び出しではなく、レスポンスと新しいリクエストに分けている。
- `Gemfile.lock` を手で編集せずコミットするというアプリケーション開発の方針が妥当である。
- 未使用の `enable :method_override` や `config.ru` を先に追加していない。

# 改善が必要な点

## must

### Rack を独立した実行コンポーネントに見せる図を修正する

- 対象: `manuscript/assets/fig-2-1.svg`、`manuscript/part1/chapter2.md:113`
- 問題: 図は「ブラウザ → Puma → Rack → Sinatra」という同種の四つの箱を矢印でつないでいます。
- 理由: Rack はこの構成で別サーバーや別プロセスとして起動するものではなく、Puma と Rack アプリケーションである Sinatra が従うインターフェースです。本文の注記だけでは、図から受ける誤解を打ち消しきれません。
- 修正案: ブラウザ、Puma、Sinatra を実行主体の箱として描き、Puma と Sinatra の境界または受け渡し部分へ「Rack の共通インターフェース」とラベルを置く。Rack の見た目を他の実行主体と明確に分ける。

## should

### rackup Gem の役割を現在の構成に合わせて言い換える

- 対象: `manuscript/part1/chapter2.md:79`
- 問題: 「Rack の起動機能」という表現では、何を起動するのかと Rack 本体との違いが曖昧です。
- 理由: Sinatra 4.2.1 は `Rackup::Handler` を通して Puma を選び、Classic アプリを起動します。rackup は Rack 3 から分離されたサーバーハンドラーなどを提供します。
- 修正案: 本書の起動方法では、Sinatra が Puma を選んで起動するために使うサーバーハンドラーを rackup が提供する、と本章の範囲で説明する。

### Bundler 4.0.16 の扱いを明確にする

- 対象: `manuscript/part1/chapter2.md:93`
- 問題: `Gemfile.lock` の `BUNDLED WITH` を示すだけで、読者が別バージョンだった場合の扱いがありません。
- 理由: Bundler の版が違うことと、アプリ用 Gem の版がロックされることは別の論点です。完全一致を求めるなら用意する手順が必要です。
- 修正案: 本書は Bundler 4.0.16 で検証する方針を明記し、`gem install bundler -v 4.0.16` と `bundle _4.0.16_ install` のどちらを採用するか、既存の環境方針に合わせて一つ示す。

## could

### レスポンスの Content-Type を観察対象にする時期を記録する

- 対象: `manuscript/part1/chapter2.md:157`
- 改善案: この章では文字列だけを返すため、`Content-Type` は次章で HTML 文書を返すときに確認すると短く予告する。
- 期待される効果: 「HTML 要素がない文字列」と `text/html` の関係を本章で広げず、次章の観察項目として回収できます。

# 疑問点

- `bundle install` の実行前に Bundler 4.0.16 を必須とするか、互換する Bundler 4 系を許容するかをプロジェクト方針として確定する必要があります。

# 判定

図の技術的な誤解を解消してから次へ進める。
