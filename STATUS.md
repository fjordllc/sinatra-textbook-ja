# Sinatra 教科書 作業状況

最終更新日: 2026 年 7 月 20 日

## 現在の状態

第1章から第12章の本編、付録Aから付録E、全体の横断レビュー、サンプルアプリの最終検証が完了しました。未解決の `must` はありません。

2026 年 7 月 20 日に構成を変更しました。**サンプルアプリ（映画図鑑）は、本書リポジトリから独立した別リポジトリ `sinatra-movies` へ分離しました。** 本書リポジトリ（`sinatra-textbook-ja`）は原稿・レビュー履歴・テーマ・スクリプトのみを持ち、`app.rb` / `views/` / `data/` / `public/` / `Gemfile` などのアプリ一式は含みません。あわせて、第2章を「本書リポジトリを clone して章タグから始める」方式から「読者が自分で `sinatra-movies` ディレクトリを作り、`git init` して一からファイルを作るハンズオン」方式へ改訂しました（下部の作業ログ 7/20 分を参照）。

この分離・改訂のコミットは本書リポジトリのローカルにあり、公開リポジトリ（`fjordllc/sinatra-textbook-ja`）へはまだ push していません。`sinatra-movies` の GitHub リポジトリも未作成です。

## 確定した方針

- Sinatra の機能を網羅するのではなく、Sinatra を使って Web アプリケーション開発の基礎を学ぶ。
- サンプルアプリは、ログインなし・単一ユーザー・ローカル環境で動く「映画図鑑」とする。
- 映画は最初から `id`、`title`、`director`、`year`、`genre`、`description` を持つ。章の途中で属性を追加しない。
- 映画図鑑は CRUD、JSON 保存、PRG、XSS 対策、404、タイトルの入力チェックまで完成させる。
- 第5章で登録後のリダイレクトを画面遷移として先に利用し、Sinatra 4.2.1 で返る `303 See Other` を観察する。第8章では、これを PRG として意味付けし、再送信防止の設計意図を説明する。
- HTML フォームによる更新・削除では、Network タブに POST と `_method` が現れ、Rack を通過した後の PATCH・DELETE は Sinatra のログで確認する。
- 利用者入力の表示には `Rack::Utils.escape_html` を呼び出す `h` ヘルパーを使う。保存した利用者入力が一覧とフォームへ表示される第5章で導入し、第9章内だけで一時的にエスケープを外して XSS を確認してから安全なコードへ戻す。
- HTTP の本文説明は HTTP/1.1 のメッセージ例に集中する。HTTP/2 以降の内部表現の違いは短い注記に留める。
- 独立した部末演習は設けない。観察、試行、言語化、小さな変更は必要な章や節の流れへ自然に組み込む。
- 各章には、読後に読者が何を説明・実装・判断できるかを表す 1 文の学習ゴールを置く。
- 最終的な起動コマンドは `bundle exec ruby app.rb` に統一する。
- Ruby 4.0.6、Sinatra 4.2.1、Puma 8.0.2、Rack 3.2.6、Bundler 4.0.16 を `Gemfile.lock` で固定する。
- FBC Press シリーズの方針に合わせ、本文とサンプルコードを含むリポジトリ全体を MIT License とする。
- 図版は `scripts/figures/build_all.py` から `manuscript/assets/` へ生成し、手書きの出力 SVG を直接編集しない。
- 一章ずつ、執筆、6 観点の独立レビュー、レビュー統合、修正、再レビュー、完了判定の順で進める。
- レビュー履歴は `reviews/chapter-XX/` に保存し、ほかの初回レビューを参照せず各観点のレビューを作成する。
- `main` は最新の完了章が終わった時点のコードとし、章完了コミットへ `chapter-XX` タグを付ける。（2026-07-20 追記: サンプルアプリを別リポジトリへ分離し、第2章の clone＋章タグ方式を廃止したため、本書リポジトリでのこの運用は取りやめる。既存の `chapter-XX` タグの扱いは検討中。）
- （2026-07-20 追記）サンプルアプリは別リポジトリ `sinatra-movies` で管理する。読者は本書に沿って自分で `sinatra-movies` ディレクトリを作り、ファイルを一から作成するハンズオン方式で進める。
- 一般概念として本文に出す外来語は、原則としてカタカナ表記にする。公式名、コード、HTTP メソッド、ヘッダー名、Chrome DevTools の画面ラベルは英語表記を残す。

