# 第5章 JSON ファイルに映画を保存する

第4章では、映画登録フォームから送られた値を `params.inspect` で確認しました。フォームから値が届くことは分かりましたが、まだ映画は登録されていません。画面を再読み込みしても、アプリを再起動しても、新しい映画は残りません。

この章では、フォームから届いた値を Ruby のハッシュにまとめ、それぞれの映画を区別する ID を加えて `data/movies.json` へ保存します。これにより、登録した映画が次のリクエストやアプリの再起動後にも残るようになります。

## 5.1 保存しなければ次のリクエストで消える

第4章の `POST /movies` は、次のような確認用コードでした。

```ruby
post "/movies" do
  content_type :text
  params.inspect
end
```

これは、送信された値をレスポンスとして返しているだけです。Ruby の変数に入れた値も、レスポンスとして返した文字列も、そのままでは次のリクエストへ引き継がれません。

Web アプリケーションでデータを残すには、リクエストの処理が終わった後も残る場所へ保存する必要があります。本書ではデータベースへ進む前の段階として、JSON ファイルへ保存します。

## 5.2 `data/movies.json` を作る

保存用の JSON ファイルは、`public/` ではなく `data/` に置きます。

```text
data/
  movies.json
```

`public/` は、CSS や画像のようにブラウザから直接取得できる静的ファイルを置く場所です。利用者が登録したデータをブラウザから直接読める場所へ置く必要はありません。アプリが読み書きする保存データは、`data/` に分けて置きます。

第3章で `app.rb` に書いていた映画データを、`data/movies.json` へ移します。このとき、それぞれの映画を区別するための `id` を初めて加えます。同じタイトルの映画が登録されることもあるため、タイトルとは別に、一件ずつ異なる値を持たせます。

ここで使う長い文字列は、UUID（Universally Unique Identifier）と呼ばれる形式の ID です。映画の内容を表す文字列ではなく、十分に重なりにくい値を作れるようにした形式です。この小さなアプリなら `1`、`2`、`3` のような連番も使えますが、新しい映画を加えるたびに次の番号を決める必要があります。本書では、既存の ID から次の番号を調べずに作れる UUID を使います。次の JSON にある 3 つの ID は、教材用にあらかじめ用意した固定値です。

```json
[
  {
    "id": "b6f5e1c4-4b5f-4a7f-8f8f-3d9d3ef9d001",
    "title": "月面喫茶",
    "director": "山田アキラ",
    "year": "2042",
    "genre": "SF",
    "description": "月面にある小さな喫茶店を舞台にした物語。"
  },
  {
    "id": "b6f5e1c4-4b5f-4a7f-8f8f-3d9d3ef9d002",
    "title": "北風のリズム",
    "director": "佐藤ミナ",
    "year": "2038",
    "genre": "ドラマ",
    "description": "雪の町で古い楽器を修理する人々を描く。"
  },
  {
    "id": "b6f5e1c4-4b5f-4a7f-8f8f-3d9d3ef9d003",
    "title": "週末ロケット",
    "director": "鈴木トオル",
    "year": "2040",
    "genre": "コメディ",
    "description": "町工場の仲間たちが小さなロケット作りに挑む。"
  }
]
```

Ruby のハッシュではキーに `=>` を使っていました。JSON ではキーと値の間に `:` を使います。JSON ファイルの中身は Ruby の配列そのものではなく、Ruby から読み込んで配列やハッシュとして扱えるデータです。

## 5.3 JSON を読み込む

`app.rb` の先頭にある `require` の並びを、次のように変更します。ここでは、JSON を扱う標準ライブラリを追加しています。

```ruby
require "json"
require "sinatra"
```

続いて、最後の `require` の下に、保存ファイルの場所を表す定数を追加します。

```ruby
MOVIES_FILE = File.join(__dir__, "data", "movies.json")
```

`__dir__` は、この `app.rb` が置かれているディレクトリです。どのディレクトリからアプリを起動しても、`app.rb` から見た `data/movies.json` を指せるようにしています。`File.join` を使うと、文字列を手でつなぐよりもファイルパスの意図が明確になります。

`MOVIES_FILE` の下、最初の `get` ルートより前に、映画データを読み込むメソッドを追加します。

```ruby
def load_movies
  JSON.parse(File.read(MOVIES_FILE))
end
```

`File.read(MOVIES_FILE)` は JSON ファイルの中身を文字列として読み込みます。`JSON.parse` は、その文字列を Ruby の配列とハッシュへ変換します。

この章では、リポジトリに `data/movies.json` が存在する前提で進めます。JSON の書き方を壊してしまった場合の切り分けは、第11章と付録のよくあるエラーで扱います。

