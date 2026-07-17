# レビュー担当

Ruby・Sinatra・Rack に詳しい技術者

# 対象

第4章「フォームはリクエストを作る」

- 原稿: `manuscript/part2/chapter4.md`
- コード: `app.rb`, `views/index.erb`, `views/new.erb`, `public/stylesheets/application.css`
- 章設計: `docs/chapter-designs/chapter-04.md`

# 総評

Sinatra の `post "/movies"` と `params` の扱いは、この段階の教材として適切です。`content_type :text` を使って確認用レスポンスを HTML にしない判断も良いです。`GET /movies` と `POST /movies` が同じパスでも別ルートになる説明も正確です。

技術的な注意点は、`params.inspect` の出力を固定しすぎると Rack/Sinatra の表示差に影響される可能性があることです。ただし、本書は固定バージョンで検証しているため、実測値と合わせる方針で問題ありません。

# 良い点

- `post "/movies"` を保存処理ではなく `params` 観察用に限定している。
- `content_type :text` により、入力値を HTML として解釈させない。
- `GET /movies` と `POST /movies` を HTTP メソッドで区別している。
- `params` のキーが `name` 属性から来る説明が正しい。
- `PATCH` / `DELETE` と method override を第7章へ送っている。

# 改善が必要な点

## must

### `params.inspect` の章末コードに確認用である注記が必要

- 問題: `post "/movies"` の完成コードが `params.inspect` を返す形で終わっているが、後で置き換える前提が章末コードの近くにない。
- 問題になる理由: 初学者が `params.inspect` を通常のレスポンス実装として覚える可能性がある。Sinatra の理解としては正しいが、Web アプリケーションの完成コードとしては不自然。
- 修正案: 4.8 の `post "/movies"` の直後に、このルートは第4章だけの確認用であり、第5章で保存処理と画面遷移に置き換えると明記する。
- 対象箇所: 4.8

## should

### `params` が文字列キーであることをもう少し明確にする

- 問題: `params["title"]` と書いているが、`params[:title]` ではない理由は説明していない。
- 問題になる理由: Ruby 学習済みの読者はシンボルキーのハッシュに慣れている可能性があり、混乱する。
- 修正案: 本書ではフォームから届く値を `params["title"]` のように文字列キーで扱う、と一文入れる。Sinatra の内部仕様の深掘りは不要。
- 対象箇所: 4.3

### `content_type :text` の効果を実測と結び付ける

- 問題: `content_type :text` の説明はあるが、Network パネルで `text/plain` として確認する流れが薄い。
- 問題になる理由: 第3章で `Content-Type` を観察した流れを継続できる。
- 修正案: 4.6 の確認項目に Response Headers の `Content-Type: text/plain` を追加する。
- 対象箇所: 4.6

## could

### `params` は Rack 経由で解析されることを深追いしない

- 改善案: 現状どおり Sinatra が `params` を用意すると説明するだけでよい。
- 期待される効果: フォームと HTTP に集中できる。
- 対象箇所: 4.3

# 疑問点

- `content_type :text` は第4章の範囲では良い。第5章でリダイレクトへ変わるため、長く残らない。

# 判定

修正後に次へ進める。
