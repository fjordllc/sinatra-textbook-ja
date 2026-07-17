# レビュー担当

Ruby・Sinatra・Rack に詳しい技術者

# 対象

第7章「編集と削除で CRUD を完成させる」

# 総評

Sinatra と Rack の使い方は正確で、初学者向けとして過度に抽象化していない。`find_movie_from` を追加して、読み込んだ配列の同じハッシュを更新・削除する実装は理解しやすい。

# 良い点

- `enable :method_override` を明示している。
- `patch` と `delete` のルートが自然に書かれている。
- `params` 全体ではなく `movie_params` のキーだけを使って更新している。
- 更新エラー時に保存しない設計になっている。
- `halt 404` を更新・削除にも適用している。

# 改善が必要な点

## must

なし。

## should

- 問題: `movie.merge!(@movie)` の説明がやや短く、`@movie` に ID が含まれていることが分かりにくい。
- 理由: `@movie = movie.merge(movie_params)` によって ID は保持されるが、初学者には見えにくい。
- 修正案: `movie_params` は ID を含まないが、`movie.merge(movie_params)` により元の ID を残した更新用ハッシュになると補足する。

## could

- 改善案: `find_movie_from` と `find_movie` の名前が似ているが、この段階では許容できる。

# 疑問点

なし。

# 判定

軽微な補足後に次へ進める。