一覧画面では、これまでの `movies` 変数ではなく、ファイルから読み込んだ結果を使います。

```ruby
get "/movies" do
  @movies = load_movies
  erb :index
end
```

ここまで変更して `bundle exec ruby app.rb` を起動し、`/movies` にアクセスしてください。見た目は第4章と同じですが、映画データの置き場所は `app.rb` から `data/movies.json` へ変わっています。

## 5.4 UUID で ID を作る

新しい映画を保存するときも、アプリ側で UUID を作ります。利用者がフォームへ入力する値ではありません。

この章では Ruby 標準ライブラリの `SecureRandom.uuid` を使います。`app.rb` の先頭にある `require` の並びへ、次の 1 行を追加します。

```ruby
require "securerandom"
```

例えば、次のような文字列が作られます。

```ruby
SecureRandom.uuid
#=> "c55c1d37-f3cf-469e-a746-a3044279c716"
```

UUID の詳しい仕組みはこの章では扱いません。ここでは、`SecureRandom.uuid` を呼び出すたびに、新しい映画を区別するための ID を作れることを押さえます。

## 5.5 フォームの値を映画データにする

第4章のフォームでは、`title`、`director`、`year`、`genre`、`description` という名前で値を送りました。この値を映画データのハッシュにまとめるメソッドを作ります。`load_movies` や `save_movies` と同じく、最初の `get` ルートより前へ置きます。

```ruby
def movie_params
  {
    "title" => params["title"].to_s,
    "director" => params["director"].to_s,
    "year" => params["year"].to_s,
    "genre" => params["genre"].to_s,
    "description" => params["description"].to_s
  }
end
```

`params["title"]` のように、フォーム部品の `name` と同じキーで値を取り出します。ここでは `to_s` を付けて、値がない場合でも文字列として扱えるようにしています。

## 5.6 JSON ファイルへ書き戻す

読み込んだ映画配列に新しい映画を追加したら、JSON ファイルへ書き戻します。次の `save_movies` も、`load_movies` の下、最初の `get` ルートより前へ置きます。

```ruby
def save_movies(movies)
  File.write(MOVIES_FILE, JSON.generate(movies))
end
```

`JSON.generate` は、Ruby の配列やハッシュを JSON 文字列へ変換します。`File.write` は、その文字列をファイルへ書き込みます。保存用のデータなので、字下げや整形用の改行は加えません。

`JSON.parse` は JSON 文字列を Ruby の配列やハッシュへ変換します。`JSON.generate` はその逆です。`movies` は Ruby の配列なので、`File.write(MOVIES_FILE, movies)` と書くだけでは JSON 形式で保存できません。

この章の保存方法は、毎回ファイル全体を読み込み、配列を変更し、ファイル全体を書き戻す方法です。小さなローカル教材アプリとしては理解しやすい方法ですが、データが増えたり複数人が同時に使ったりする場合には限界があります。この限界は、第12章で振り返ります。

## 5.7 映画を追加して保存する

`POST /movies` を次のように変更します。

```ruby
post "/movies" do
  movies = load_movies
  movie = { "id" => SecureRandom.uuid }.merge(movie_params)
  movies << movie
  save_movies(movies)

  redirect "/movies"
end
```

`merge` で UUID の入ったハッシュとフォームの値を一つにまとめます。`movies << movie` は、その映画を配列の末尾へ追加します。配列を保存したら、`redirect "/movies"` で一覧画面へ移動します。

フォームから送った値を保存するようになったので、`views/new.erb` の送信ボタンを「送信内容を確認」から「登録する」へ変更します。

```erb
<button type="submit">登録する</button>
```

本書では、タイトルなどの項目を入力して操作することを前提に、データが保存されるまでの流れを学びます。入力値の検証や、エラー時に入力内容を保ってフォームを再表示する処理は、Rails でバリデーションを学ぶときに扱います。このアプリでは空欄も保存されます。公開して利用者に使ってもらう際には、サーバー側での入力チェックが必要です。

リダイレクトは、まず「保存後に別の URL へ移動するレスポンス」として使います。再送信を防ぐ仕組みは、第8章で PRG として説明します。

## 5.8 利用者の入力を安全に表示する

保存した映画を一覧に表示する前に、`app.rb` へ `h` ヘルパーを追加します。`require` はファイルの先頭、`helpers` は最初のルートより前へ置きます。

```ruby
require "rack/utils"

helpers do
  def h(value)
    Rack::Utils.escape_html(value)
  end
end
```

Sinatra の ERB では、`<%= %>` に書いた値が自動で HTML エスケープされるとは考えません。`h` は、HTML として特別な意味を持つ文字を、文字として表示できる形へ変換します。例えば `<` は `&lt;` になります。表示する値を `h` に渡す理由は、第9章で詳しく学びます。