## 採用しなかった案と理由

- 部末演習: FBC に別の Sinatra 提出課題があり、役割が重複するため採用しない。
- 属性を章ごとに追加する構成: Web アプリケーションの説明とデータ構造の変更が混ざるため採用しない。
- HTTP/2 と HTTP/3 の独立した節: 初学者にとって本筋から外れるため採用しない。
- PRG の章までリダイレクトを使わない構成: 動くアプリとして不自然になるため採用しない。先に使い、後から名前と理由を説明する。
- XSS の脆弱なコードを複数章にわたって残す構成: 安全でない中間コードが長く残るため採用しない。

## 未解決の課題

- Cloudflare Pages の設定は未作成である。

## 関係するファイル

- `OUTLINE.md`: 全体設計、章設計、映画図鑑の仕様
- `STATUS.md`: 決定事項、未解決事項、作業状況
- `docs/WRITING_AND_REVIEW_WORKFLOW.md`: 章単位の執筆・レビュー工程
- `docs/chapter-designs/chapter-01.md`: 第1章の執筆前設計
- `docs/chapter-designs/chapter-02.md`: 第2章の章設計とレビュー対応状況
- `reviews/README.md`: レビュー履歴の構成と運用
- `reviews/templates/`: 初回レビュー、統合、修正記録、再レビューのテンプレート
- `STYLEGUIDE.md`: 本書固有の執筆・コード・HTTP 表現のルール
- `TERMS.md`: 本書固有の用語とコード上の名前
- `manuscript/`: mdBook で公開する原稿と図版
- `scripts/verify-stack.rb`: 固定技術構成の教材固有機能を確認するスクリプト
- `scripts/figures/build_all.py`: 図版を再生成する集約スクリプト
- `reviews/chapter-01/`: 第1章の 6 観点レビュー、統合、修正記録、再レビュー
- `reviews/chapter-02/`: 第2章の 6 観点レビュー、統合、修正記録、再レビュー
- `docs/chapter-designs/chapter-03.md`: 第3章の章設計とレビュー対応状況
- `reviews/chapter-03/`: 第3章の 6 観点レビュー、統合、修正記録、再レビュー
- `views/layout.erb`: 第3章で追加した共通レイアウト
- `views/index.erb`: 第3章で追加した映画一覧ビュー
- `public/stylesheets/application.css`: 第3章で追加した最小限の CSS
- `docs/chapter-designs/chapter-04.md`: 第4章の章設計とレビュー対応状況
- `reviews/chapter-04/`: 第4章の 6 観点レビュー、統合、修正記録、再レビュー
- `views/new.erb`: 第4章で追加した映画登録フォーム
- `../FBC_Press/STYLE_GUIDE.md`: FBC Press の共通執筆ルール
- `../FBC_Press/REVIEW_CHECKLIST.md`: 共通レビュー基準
- `../FBC_Press/CONTEXT_MANAGEMENT.md`: コンテキスト管理ルール
- `docs/chapter-designs/chapter-05.md`: 第5章の章設計とレビュー対応状況
- `reviews/chapter-05/`: 第5章の 6 観点レビュー、統合、修正記録、再レビュー
- `data/movies.json`: 第5章で追加した映画データ保存用 JSON
- `docs/chapter-designs/chapter-06.md`: 第6章の章設計とレビュー対応状況
- `reviews/chapter-06/`: 第6章の 6 観点レビュー、統合、修正記録、再レビュー
- `views/show.erb`: 第6章で追加した映画詳細ビュー
- `docs/chapter-designs/chapter-07.md`: 第7章の章設計とレビュー対応状況
- `reviews/chapter-07/`: 第7章の 6 観点レビュー、統合、修正記録、再レビュー
- `views/edit.erb`: 第7章で追加した映画編集ビュー
- `docs/chapter-designs/chapter-08.md`: 第8章の章設計とレビュー対応状況
- `reviews/chapter-08/`: 第8章の 6 観点レビュー、統合、修正記録、再レビュー
- `docs/chapter-designs/chapter-09.md`: 第9章の章設計とレビュー対応状況
- `reviews/chapter-09/`: 第9章の 6 観点レビュー、統合、修正記録、再レビュー
- `docs/chapter-designs/chapter-10.md`: 第10章の章設計とレビュー対応状況
- `reviews/chapter-10/`: 第10章の 6 観点レビュー、統合、修正記録、再レビュー
- `views/not_found.erb`: 第10章で追加した 404 ページ
- `docs/chapter-designs/chapter-11.md`: 第11章の章設計とレビュー対応状況
- `reviews/chapter-11/`: 第11章の 6 観点レビュー、統合、修正記録、再レビュー
- `manuscript/part5/chapter11.md`: 第11章の本文
- `docs/chapter-designs/chapter-12.md`: 第12章の章設計とレビュー対応状況
- `reviews/chapter-12/`: 第12章の 6 観点レビュー、統合、修正記録、再レビュー
- `manuscript/part5/chapter12.md`: 第12章の本文
- `manuscript/appendix/`: 付録Aから付録E
- `reviews/cross-review/`: 横断レビュー、修正記録、再確認

