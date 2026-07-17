# 第7章 再レビュー

## 対象

第7章「編集と削除で CRUD を完成させる」

## 確認した範囲

- `manuscript/part3/chapter7.md`
- `app.rb`
- `views/edit.erb`
- `views/show.erb`
- `public/stylesheets/application.css`
- `docs/chapter-designs/chapter-07.md`
- `reviews/chapter-07/review-summary.md`
- `reviews/chapter-07/changes.md`

## must の確認

初回レビューで未解決の `must` はなかった。

## should 対応の確認

- `views/edit.erb`、`views/show.erb`、第7章追加 CSS の完成コードが章末に追加されている。
- 更新・削除後のリダイレクトを第8章で PRG として捉え直す橋渡しが追加されている。
- `merge` と `merge!` の違い、ID が保持されることが説明されている。
- `page-actions` の意図が説明されている。
- CRUD が一通り揃ったことが章末に整理されている。

## 原稿とコードの一致

- `app.rb` に `enable :method_override` がある。
- `GET /movies/:id/edit` は `GET /movies/:id` より前にある。
- `PATCH /movies/:id` は ID が一致する映画を更新し、タイトル空欄時は保存せず `edit` を再表示する。
- `DELETE /movies/:id` は映画を削除し、一覧へリダイレクトする。
- `views/edit.erb` は `_method=patch` を持つ。
- `views/show.erb` は `_method=delete` を持つ削除フォームを持つ。

## 判定

未解決の `must` はなく、原稿とコードは一致している。第7章は実行確認後に完了できる。
