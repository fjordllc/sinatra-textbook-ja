# 第6章 再レビュー

## 対象

第6章「一覧と詳細でリソースを分ける」

## 確認した範囲

- `manuscript/part3/chapter6.md`
- `app.rb`
- `views/index.erb`
- `views/show.erb`
- `public/stylesheets/application.css`
- `docs/chapter-designs/chapter-06.md`
- `reviews/chapter-06/review-summary.md`
- `reviews/chapter-06/changes.md`

## must の確認

初回レビューで未解決の `must` はなかった。

## should 対応の確認

- ルート順の注意が補足されている。
- 第6章で追加した CSS の完成コードが本文に掲載されている。
- `find_movie` が毎回 JSON を読み込むことの意図と限界が説明されている。
- 狭幅時の詳細画面 CSS が追加されている。
- `halt` の意味が初出時に説明されている。
- 第7章の編集・削除への橋渡しが章末に追加されている。

## 原稿とコードの一致

- `app.rb` では `find_movie`、`GET /movies/:id`、登録後の詳細リダイレクトが本文どおりに実装されている。
- `GET /movies/new` は `GET /movies/:id` より前にあり、本文のルート順の説明と一致している。
- `views/index.erb` には操作列と詳細リンクがある。
- `views/show.erb` は、タイトル、監督、公開年、ジャンル、紹介文を `h` で表示している。
- CSS は詳細画面、紹介文の改行、狭幅表示のスタイルを含んでいる。

## 判定

未解決の `must` はなく、原稿とコードは一致している。第6章は実行確認後に完了できる。
