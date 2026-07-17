# 第5章 再レビュー

## 対象

第5章「JSON ファイルに映画を保存する」

## 確認した範囲

- `manuscript/part3/chapter5.md`
- `app.rb`
- `data/movies.json`
- `views/index.erb`
- `views/new.erb`
- `public/stylesheets/application.css`
- `OUTLINE.md`
- `docs/chapter-designs/chapter-05.md`
- `reviews/chapter-05/review-summary.md`
- `reviews/chapter-05/changes.md`

## must の確認

初回レビューで未解決の `must` はなかった。

## should 対応の確認

- JSON ファイルの送信前後の観察手順が章末に追加されている。
- `File.join(__dir__, ...)` の意図が説明されている。
- 壊れた JSON やファイル欠落はこの章の範囲外で、第11章と付録へ回す方針が明記されている。
- `role="alert"` が `views/new.erb` と本文の完成コードへ反映されている。
- `JSON.parse` と `JSON.pretty_generate` の変換方向が対比されている。
- 第8章では、303 の初出ではなく PRG の意味付けと再送信防止を扱うことが補足されている。

## 原稿とコードの一致

- `app.rb` の `require`、`MOVIES_FILE`、`h` ヘルパー、`load_movies`、`save_movies`、`movie_params`、各ルートは本文の完成コードと一致している。
- `views/index.erb` は、一覧のタイトル、公開年、ジャンルを `h` で表示している。
- `views/new.erb` は、エラーメッセージ、入力値保持、ジャンルの `selected`、`role="alert"` を本文どおりに持っている。
- `data/movies.json` は、第3章で使っていた 3 件の架空映画を JSON として持っている。
- CSS は、本文で示した `.error-messages` のスタイルを含んでいる。

## 前章・次章との接続

第4章の `params.inspect` は、第5章で保存処理とリダイレクトへ置き換わる。第5章で `h` ヘルパーを導入したため、第6章では詳細画面へ同じ方針を広げる構成になり、XSS の実演は第9章に残る。

登録成功後の遷移先は、第5章では `/movies` のままである。第6章で詳細画面を追加し、登録成功後の遷移先を `/movies/:id` へ変える前提は保たれている。

## 実行・検証結果

- `ruby -c app.rb`: 成功。
- `mdbook build`: 成功。
- ローカルサーバーで `GET /movies/new` が 200 と HTML を返すことを確認した。
- 正常な `POST /movies` が 303 と `Location: /movies` を返し、`data/movies.json` に UUID 付きの映画が追加されることを確認した。
- タイトル空欄の `POST /movies` が 200 とエラーメッセージ付きフォームを返し、入力値が保持されることを確認した。
- `<script>alert("xss")</script>` をタイトルに含む映画を保存して一覧を取得し、`&lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;` として表示されることを確認した。
- 検証で追加した映画データは、退避していた `data/movies.json` から復元した。

## 判定

未解決の `must` はなく、原稿とコードは一致している。第5章は完了とし、第6章へ進める。
