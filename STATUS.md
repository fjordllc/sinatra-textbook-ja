# Sinatra 教科書 作業状況

最終更新日: 2026 年 7 月 17 日

## 現在の状態

第4章「フォームはリクエストを作る」の章設計、初稿、6 観点の独立レビュー、レビュー統合、修正、再検証、再レビューが完了しました。初回レビューで統合した二つの `must` は解決済みで、再レビューにより第4章を完了しました。完了時点は `chapter-04` タグで公開し、次は第5章の章設計へ進みます。

## 確定した方針

- Sinatra の機能を網羅するのではなく、Sinatra を使って Web アプリケーション開発の基礎を学ぶ。
- サンプルアプリは、ログインなし・単一ユーザー・ローカル環境で動く「映画図鑑」とする。
- 映画は最初から `id`、`title`、`director`、`year`、`genre`、`description` を持つ。章の途中で属性を追加しない。
- 映画図鑑は CRUD、JSON 保存、PRG、XSS 対策、404、タイトルの入力チェックまで完成させる。
- 第5章で登録後のリダイレクトを画面遷移として先に利用し、第8章で PRG として意味付けして 303 を明示する。
- HTML フォームによる更新・削除では、Network タブに POST と `_method` が現れ、Rack を通過した後の PATCH・DELETE は Sinatra のログで確認する。
- 利用者入力の表示には `Rack::Utils.escape_html` を呼び出す `h` ヘルパーを使う。第9章内だけで一時的にエスケープを外し、XSS を確認してから安全なコードへ戻す。
- HTTP の本文説明は HTTP/1.1 のメッセージ例に集中する。HTTP/2 以降の内部表現の違いは短い注記に留める。
- 独立した部末演習は設けない。観察、試行、言語化、小さな変更は必要な章や節の流れへ自然に組み込む。
- 各章には、読後に読者が何を説明・実装・判断できるかを表す 1 文の学習ゴールを置く。
- 最終的な起動コマンドは `bundle exec ruby app.rb` に統一する。
- Ruby 4.0.6、Sinatra 4.2.1、Puma 8.0.2、Rack 3.2.6、Bundler 4.0.16 を `Gemfile.lock` で固定する。
- FBC Press シリーズの方針に合わせ、本文とサンプルコードを含むリポジトリ全体を MIT License とする。
- 図版は `scripts/figures/build_all.py` から `manuscript/assets/` へ生成し、手書きの出力 SVG を直接編集しない。
- 一章ずつ、執筆、6 観点の独立レビュー、レビュー統合、修正、再レビュー、完了判定の順で進める。
- レビュー履歴は `reviews/chapter-XX/` に保存し、ほかの初回レビューを参照せず各観点のレビューを作成する。
- `main` は最新の完了章が終わった時点のコードとし、章完了コミットへ `chapter-XX` タグを付ける。

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
- `<%= %>` とエスケープの関係について、第3章では固定データを表示し、利用者入力のエスケープは第6章で扱うと明記した。
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

## 次に行う作業

1. 第4章完了時点を `chapter-04` タグとして公開リポジトリへプッシュする。
2. 第5章「JSON ファイルに映画を保存する」の章設計を作成する。
3. 第5章で使う `data/movies.json`、JSON 読み書き、`SecureRandom.uuid`、タイトル必須チェック、登録後リダイレクトの公式資料と固定バージョンの挙動を確認する。

## レビューへの対応状況

第1章から第4章は完了済みです。第4章の初回レビュー 6 件、`review-summary.md`、`changes.md`、`second-review.md` を保存しました。章末の完成コード不足と `params.inspect` が確認用であることの明示に関する二つの `must` は解決し、再レビューで新たな `must` がないことを確認しました。
