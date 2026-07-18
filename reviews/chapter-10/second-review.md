# 第10章 再レビュー

## 対象

第10章「見つからないものには 404 を返す」

## 確認した範囲

- `manuscript/part4/chapter10.md`
- `app.rb`
- `views/not_found.erb`
- `docs/chapter-designs/chapter-10.md`
- `reviews/chapter-10/review-summary.md`
- `reviews/chapter-10/changes.md`

## must の確認

初回レビューで未解決の `must` はなかった。

## should 対応の確認

- 404 処理の重複を残す理由が説明されている。
- 完成状態に環境ファイルが追加されている。
- `not_found` とルート内の `status 404` の違いが説明されている。
- 共通 404 ページを使う理由が説明されている。
- 500 確認用ルートの追加場所と削除が明記されている。
- 第11章への橋渡しが追加されている。

## 原稿とコードの一致

- `views/not_found.erb` は本文の完成コードと一致している。
- `app.rb` には `not_found do erb :not_found end` がある。
- 詳細、編集、更新、削除で映画が見つからない場合に `status 404` と `erb :not_found` を返す。
- 500 確認用ルートは実ファイルに残っていない。

## 判定

未解決の `must` はなく、第10章は実行確認後に完了できる。
