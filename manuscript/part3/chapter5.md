# 第5章 JSON ファイルに映画を保存する

第4章では、映画登録フォームから送られた値を `params.inspect` で確認しました。フォームから値が届くことは分かりましたが、まだ映画は登録されていません。画面を再読み込みしても、アプリを再起動しても、新しい映画は残りません。

この章では、フォームから届いた映画データを `data/movies.json` へ保存します。読了後には、フォームの値を Ruby のハッシュにまとめ、UUID を付け、JSON ファイルへ書き戻せるようになります。

## 保存しなければ次のリクエストで消える

第4章の `POST /movies` は、次のような確認用コードでした。

```ruby
post "/movies" do
  content_type :text
  params.inspect
end
```

これは、送信された値をレスポンスとして返しているだけです。Ruby の変数に入れた値も、レスポンスとして返した文字列も、そのままでは次のリクエストへ引き継がれません。

Web アプリケーションでデータを残すには、リクエストの処理が終わった後も残る場所へ保存する必要があります。本書ではデータベースへ進む前の段階として、JSON ファイルへ保存します。

## `data/movies.json` を作る

保存用の JSON ファイルは、`public/` ではなく `data/` に置きます。

```text
data/
  movies.json
```

`public/` は、CSS や画像のようにブラウザから直接取得できる静的ファイルを置く場所です。利用者が登録したデータをブラウザから直接読める場所へ置く必要はありません。アプリが読み書きする保存データは、`data/` に分けて置きます。

第3章で `app.rb` に書いていた映画データを、`data/movies.json` へ移します。

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

## JSON を読み込む

`app.rb` の先頭で、JSON を扱う標準ライブラリを読み込みます。

```ruby
require "json"
require "sinatra"
```

続いて、保存ファイルの場所を定数にします。

```ruby
MOVIES_FILE = File.join(__dir__, "data", "movies.json")
```

`__dir__` は、この `app.rb` が置かれているディレクトリです。どのディレクトリからアプリを起動しても、`app.rb` から見た `data/movies.json` を指せるようにしています。`File.join` を使うと、文字列を手でつなぐよりもファイルパスの意図が明確になります。

映画データを読み込むメソッドを追加します。

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

## UUID で ID を作る

新しい映画を保存するときは、アプリ側で ID を作ります。タイトルや配列の位置を ID にしてはいけません。

同じタイトルの映画が複数登録されることはあります。配列の位置は、並び替えや削除で変わることがあります。ID は、表示名や順番ではなく、その映画を一意に識別するための値です。

この章では Ruby 標準ライブラリの `SecureRandom.uuid` を使います。

```ruby
require "securerandom"
```

例えば、次のような文字列が作られます。

```ruby
SecureRandom.uuid
#=> "c55c1d37-f3cf-469e-a746-a3044279c716"
```

UUID の詳しい仕組みはこの章では扱いません。ここでは「同名の映画があっても別のデータとして扱うための ID」として使います。

## フォームの値を映画データにする

第4章のフォームでは、`title`、`director`、`year`、`genre`、`description` という名前で値を送りました。この値を映画データのハッシュにまとめるメソッドを作ります。

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

## JSON ファイルへ書き戻す

読み込んだ映画配列に新しい映画を追加したら、JSON ファイルへ書き戻します。

```ruby
def save_movies(movies)
  File.write(MOVIES_FILE, "#{JSON.pretty_generate(movies)}\n")
end
```

`JSON.pretty_generate` は、Ruby の配列やハッシュを読みやすい JSON 文字列へ変換します。`File.write` は、その文字列をファイルへ書き込みます。

`JSON.parse` は JSON 文字列を Ruby の配列やハッシュへ変換します。`JSON.pretty_generate` は Ruby の配列やハッシュを JSON 文字列へ変換します。読み込みと書き込みで向きが逆になります。

`JSON.pretty_generate` を使うと、保存された JSON を人間が読みやすくなります。登録後に `data/movies.json` を開いて確認する教材では、1 行に詰め込まれた JSON よりも扱いやすくなります。

この章の保存方法は、毎回ファイル全体を読み込み、配列を変更し、ファイル全体を書き戻す方法です。小さなローカル教材アプリとしては理解しやすい方法ですが、データが増えたり複数人が同時に使ったりする場合には限界があります。この限界は、第12章で振り返ります。

## タイトルを必須にする

