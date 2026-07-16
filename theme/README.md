# テーマファイル

- `mdbook-book-core.css`: 共有テーマのレイアウト層。直接編集しない。
- `mdbook-book-jp.css`: 共有テーマの日本語タイポグラフィ層。直接編集しない。
- `sinatra-textbook.css`: 本書固有のスタイル。
- `textbook-footer.js`: FBC Press 共通の短いフッターを各ページへ追加する。

共有テーマを更新するときは、次を実行します。

```sh
bash ../mdbook-book-jp/bin/update.sh .
```