## 実行・検証結果

- `OUTLINE.md` に学習ゴールが 12 件あることを確認した。
- `OUTLINE.md` に章設計シートが 12 件あることを確認した。
- `OUTLINE.md` に章ごとの「さらに学ぶ」が 12 件あることを確認した。
- 独立した部末演習、複数の起動コマンド、古い Rack の参考 URL、旧リダイレクト設計が残っていないことを確認した。
- FBC Press の部末演習ルールを任意化し、学習ゴールのレビュー基準を追加した。コミット `61d64a6` を `origin/main` へプッシュ済み。
- 章単位の執筆・レビュー・修正・再レビュー工程を `docs/WRITING_AND_REVIEW_WORKFLOW.md` に記録した。
- 6 観点のレビューを独立して作成してから統合するルールと、レビュー用テンプレートを用意した。
- 第1章の章設計が `OUTLINE.md` の学習ゴール、7 節、前後章の接続、扱わない範囲と一致することを確認した。
- Ruby 4.0.6 をインストールし、Bundler 4.0.16 で依存関係を解決した。
- `Gemfile.lock` に Sinatra 4.2.1、Puma 8.0.2、Rack 3.2.6、rackup 2.3.1 を固定した。
- `bundle exec ruby app.rb` で Puma が起動し、`GET /` が 302、`GET /movies` が 200 と HTML 本文を返すことを確認した。
- `scripts/verify-stack.rb` で PATCH・DELETE の method override、303、ERB、`Rack::Utils.escape_html` を確認した。
- FBC Press の共有テーマ、規定のフッター、書籍固有 CSS、MIT License を導入した。
- `mdbook build` と `scripts/check-links.sh internal` が成功した。`mdbook-linkcheck` はサンドボックス内では macOS の設定取得で停止するが、通常環境では成功した。
- 図 1-1 を集約スクリプトから生成し、`xmllint` と PNG プレビューで確認した。
- 第1章初稿を 6 観点で独立してレビューし、レビュー統合と修正記録を保存した。
- 初回レビューの `must` だった Network 観察条件、初出用語、404 の説明、原稿とコードの不一致を修正した。
- Chrome のデスクトップ表示と 500 px 幅表示を画像で確認し、見出し、本文、表、図、キャプションに重大な崩れがないことを確認した。
- 再レビューで未解決の `must` がなく、第2章へ進めると判定した。
- 第2章の `app.rb` を起動し、`GET /` が 302 と `Location: http://localhost:4567/movies`、`GET /movies` が 200 と「映画図鑑」を返すことを確認した。
- 第2章初稿を 6 観点で独立してレビューし、二つの `must` と改善案を `review-summary.md` に統合した。
- Rack を独立した箱から破線の共通インターフェースへ描き直し、図を狭幅向けの縦配置へ変更した。
- 第2章の mdBook ビルド、内部リンク、Ruby 構文、SVG の XML、デスクトップ・500 px 幅表示を確認した。
- GitHub CLI の認証を更新し、公開リポジトリ `https://github.com/fjordllc/sinatra-textbook-ja` を作成した。第1章完了時点の `main` と `chapter-01` タグをプッシュ済みである。
- 公開 URL を別の一時ディレクトリへ clone し、本文どおり `chapter-01` から `chapter-02-work` ブランチを作成できることを確認した。その開始状態には `app.rb` がなく、3 つの環境ファイルがある。
- 外部リンク検査で第1章の RFC Editor 旧 URL が 404 になることを確認し、200 を返す公式 info ページへ更新した。
- 第2章の再レビューで未解決の `must` がなく、第3章へ進めると判定した。
- 第2章完了時点を `chapter-02` タグとして公開リポジトリへプッシュした。
- 第3章の章設計を作成し、`GET /movies` の文字列レスポンスを ERB、`layout.erb`、静的な映画データ、CSS へ発展させる範囲を確定した。
- 第3章終了時点の `app.rb`、`views/layout.erb`、`views/index.erb`、`public/stylesheets/application.css` を実装した。
- `GET /` が `302 Found` と `Location: http://127.0.0.1:4567/movies`、`GET /movies` が `200 OK` と `Content-Type: text/html;charset=utf-8`、`GET /stylesheets/application.css` が `200 OK` と `Content-Type: text/css;charset=utf-8` を返すことを確認した。
- 取得した HTML に `/stylesheets/application.css`、`.table-scroll`、`.movie-table`、`月面喫茶` が含まれ、取得した CSS に `.table-scroll` と `.movie-table` が含まれることを確認した。
- 第3章初稿を 6 観点で独立してレビューし、二つの `must` と改善案を `review-summary.md` に統合した。
- 章末の完成コード不足を解消し、`app.rb`、`views/layout.erb`、`views/index.erb`、CSS の最終形を本文に追加した。
- `<%= %>` とエスケープの関係について、第3章では固定データを表示し、利用者入力のエスケープは第5章で扱うと明記した。
- 第3章の mdBook ビルド、内部リンク、外部リンク、Ruby 構文を確認した。
- Browser skill 用の Node 実行ツールが公開されていなかったため、実ブラウザのスクリーンショット確認は未実施。HTTP 応答、生成 HTML、CSS、ビルド、リンク検査で代替確認した。
- 第3章の再レビューで未解決の `must` がなく、第4章へ進めると判定した。
- 第3章完了時点を `chapter-03` タグとして公開リポジトリへプッシュした。
- 第4章の章設計を作成し、`GET /movies/new`、映画登録フォーム、`POST /movies`、`params`、Network パネルの Form Data 観察までを範囲として確定した。
- 第4章終了時点の `app.rb`、`views/index.erb`、`views/new.erb`、`public/stylesheets/application.css` を実装した。
- `GET /movies/new` が `200 OK` と `Content-Type: text/html;charset=utf-8` を返し、フォーム HTML に `action="/movies"`、`method="post"`、各 `name`、送信ボタンが含まれることを確認した。
- `POST /movies` が `200 OK` と `Content-Type: text/plain;charset=utf-8` を返し、`params.inspect` に `title`、`director`、`year`、`genre`、`description` のキーと入力値が含まれることを確認した。
- タイトル空欄送信で `"title" => ""` と表示されることを確認した。
- 第4章初稿を 6 観点で独立してレビューし、二つの `must` と改善案を `review-summary.md` に統合した。
- 章末の完成コード不足を解消し、`views/index.erb` と第4章で追加した CSS を本文に追加した。
- `params.inspect` が第4章だけの確認用であり、第5章で保存処理とリダイレクトに置き換えることを本文に明記した。
- 第4章の mdBook ビルド、内部リンク、外部リンク、Ruby 構文を確認した。
- 第4章の再レビューで未解決の `must` がなく、第5章へ進めると判定した。
- `TERMS.md` と `STYLEGUIDE.md` に英語表記とカタカナ表記の使い分けを追加した。アクセシビリティ、サイト、クラシックスタイル、モジュラースタイルなどはカタカナ主表記とし、DevTools の画面ラベルやコードは英語表記を残す方針にした。
- 第5章の章設計を作成し、`data/movies.json`、JSON 読み書き、`SecureRandom.uuid`、タイトル必須チェック、入力値保持、保存後リダイレクト、`h` ヘルパー導入までを範囲として確定した。
- 第5章終了時点の `app.rb`、`data/movies.json`、`views/index.erb`、`views/new.erb`、`public/stylesheets/application.css` を実装した。
- `GET /movies/new` が `200 OK` と登録フォームを返すことを確認した。
- 正常な `POST /movies` が `303 See Other` と `Location: http://127.0.0.1:4567/movies` を返し、`data/movies.json` に UUID 付きの映画が追加されることを確認した。
- タイトル空欄の `POST /movies` が `200 OK` とエラーメッセージ付きフォームを返し、入力済みの監督、公開年、ジャンル、紹介文が保持されることを確認した。
- `<script>alert("xss")</script>` をタイトルとして保存して一覧を取得し、`&lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;` として表示されることを確認した。確認後、`data/movies.json` は初期状態へ戻した。
- 第5章初稿を 6 観点で独立してレビューし、未解決の `must` がないことを確認した。`should` と `could` の一部を `review-summary.md` に統合した。
- `File.join(__dir__, ...)` の意図、壊れた JSON の範囲外明示、`JSON.parse` と `JSON.pretty_generate` の対比、`role="alert"`、第8章への橋渡しを本文へ反映した。
- 第5章の mdBook ビルド、内部リンク、Ruby 構文を確認した。
- 第5章の外部リンク検査を確認した。
- 最終版コードで再度、`GET /movies/new`、正常登録時の `303 See Other`、タイトル空欄時の `role="alert"` 付きフォーム再表示、一覧での HTML エスケープを確認した。確認後、`data/movies.json` は初期状態へ戻した。
- 第5章の再レビューで未解決の `must` がなく、第6章へ進めると判定した。
- 第6章の章設計を作成し、`/movies` と `/movies/:id`、ID 検索、詳細画面、404、登録後の詳細リダイレクトを範囲として確定した。
- 第6章終了時点の `app.rb`、`views/index.erb`、`views/show.erb`、`public/stylesheets/application.css` を実装した。
- 第6章初稿を 6 観点で独立してレビューし、未解決の `must` がないことを確認した。`should` を `review-summary.md` に統合した。
- ルート順の注意、`find_movie` の読み込み方の限界、`halt` の意味、狭幅表示 CSS、次章への橋渡しを本文へ反映した。
- `GET /movies` が `200 OK` と詳細リンクを返すことを確認した。
- `GET /movies/:id` が `200 OK` と詳細画面を返し、タイトル、監督、紹介文、一覧へ戻るリンクを表示することを確認した。
- `GET /movies/not-found` が `404 Not Found` と「映画が見つかりません」を返すことを確認した。
- 正常な `POST /movies` が `303 See Other` と `Location: http://127.0.0.1:4567/movies/:id` を返し、登録後の詳細画面に作成した映画が表示されることを確認した。確認後、`data/movies.json` は初期状態へ戻した。
- 第6章の Ruby 構文、mdBook ビルド、内部リンク、外部リンクを確認した。
- 第6章の再レビューで未解決の `must` がなく、第7章へ進めると判定した。
- 第7章の章設計を作成し、`enable :method_override`、編集画面、PATCH 更新、DELETE 削除、Network タブと Sinatra ログの観察を範囲として確定した。
- 第7章終了時点の `app.rb`、`views/show.erb`、`views/edit.erb`、`public/stylesheets/application.css` を実装した。
- 第7章初稿を 6 観点で独立してレビューし、未解決の `must` がないことを確認した。`should` と一部の `could` を `review-summary.md` に統合した。
- `views/show.erb`、`views/edit.erb`、第7章追加 CSS の完成コード、`merge` と `merge!` の違い、第8章への橋渡し、CRUD 完成のまとめを本文へ反映した。
- `GET /movies/:id/edit` が `200 OK` と編集フォームを返し、`_method=patch` と登録済みの値が含まれることを確認した。
- `_method=patch` を含む `POST /movies/:id` が Sinatra 側で `PATCH /movies/:id` として処理され、成功時に `303 See Other` と詳細画面への `Location` を返すことを確認した。
- 更新時にタイトルを空にすると保存せず、エラーメッセージ付き編集フォームを返し、入力値が保持されることを確認した。
- 詳細画面に更新後の値と `_method=delete` を含む削除フォームが表示されることを確認した。
- `_method=delete` を含む `POST /movies/:id` が Sinatra 側で `DELETE /movies/:id` として処理され、成功時に `303 See Other` と一覧画面への `Location` を返すことを確認した。
- 削除後、削除した映画の詳細 URL が `404 Not Found` になることを確認した。確認後、`data/movies.json` は初期状態へ戻した。
- 第7章の Ruby 構文、mdBook ビルド、内部リンク、外部リンクを確認した。
- 第7章の再レビューで未解決の `must` がなく、第8章へ進めると判定した。
- 第8章の章設計を作成し、登録・更新・削除後のリダイレクトを PRG として意味付けする範囲を確定した。
- 第8章では完成コードに残す変更を行わず、第7章までのコードを使って Network タブと Sinatra ログの観察を中心に執筆した。
- 第8章初稿を 6 観点で独立してレビューし、未解決の `must` がないことを確認した。`should` を `review-summary.md` に統合した。
- 比較コードを写さない注意、PATCH/DELETE と PRG の関係、Network タブ上の POST と `_method`、Preserve log、再実行されていないことの確認方法、状態変更と表示の責務分離を本文へ反映した。
- `POST /movies` が `303 See Other` と詳細画面への `Location` を返し、リダイレクト先の `GET /movies/:id` が `200 OK` と登録した映画を返すことを確認した。
- `_method=patch` を含む `POST /movies/:id` が Sinatra 側で `PATCH /movies/:id` として処理され、`303 See Other` と詳細画面への `Location` を返すことを確認した。
- `_method=delete` を含む `POST /movies/:id` が Sinatra 側で `DELETE /movies/:id` として処理され、`303 See Other` と一覧画面への `Location` を返すことを確認した。
- Sinatra ログで `POST /movies`、`PATCH /movies/:id`、`DELETE /movies/:id` が 303 になり、その後 `GET /movies/:id` と `GET /movies` が発生していることを確認した。確認後、`data/movies.json` は初期状態へ戻した。
- 第8章の Ruby 構文、mdBook ビルド、内部リンク、外部リンクを確認した。
- 第8章の再レビューで未解決の `must` がなく、第9章へ進めると判定した。
- 第9章の章設計を作成し、XSS、出力文脈、`h` ヘルパー、危険な一時確認、安全な完成コードの維持を範囲として確定した。
- 第9章では完成コードに残す変更を行わず、第8章までの安全なコードを使って執筆した。
- 第9章初稿を 6 観点で独立してレビューし、未解決の `must` がないことを確認した。`should` を `review-summary.md` に統合した。
- 確認用データを残さない注意、XSS が HTML 構造や属性値を壊す問題でもあること、`Rack::Utils.escape_html` の範囲、ジャンル値の扱い、アラートが出ない場合の確認、第10章への橋渡しを本文へ反映した。
- `views/*.erb` に `h` を外した利用者入力表示が残っていないことを `rg` で確認した。
- タイトルに `<script>alert("xss")</script>`、紹介文に `</textarea><script>alert("xss")</script>` を含む映画を登録し、詳細画面と編集フォームで文字参照として表示されることを確認した。確認後、`data/movies.json` は初期状態へ戻した。
- 第9章の Ruby 構文、mdBook ビルド、内部リンク、外部リンクを確認した。
- 第9章の再レビューで未解決の `must` がなく、第10章へ進めると判定した。
- 第10章の章設計を作成し、存在しない URL、存在しない映画 ID、404 ページ、404 と 500 の違い、映画図鑑の完成状態確認を範囲として確定した。
- 第10章終了時点の `app.rb` と `views/not_found.erb` を実装した。
- 第10章初稿を 6 観点で独立してレビューし、未解決の `must` がないことを確認した。`should` を `review-summary.md` に統合した。
- 404 処理の重複理由、起動に必要な環境ファイル、`not_found` とルート内 404 の使い分け、共通 404 ページの理由、500 確認用ルートの扱い、第11章への橋渡しを本文へ反映した。
- `GET /unknown`、`GET /movies/not-found`、`GET /movies/not-found/edit`、`PATCH /movies/not-found`、`DELETE /movies/not-found` が `404 Not Found` と 404 ページを返すことを確認した。
- Sinatra ログで存在しない URL、詳細、編集、更新、削除の各 404 を確認した。
- 500 確認用の `/error-example` ルートが実ファイルに残っていないことを確認した。
- 第10章の Ruby 構文、mdBook ビルド、内部リンク、外部リンクを確認した。
- 第10章の再レビューで未解決の `must` がなく、第11章へ進めると判定した。
- 第11章の章設計を作成し、画面、Network タブ、Sinatra ログ、ERB、JSON ファイルの境界で問題を切り分ける範囲を確定した。
- 第11章では完成コードに残す変更を行わず、第10章までの映画図鑑を使ってデバッグ時の観察方法を整理した。
- 第11章初稿を 6 観点で独立してレビューし、未解決の `must` がないことを確認した。6 件の `should` を `review-summary.md` に統合した。
- 確認用コードを残さない注意、JSON 手編集時の注意、ログを見失わない工夫、HTML とアクセシビリティの基本確認、質問時に添える情報、第12章への橋渡しを本文へ反映した。
- 第11章の Ruby 構文、mdBook ビルド、内部リンク、外部リンクを確認した。
- 第11章の再レビューで未解決の `must` がなく、第12章へ進めると判定した。
- 第12章の章設計を作成し、JSON ファイル保存の限界を、同時更新、データ量、関連、整合性の観点から説明する範囲を確定した。
- 第12章では完成コードに残す変更を行わず、第10章までの映画図鑑を振り返ってデータベース設計への橋渡しを行った。
- 第12章初稿を 6 観点で独立してレビューし、未解決の `must` がないことを確認した。採用した `should` を `review-summary.md` に統合した。
- 同時更新の対策を本書では実装しないこと、ファイル保存にも対策はあるが一般的な Web アプリケーションではデータベースを使うことが多いこと、関連の例を映画図鑑に追加しないこと、整合性の言い換え、別題材への転用、参考資料を読む目的を本文へ反映した。
- 第12章の Ruby 構文、mdBook ビルド、内部リンク、外部リンクを確認した。
- 第12章の再レビューで未解決の `must` がなく、本編が完了したと判定した。
- 付録A README、付録B RuboCop、付録C ERB Lint、付録D よくあるエラー、付録E さらに学ぶための資料案内を執筆した。
- 第2部、第3部、第4部の index に残っていたプレースホルダーを本文へ置き換えた。
- 横断レビューで、用語統一、コードスタイル統一、前後参照、サンプルアプリ全体の整合性、難易度、重複説明、図版、リンク、OSS 技術書としての一貫性を確認した。
- 付録Eの RFC 9110 リンクを、外部リンク検査で到達可能な RFC Editor の info ページへ修正した。
- 付録・横断レビュー後の Ruby 構文、mdBook ビルド、内部リンク、外部リンクを確認した。
- 最終検証として、`ruby -c app.rb`、`mdbook build`、`./scripts/check-links.sh internal`、`./scripts/check-links.sh web` が成功することを確認した。
- 最終ランタイム確認として、`GET /` の `/movies` へのリダイレクト、`GET /movies`、`POST /movies`、詳細表示、編集画面、`_method=patch` による更新、存在しない映画 ID の 404、`_method=delete` による削除、削除後の 404 を確認した。
- XSS 確認用の入力として、タイトルに `<script>alert("xss")</script>`、紹介文に `</textarea><script>alert("xss")</script>` を含む映画を登録し、詳細画面で文字参照として表示されることを確認した。
- 最終ランタイム確認後、`data/movies.json` を検証前の状態へ復元し、差分が残っていないことを確認した。