映画図鑑では、タイトルが空の映画を登録できないようにします。HTML の `required` 属性を使うこともできますが、ブラウザ側の機能だけに頼ってはいけません。リクエストはブラウザ以外からも送れます。サーバー側でも確認します。

`POST /movies` を次のように変更します。

```ruby
post "/movies" do
  @movie = movie_params
  @errors = []

  if @movie["title"].strip.empty?
    @errors << "タイトルを入力してください"
    return erb :new
  end

  movies = load_movies
  movies << { "id" => SecureRandom.uuid }.merge(@movie)
  save_movies(movies)

  redirect "/movies"
end
```

`strip.empty?` は、空文字だけでなく、空白だけの入力も空として扱うために使っています。

タイトルが空のときは、保存しません。リダイレクトもしません。`@errors` にメッセージを入れ、登録フォームをもう一度表示します。

タイトルが入っているときは、現在の映画配列を読み込み、UUID 付きの映画を追加し、JSON ファイルへ保存します。最後に `redirect "/movies"` で一覧画面へ移動します。

ここではまだ、このリダイレクトを PRG という名前では説明しません。まずは「保存後に別の URL へ移動するレスポンス」として使います。なぜ状態を変えるリクエストの後にこの形にするのか、リダイレクトが再送信をどう防ぐのかは、第8章で扱います。

## 入力済みの値をフォームに戻す

タイトルが空だったとき、フォームを空に戻してしまうと、読者は入力した監督名や紹介文をもう一度入力しなければなりません。エラー時には、入力済みの値をフォームに戻します。

フォームへ入力値を戻す前に、利用者入力を安全に表示するための `h` ヘルパーを追加します。

```ruby
require "rack/utils"

helpers do
  def h(value)
    Rack::Utils.escape_html(value)
  end
end
```

Sinatra の ERB では、`<%= %>` に書いた値が自動で HTML エスケープされるとは考えません。`h` は、HTML として特別な意味を持つ文字を、文字として表示できる形へ変換します。例えば `<` は `&lt;` のような文字参照になります。

`GET /movies/new` では、空の映画データとエラー配列を用意します。

```ruby
get "/movies/new" do
  @movie = {}
  @errors = []
  erb :new
end
```

`views/new.erb` のフォームでは、`@movie` の値を `value` 属性や `textarea` の中身へ入れます。

```erb
<input type="text" id="title" name="title" value="<%= h(@movie["title"]) %>">
```

`textarea` は `value` 属性ではなく、開始タグと終了タグの間に値を書きます。

```erb
<textarea id="description" name="description" rows="5"><%= h(@movie["description"]) %></textarea>
```

`select` は、選ばれていた項目に `selected` を付けます。

```erb
<option value="ドラマ" <%= "selected" if @movie["genre"] == "ドラマ" %>>ドラマ</option>
```

エラーメッセージもフォームの上に表示します。

```erb
<% unless @errors.empty? %>
  <div class="error-messages" role="alert">
    <p>入力内容を確認してください。</p>
    <ul>
      <% @errors.each do |error| %>
        <li><%= h(error) %></li>
      <% end %>
    </ul>
  </div>
<% end %>
```

## 保存した値を一覧に表示する

一覧画面でも `h` を使います。

```erb
<td><%= h(movie["title"]) %></td>
<td><%= h(movie["year"]) %></td>
<td><%= h(movie["genre"]) %></td>
```

XSS の危険を実際に見るのは第9章です。この章では、保存した利用者入力を表示する時点から、安全な表示の形を使っておきます。

## 登録後の動きを Network タブで見る

サーバーを起動し、`/movies/new` から新しい映画を登録してください。

登録に成功すると、ブラウザは一覧画面へ移動します。Network タブでは、次の流れを確認できます。

```text
POST /movies
GET /movies
```

`POST /movies` のレスポンスは、HTML そのものではなく、別の URL へ移動する指示です。この環境では `303 See Other` として確認できます。その指示を受けて、ブラウザが `GET /movies` を送ります。

次に、タイトルを空にして送信してください。この場合は保存されず、登録フォームが表示されます。Network タブでは、リダイレクト後の `GET /movies` は発生しません。`POST /movies` のレスポンスとして、エラーメッセージ付きのフォームが返ります。

`data/movies.json` も確認してください。登録に成功した映画だけが、UUID 付きで追加されています。タイトル空欄の送信では、JSON ファイルは変わりません。

## この章の完成コード

この章の最後の `app.rb` は次の形です。

