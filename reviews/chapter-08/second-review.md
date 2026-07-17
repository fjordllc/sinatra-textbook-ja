# 第8章 再レビュー

## 対象

第8章「リダイレクトは二つのリクエストをつなぐ」

## 確認した範囲

- `manuscript/part4/chapter8.md`
- `docs/chapter-designs/chapter-08.md`
- `reviews/chapter-08/review-summary.md`
- `reviews/chapter-08/changes.md`
- `app.rb`

## must の確認

初回レビューで未解決の `must` はなかった。

## should 対応の確認

- 比較コードは写す必要がなく、完成コードへ残さないことが明記されている。
- PRG の名前と PATCH/DELETE でも同じ考え方として扱うことが早い位置で説明されている。
- 更新・削除では Network タブ上は POST と `_method` として見えることが注記されている。
- Preserve log の補足が追加されている。
- 再実行されていないことを JSON 件数や Sinatra ログで確認する説明がある。
- 状態変更と表示の責務分離としての意味が補足されている。

## 原稿とコードの一致

第8章では完成コードに残す変更はない。`app.rb` は第7章の状態を維持しており、登録、更新、削除の各ルートは本文で確認対象として示した `redirect` を持っている。

## 判定

未解決の `must` はなく、第8章は実行確認後に完了できる。
