# 第7章 章設計: 編集と削除で CRUD を完成させる

## この章の目的

映画図鑑に編集と削除を追加し、CRUD を一通り実装する。HTML フォームが直接送信できるのは GET と POST だけであることを確認し、Rack の method override を使って PATCH と DELETE として扱う。

## 読了後にできるようになること

- CRUD の作成、読み取り、更新、削除を映画図鑑のルートに対応付けられる。
- `GET /movies/:id/edit` と `PATCH /movies/:id` の役割を分けて説明できる。
- HTML フォームでは `_method` を使って PATCH と DELETE を表す必要があると説明できる。
- 既存の映画を ID で探し、入力値で更新して JSON へ保存できる。
- 更新時にもタイトル必須チェックを行い、入力値を保持して `422 Unprocessable Content` で編集フォームを再表示できる。
- 詳細画面から DELETE を送り、映画を削除して一覧へ戻れる。

## 必要な前提知識

- 第6章までの詳細画面、ID 検索、JSON 保存、`h` ヘルパー。
- HTML フォームの `method` と hidden input。
- `POST`、`PATCH`、`DELETE` の役割の基本。

## サンプルアプリへ加える変更

- `enable :method_override` を追加する。
- `find_movie_from(movies, id)` を追加し、読み込んだ配列から 1 件を探せるようにする。
- `GET /movies/:id/edit` を追加し、編集フォームを表示する。
- `views/edit.erb` を追加する。
- `PATCH /movies/:id` を追加し、映画を更新する。
- `DELETE /movies/:id` を追加し、映画を削除する。
- 詳細画面に「編集する」リンクと削除フォームを追加する。
- 更新成功後は詳細画面へ、削除成功後は一覧画面へリダイレクトする。

## Network タブなどで観察する対象

- 編集画面表示の `GET /movies/:id/edit`。
- 更新フォーム送信時の Network タブ上の `POST` と Form Data の `_method=patch`。
- Sinatra のログで `PATCH /movies/:id` として処理されていること。
- 削除フォーム送信時の Network タブ上の `POST` と Form Data の `_method=delete`。
- Sinatra のログで `DELETE /movies/:id` として処理されていること。
- 更新成功後の 303 と `GET /movies/:id`。
- 削除成功後の 303 と `GET /movies`。

## この章では扱わないこと

- JavaScript による削除確認。
- 削除確認画面。
- 認証、認可。
- 同時更新、排他制御。
- CSRF 対策。
- 編集フォームと登録フォームの部分テンプレート化。

## 章固有の設計判断

登録フォームと編集フォームは似ているが、この章では部分テンプレート化しない。読者が変更箇所と送信先を追いやすいことを優先する。

削除確認画面は設けず、詳細画面から DELETE 用フォームを送る。誤操作対策は本章の中心ではないため、必要なら後の発展的な話題へ回す。

## 参考にする一次情報

- MDN PATCH: <https://developer.mozilla.org/ja/docs/Web/HTTP/Methods/PATCH>
- MDN DELETE: <https://developer.mozilla.org/ja/docs/Web/HTTP/Methods/DELETE>
- Rack MethodOverride: <https://rack.github.io/rack/main/Rack/MethodOverride.html>
- Sinatra configuration: <https://sinatrarb.com/configuration>
