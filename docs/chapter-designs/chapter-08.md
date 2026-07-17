# 第8章 章設計: リダイレクトは二つのリクエストをつなぐ

## この章の目的

第5章から使ってきたリダイレクトを、PRG パターンとして意味付けする。登録、更新、削除の後に直接 HTML を返さず、表示用の GET へ移動する理由を、Network タブと Sinatra ログで確認する。

## 読了後にできるようになること

- PRG が Post/Redirect/Get の略であることを説明できる。
- 状態を変えるリクエストと表示用の GET を分ける理由を説明できる。
- 登録後の `POST /movies`、`303 See Other`、`GET /movies/:id` を Network タブで追える。
- 更新と削除では、Network タブ上の POST と `_method`、Sinatra ログ上の PATCH/DELETE を分けて確認できる。
- 再読み込み時に POST/PATCH/DELETE が再実行されないことを確認できる。

## 必要な前提知識

- 第7章までの CRUD 実装。
- Chrome DevTools の Network タブで URL、メソッド、ステータスコード、Form Data を確認する方法。
- HTML フォームが直接送るのは GET と POST であり、PATCH/DELETE は method override で扱うこと。

## サンプルアプリへ加える変更

この章では、完成コードに残す変更は行わない。第7章までに実装したリダイレクトを観察し、PRG として説明する。

一時的な比較として、ローカル環境で `redirect` の代わりに文字列を返す例を示す。ただし、この変更は保存せず、確認後に元へ戻す。

## Network タブなどで観察する対象

- 登録成功時: `POST /movies`、`303 See Other`、`GET /movies/:id`。
- 更新成功時: Network タブの `POST /movies/:id` と `_method=patch`、303、`GET /movies/:id`。
- 更新成功時: Sinatra ログの `PATCH /movies/:id`。
- 削除成功時: Network タブの `POST /movies/:id` と `_method=delete`、303、`GET /movies`。
- 削除成功時: Sinatra ログの `DELETE /movies/:id`。
- リダイレクト後の表示画面で再読み込みしても、状態変更が再実行されないこと。

## この章では扱わないこと

- 新しい機能の実装。
- 302、303、307、308 の詳細な比較。
- ブラウザ以外の HTTP クライアントでの厳密な挙動差。
- CSRF。
- フラッシュメッセージ。

## 章固有の設計判断

第5章から先に使っていた `redirect` を、この章で PRG として名付ける。先に使い、後から名前と設計意図を与える構成にする。

Sinatra 4.2.1 の固定環境では、POST/PATCH/DELETE 後の `redirect` が `303 See Other` として観察できる。本文ではこの環境での観察結果として扱い、リダイレクトステータス全般の詳細比較へ広げない。

## 参考にする一次情報

- MDN HTTP リダイレクト: <https://developer.mozilla.org/ja/docs/Web/HTTP/Redirections>
- MDN 303 See Other: <https://developer.mozilla.org/ja/docs/Web/HTTP/Status/303>
- Sinatra redirect: <https://sinatrarb.com/intro.html>