## 5.9 保存した値を一覧に表示する

一覧画面でも `h` を使います。

```erb
<td><%= h(movie["title"]) %></td>
<td><%= h(movie["year"]) %></td>
<td><%= h(movie["genre"]) %></td>
```

XSS の危険を実際に見るのは第9章です。この章では、保存した利用者入力を表示する時点から、安全な表示の形を使っておきます。

## 5.10 登録後の動きを Network タブで見る

サーバーを起動し、`/movies/new` から新しい映画を登録してください。

登録に成功すると、ブラウザは一覧画面へ移動します。Network タブでは、次の流れを確認できます。

```text
POST /movies
GET /movies
```

`POST /movies` のレスポンスは、HTML そのものではなく、別の URL へ移動する指示です。この環境では `303 See Other` として確認できます。その指示を受けて、ブラウザが `GET /movies` を送ります。

`data/movies.json` も確認してください。送信した映画が UUID 付きで追加されています。

## 5.11 この章の完成コード

この章の最後の `app.rb` は次の形です。

```ruby
require "json"
require "rack/utils"
require "securerandom"
require "sinatra"

MOVIES_FILE = File.join(__dir__, "data", "movies.json")

helpers do
  def h(value)
    Rack::Utils.escape_html(value)
  end
end

def load_movies
  JSON.parse(File.read(MOVIES_FILE))
end

def save_movies(movies)
  File.write(MOVIES_FILE, JSON.generate(movies))
end

def movie_params
  {
    "title" => params["title"].to_s,
    "director" => params["director"].to_s,
    "year" => params["year"].to_s,
    "genre" => params["genre"].to_s,
    "description" => params["description"].to_s
  }
end

get "/" do
  redirect "/movies"
end

get "/movies" do
  @movies = load_movies
  erb :index
end

get "/movies/new" do
  erb :new
end

post "/movies" do
  movies = load_movies
  movie = { "id" => SecureRandom.uuid }.merge(movie_params)
  movies << movie
  save_movies(movies)

  redirect "/movies"
end
```

`views/index.erb` では、映画の値を `h` で表示します。

```erb
<h1>映画一覧</h1>

<p>登録されている映画を一覧で表示します。</p>

<p>
  <a class="button-link" href="/movies/new">新しい映画を登録</a>
</p>

<div class="table-scroll">
  <table class="movie-table">
    <thead>
      <tr>
        <th scope="col">タイトル</th>
        <th scope="col">公開年</th>
        <th scope="col">ジャンル</th>
      </tr>
    </thead>
    <tbody>
      <% @movies.each do |movie| %>
        <tr>
          <td><%= h(movie["title"]) %></td>
          <td><%= h(movie["year"]) %></td>
          <td><%= h(movie["genre"]) %></td>
        </tr>
      <% end %>
    </tbody>
  </table>
</div>
```

登録フォームの `views/new.erb` は、第4章のコードから送信ボタンの文言を「登録する」へ変更したものを使います。CSS は第4章のものをそのまま使います。

## 確認しよう

1. `/movies/new` からタイトルを入れて映画を登録する。
2. Network タブで `POST /movies` の後に `GET /movies` が発生していることを確認する。
3. 送信前後で `data/movies.json` を開き、UUID 付きの映画が追加されたことを確認する。

## 考えてみよう

- なぜタイトルや配列の位置ではなく、UUID を ID にするのでしょうか。
- なぜ保存用 JSON を `public/` に置かないのでしょうか。
- 保存後に直接 HTML を返すのではなく、なぜ別の URL へ移動させているのでしょうか。

## さらに学ぶ

この章で使った保存、識別、安全な表示、画面遷移をさらに調べると、登録処理を部品ごとに説明できるようになります。

- [Ruby JSON](https://docs.ruby-lang.org/ja/latest/library/json.html)では、Ruby の配列やハッシュを JSON へ変換する方法と、読み書きで起きる例外を学べます。
- [Ruby SecureRandom](https://docs.ruby-lang.org/ja/latest/library/securerandom.html)では、UUID を含む推測されにくい識別子を生成する方法を学べます。
- [Rack Utils](https://rack.github.io/rack/main/Rack/Utils.html)では、HTML エスケープなど、Sinatra の背後で利用できる Web 向け処理を確認できます。
- [Sinatra 公式ドキュメント](https://sinatrarb.com/intro.html)では、`params`、`redirect`、ルーティングがどのように連携するかを詳しく学べます。
- [MDN HTTP リダイレクト](https://developer.mozilla.org/ja/docs/Web/HTTP/Redirections)では、リダイレクト用ステータスコードの違いと、ブラウザが次の URL へ移動する仕組みを学べます。
