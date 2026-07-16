# Sinatra 教科書 作業状況

最終更新日: 2026 年 7 月 17 日

## 現在の状態

`OUTLINE.md` の最終レビューと指摘対応、章単位の執筆・レビュー工程の文書化、第1章の章設計が完了しました。書籍リポジトリを mdBook として初期化し、技術前提と図版生成方法も検証済みです。第1章の本文執筆を開始できる状態です。

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

## 採用しなかった案と理由

- 部末演習: FBC に別の Sinatra 提出課題があり、役割が重複するため採用しない。
- 属性を章ごとに追加する構成: Web アプリケーションの説明とデータ構造の変更が混ざるため採用しない。
- HTTP/2 と HTTP/3 の独立した節: 初学者にとって本筋から外れるため採用しない。
- PRG の章までリダイレクトを使わない構成: 動くアプリとして不自然になるため採用しない。先に使い、後から名前と理由を説明する。
- XSS の脆弱なコードを複数章にわたって残す構成: 安全でない中間コードが長く残るため採用しない。

## 未解決の課題

- 第1章の「はじめに」と第1部導入を、章本文との重複を避けて執筆する。
- 第1章の初稿を、章設計どおりの密度と説明順で作成する。
- Chrome DevTools の項目名と操作手順を、原稿執筆時の Chrome で確認する。
- 新規リポジトリの GitHub 上の公開先と Cloudflare Pages の設定は未作成である。

## 関係するファイル

- `OUTLINE.md`: 全体設計、章設計、映画図鑑の仕様
- `STATUS.md`: 決定事項、未解決事項、作業状況
- `docs/WRITING_AND_REVIEW_WORKFLOW.md`: 章単位の執筆・レビュー工程
- `docs/chapter-designs/chapter-01.md`: 第1章の執筆前設計
- `reviews/README.md`: レビュー履歴の構成と運用
- `reviews/templates/`: 初回レビュー、統合、修正記録、再レビューのテンプレート
- `STYLEGUIDE.md`: 本書固有の執筆・コード・HTTP 表現のルール
- `TERMS.md`: 本書固有の用語とコード上の名前
- `manuscript/`: mdBook で公開する原稿と図版
- `scripts/verify-stack.rb`: 固定技術構成の教材固有機能を確認するスクリプト
- `scripts/figures/build_all.py`: 図版を再生成する集約スクリプト
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
- ブラウザ自動操作の接続機能は利用できなかったため、mdBook 全体のブラウザ目視確認は第1章初稿の完成後に行う。

## 次に行う作業

1. `docs/chapter-designs/chapter-01.md` に基づき、「はじめに」、第1部導入、第1章本文を執筆する。
2. 原稿中の Network タブの操作を実画面で確認する。
3. mdBook のビルド、リンク、表示を確認する。
4. 6 観点の独立した初回レビューを `reviews/chapter-01/` に保存する。

## レビューへの対応状況

OUTLINE の最終レビューで挙がった必須指摘と推奨指摘は反映済みです。部末演習と HTTP/2 以降の扱いは、教育上の判断に基づいて方針を調整しました。章単位のレビュー工程は文書化済みです。第1章は執筆開始可能であり、初回レビューは本文と対象コードを作成した後に開始します。