### 2026 年 7 月 20 日: サンプルアプリの分離とハンズオン化

- サンプルアプリ一式（`app.rb`、`views/`、`data/`、`public/`、`Gemfile`、`Gemfile.lock`、`.ruby-version`、`.bundle/config`、`scripts/verify-stack.rb`）を新リポジトリ `sinatra-movies`（`/Users/machida/dev/sinatra-movies`）へ移動し、`git init` して初回コミットした。
- `sinatra-movies` に `README.md`、`.gitignore`、`LICENSE` を用意し、`bundle install` と `bundle exec ruby app.rb` の起動、`GET /movies` が 200 を返すことを確認した。
- 本書リポジトリからアプリ一式を削除し、`.gitignore`（Ruby 依存の記述を削除）と `README.md`（セットアップ／サンプルアプリ起動の節を整理）を更新した。
- 第2章 2.2 を「`mkdir sinatra-movies` → `git init`」から始める構成に改訂し、`.ruby-version` と `Gemfile` は読者が作成、`Gemfile.lock` は `bundle install` で生成する流れに変更した。
- 第3・4章の章開始手順から `git switch -c chapter-0N-work` を削除し、前章末の状態から続ける記述へ変更した。
- preface に「手を動かして作るハンズオン」節と「なぜ Sinatra で学ぶのか」節を追加した。
- gem / Bundler / Puma / rackup / Sinatra の説明を丁寧にし、Ruby・Sinatra のバージョンを指定する理由を明記した。
- `mdbook build` が成功することを確認した。本書リポジトリのコミットは `fa6e294`・`f7e13a7`・（本 STATUS 更新のコミット）。

## 次に行う作業

1. 本書リポジトリの分離・改訂コミットを公開リポジトリ（`fjordllc/sinatra-textbook-ja`）へ push する。
2. `sinatra-movies` を `fjordllc` org 配下の GitHub リポジトリとして作成し、push する（公開/非公開、章タグの要否は要決定）。
3. 既存の `chapter-01`〜`chapter-12`・`manuscript-complete` タグの扱い（残す／削除）を決める。

## レビューへの対応状況

第1章から第12章、付録Aから付録E、横断レビュー、最終検証は完了済みです。横断レビューの `review-summary.md`、`changes.md`、`second-review.md` を保存しました。未解決の `must` はなく、採用した `should` は修正済みです。
