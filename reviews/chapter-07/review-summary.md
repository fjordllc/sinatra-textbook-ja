# レビュー統合

## 対象

第7章「編集と削除で CRUD を完成させる」

## 総評

6 観点すべてで、章の目的と実装方針は妥当と判断された。未解決の `must` はない。method override、PATCH、DELETE、更新時の入力チェック、削除フォーム、Network タブと Sinatra ログの見え方が本章の中心として扱えている。

## must

なし。

## should

- `views/edit.erb`、`views/show.erb`、第7章追加 CSS の完成コードを章末へ追加する。採用。
- 更新・削除後のリダイレクトは第8章で PRG として意味付けすることを補足する。採用。
- `movie.merge(movie_params)` と `movie.merge!(@movie)` の違い、ID が保持されることを補足する。採用。
- `page-actions` の意図を本文に補足する。採用。
- 章末で CRUD が一通り揃ったことをまとめる。採用。

## could

- 削除後に元の詳細 URL へアクセスすると 404 になることを確認項目に追加する。採用。
- 削除確認を省略する理由は本文で十分説明されているため、追加しない。

## 対応後の確認観点

- `enable :method_override` が `app.rb` と本文の完成コードにあること。
- 更新時の空タイトルで保存されず、編集フォームが再表示されること。
- 削除後に一覧へリダイレクトし、削除した ID が 404 になること。
- Network タブの POST と `_method`、Sinatra ログの PATCH/DELETE の違いを本文が説明していること。
