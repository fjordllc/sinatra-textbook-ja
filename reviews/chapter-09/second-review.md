# 第9章 再レビュー

## 対象

第9章「利用者の入力はそのまま HTML にしない」

## 確認した範囲

- `manuscript/part4/chapter9.md`
- `docs/chapter-designs/chapter-09.md`
- `reviews/chapter-09/review-summary.md`
- `reviews/chapter-09/changes.md`
- `app.rb`
- `views/index.erb`
- `views/show.erb`
- `views/new.erb`
- `views/edit.erb`

## must の確認

初回レビューで未解決の `must` はなかった。

## should 対応の確認

- 確認用の危険なデータを残さない注意が追加されている。
- XSS が JavaScript 実行だけでなく HTML 構造や属性値の破壊にも関係すると説明されている。
- `h` ヘルパーの対象範囲が、本書で扱う HTML の表示文脈として補足されている。
- 選択式のジャンルもリクエスト値として扱い、表示時はエスケープする説明がある。
- アラートが出ない場合でもレスポンス HTML を見る説明がある。
- 第10章への橋渡しが追加されている。

## 原稿とコードの一致

第9章では完成コードに残す変更はない。`views/index.erb`、`views/show.erb`、`views/new.erb`、`views/edit.erb` は、利用者入力を表示する箇所で `h` を使っている。

## 判定

未解決の `must` はなく、第9章は実行確認後に完了できる。
