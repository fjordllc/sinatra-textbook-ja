# 第5章 章設計: JSON ファイルに映画を保存する

## この章の目的

第4章で `params.inspect` に表示していたフォーム送信値を、映画データとして `data/movies.json` へ保存する。保存した値を次のリクエストでも使えるようにし、タイトル必須チェック、入力エラー時の再表示、成功時のリダイレクトまでを実装する。

## 読了後にできるようになること

- `JSON.parse` と `JSON.pretty_generate` を使って、JSON ファイルと Ruby の配列を行き来できる。
- `SecureRandom.uuid` で、利用者入力とは別の一意な ID を作れる。
- フォームから届いた値をハッシュにまとめ、配列へ追加して保存できる。
- タイトルが空のとき、保存もリダイレクトもせずに登録フォームを再表示できる。
- 入力エラー時に、エラーメッセージと入力済みの値を保持できる。
- 保存後の `redirect "/movies"` を、別 URL へ移動するレスポンスとして Network タブで観察できる。
- 保存した利用者入力を表示するとき、`h` ヘルパーで HTML エスケープする必要があると説明できる。

## 必要な前提知識

- 第4章までのルーティング、ERB、フォーム、`params`。
- Ruby の配列、ハッシュ、メソッド定義。
- JSON は文字列として書かれたデータ形式であり、Ruby の配列やハッシュとは別物であること。

## サンプルアプリへ加える変更

- `data/movies.json` を追加し、第3章から使っていた固定映画データを移す。
- `app.rb` に `json`、`securerandom`、`rack/utils` を読み込む。
- `MOVIES_FILE` を定義し、保存ファイルの場所を 1 か所にまとめる。
- `load_movies`、`save_movies`、`movie_params` を追加する。
- `helpers` ブロックで `h` ヘルパーを定義する。
- `GET /movies` は `data/movies.json` から読み込んだ映画を表示する。
- `GET /movies/new` は空の `@movie` と `@errors` を用意する。
- `POST /movies` はタイトルを検証し、成功時だけ UUID 付きの映画を保存して `/movies` へリダイレクトする。
- `views/index.erb` と `views/new.erb` で利用者入力を `h` ヘルパー経由で表示する。
- `public/stylesheets/application.css` にエラーメッセージの最小限の見た目を追加する。

## Network タブなどで観察する対象

- 登録成功時に `POST /movies` がリダイレクトレスポンスを返し、その後 `GET /movies` が発生すること。
- 登録成功後に再読み込みしても、フォーム送信画面ではなく一覧画面を再取得していること。
- タイトル空欄時はリダイレクトせず、`POST /movies` のレスポンスとして登録フォームが返ること。
- `data/movies.json` に UUID 付きの映画が追加されること。

## この章では扱わないこと

- 詳細画面への遷移。登録後はいったん一覧へ戻し、第6章で詳細画面へ変更する。
- `PATCH`、`DELETE`、method override。
- PRG という名前と 303 の意味。第8章で扱う。
- 複数項目の本格的なバリデーション。タイトル必須だけに絞る。
- XSS の攻撃例の実演。第9章で、エスケープを一時的に外して確認する。
- ファイル保存の排他制御や同時更新。

## 章固有の設計判断

第5章から保存した利用者入力が一覧画面とエラー時のフォームに表示される。そのため、当初第6章で導入予定だった `h` ヘルパーを第5章へ前倒しする。XSS の詳しい説明は第9章へ残すが、保存した利用者入力を `<%= %>` だけで表示する中間コードは作らない。

`data/movies.json` は空配列ではなく、第3章で `app.rb` に置いた 3 件の映画データを移して始める。これにより、読者は「Ruby の配列から JSON ファイルへ保存場所を移した」と理解できる。

成功時のリダイレクトは `redirect "/movies"` のままとする。第8章で PRG と 303 を扱うまでは、別 URL へ移動するレスポンスとして観察する。

## 参考にする一次情報

- Ruby JSON: <https://docs.ruby-lang.org/ja/latest/library/json.html>
- Ruby SecureRandom: <https://docs.ruby-lang.org/ja/latest/library/securerandom.html>
- Rack Utils: <https://rack.github.io/rack/main/Rack/Utils.html>
- Sinatra リダイレクト: <https://sinatrarb.com/intro.html>
- MDN HTTP リダイレクト: <https://developer.mozilla.org/ja/docs/Web/HTTP/Redirections>