```ruby
# frozen_string_literal: true

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
  File.write(MOVIES_FILE, "#{JSON.pretty_generate(movies)}\n")
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
  @movie = {}
  @errors = []
  erb :new
end

post "/movies" do
  @movie = movie_params
  @errors = []

  if @movie["title"].strip.empty?
    @errors << "タイトルを入力してください"
    return erb :new
  end

  movies = load_movies
  movies << { "id" => SecureRandom.uuid }.merge(@movie)
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

`views/new.erb` では、エラーメッセージと入力済みの値を表示します。

```erb
<h1>映画登録</h1>

<p>登録したい映画の情報を入力します。</p>

<% unless @errors.empty? %>
  <div class="error-messages" role="alert">
    <p>入力内容を確認してください。</p>
    <ul>
      <% @errors.each do |error| %>
        <li><%= h(error) %></li>
      <% end %>
    </ul>
  </div>
<% end %>

<form class="movie-form" action="/movies" method="post">
  <div class="form-field">
    <label for="title">タイトル</label>
    <input type="text" id="title" name="title" value="<%= h(@movie["title"]) %>">
  </div>

  <div class="form-field">
    <label for="director">監督</label>
    <input type="text" id="director" name="director" value="<%= h(@movie["director"]) %>">
  </div>

  <div class="form-field">
    <label for="year">公開年</label>
    <input type="text" id="year" name="year" value="<%= h(@movie["year"]) %>">
  </div>

  <div class="form-field">
    <label for="genre">ジャンル</label>
    <select id="genre" name="genre">
      <option value="アクション" <%= "selected" if @movie["genre"] == "アクション" %>>アクション</option>
      <option value="コメディ" <%= "selected" if @movie["genre"] == "コメディ" %>>コメディ</option>
      <option value="ドラマ" <%= "selected" if @movie["genre"] == "ドラマ" %>>ドラマ</option>
      <option value="ホラー" <%= "selected" if @movie["genre"] == "ホラー" %>>ホラー</option>
      <option value="SF" <%= "selected" if @movie["genre"] == "SF" %>>SF</option>
      <option value="アニメーション" <%= "selected" if @movie["genre"] == "アニメーション" %>>アニメーション</option>
      <option value="その他" <%= "selected" if @movie["genre"] == "その他" %>>その他</option>
    </select>
  </div>

  <div class="form-field">
    <label for="description">紹介文</label>
    <textarea id="description" name="description" rows="5"><%= h(@movie["description"]) %></textarea>
  </div>

  <div class="form-actions">
    <button type="submit">登録する</button>
    <a href="/movies">一覧へ戻る</a>
  </div>
</form>
```

エラーメッセージのために、CSS も追加します。

```css
.error-messages {
  max-width: 640px;
  border: 1px solid #b3261e;
  border-radius: 4px;
  padding: 12px 16px;
  color: #5f1a16;
  background: #fff0ee;
}

.error-messages p {
  margin: 0 0 8px;
  font-weight: 700;
}

.error-messages ul {
  margin: 0;
  padding-left: 24px;
}
```

## 確認しよう

1. `/movies/new` からタイトルを入れて映画を登録する。
2. Network タブで `POST /movies` の後に `GET /movies` が発生していることを確認する。
3. 送信前後で `data/movies.json` を開き、UUID 付きの映画が追加されたことを確認する。
4. タイトルを空にして送信し、エラーメッセージが表示され、入力済みの監督名や紹介文が残ることを確認する。
5. タイトル空欄の送信では、`data/movies.json` が変わらないことを確認する。

## 考えてみよう

- なぜタイトルや配列の位置ではなく、UUID を ID にするのでしょうか。
- なぜ保存用 JSON を `public/` に置かないのでしょうか。
- なぜ入力チェックを HTML の `required` 属性だけに任せないのでしょうか。
- 保存後に直接 HTML を返すのではなく、なぜ別の URL へ移動させているのでしょうか。

## さらに学ぶ

- ◎ Ruby JSON: <https://docs.ruby-lang.org/ja/latest/library/json.html>
- ◎ Ruby SecureRandom: <https://docs.ruby-lang.org/ja/latest/library/securerandom.html>
- ◎ Rack Utils: <https://rack.github.io/rack/main/Rack/Utils.html>
- ◎ Sinatra: <https://sinatrarb.com/intro.html>
- ◎ MDN HTTP リダイレクト: <https://developer.mozilla.org/ja/docs/Web/HTTP/Redirections>
