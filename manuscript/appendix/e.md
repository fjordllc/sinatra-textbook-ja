# 付録E さらに学ぶための資料案内

本編の各章では、必要な範囲だけを説明しました。

ここでは、本書の範囲を越えて学びたいときの入口をまとめます。すべてを一度に読む必要はありません。自分がいま知りたいことに合わせて参照してください。

## Sinatra

- Sinatra 公式ドキュメント: <https://sinatrarb.com/intro.html>

Sinatra のルーティング、テンプレート、設定、ヘルパーなどを確認できます。本書では使わなかった機能も多く載っています。

## Rack

- Rack 公式リポジトリ: <https://github.com/rack/rack>
- Rack: <https://rack.github.io/>

Rack は、Ruby の Web サーバーと Web アプリケーションをつなぐ共通の仕組みです。本書では、Sinatra と Web サーバーの間に Rack があること、method override に Rack が関係していることを扱いました。

## HTTP

- MDN HTTP: <https://developer.mozilla.org/ja/docs/Web/HTTP>
- RFC 9110 HTTP Semantics: <https://www.rfc-editor.org/info/rfc9110>

HTTP メソッド、ステータスコード、ヘッダー、リダイレクトについて詳しく知りたいときに参照します。RFC は仕様書なので、最初から全部読む必要はありません。

## ブラウザ開発者ツール

- MDN ブラウザ開発者ツール: <https://developer.mozilla.org/ja/docs/Learn/Common_questions/Tools_and_setup/What_are_browser_developer_tools>

Network タブ以外にも、HTML、CSS、コンソールなどを確認する機能があります。Firefox などのブラウザにも同じような開発者ツールがあります。

## REST

- 『Webを支える技術』

本書では、REST の理論を深く説明せず、URL、HTTP メソッド、CRUD の対応を実装として扱いました。REST の背景や設計思想を学びたい場合は、専門の資料で学ぶとよいでしょう。

## セキュリティ

- OWASP Cross Site Scripting Prevention Cheat Sheet: <https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html>
- OWASP Cross-Site Request Forgery Prevention Cheat Sheet: <https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html>

本書では XSS の基本だけを扱い、CSRF は扱いませんでした。Web セキュリティは範囲が広いため、公式に近い資料を参照しながら少しずつ学びます。

## テスト

- Rack::Test: <https://github.com/rack/rack-test>

本編ではテストを扱いませんでした。Sinatra アプリケーションのリクエストとレスポンスをテストしたい場合、Rack::Test が入口になります。

## CSV

- Ruby CSV: <https://docs.ruby-lang.org/ja/latest/library/csv.html>

本書では JSON を保存形式として使いました。CSV は表形式のデータと相性がよい形式です。データ構造によって向き不向きがあります。

## データベース

- SQLite Appropriate Uses For SQLite: <https://www.sqlite.org/whentouse.html>
- Rails Guides Active Record Basics: <https://guides.rubyonrails.org/active_record_basics.html>

JSON ファイル保存の限界を感じたら、データベース設計へ進みます。Rails を学ぶときは、Active Record がデータベースとのやり取りをどのように扱うのかを意識すると、本書で学んだ保存処理とのつながりが見えやすくなります。
