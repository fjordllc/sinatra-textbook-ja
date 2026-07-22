# 第3章 HTML をレスポンスとして返す

第2章では、`GET /movies` に対して「映画図鑑」という文字列を返しました。ブラウザには表示されましたが、まだ見出しも一覧もありません。

この章では、レスポンス本文として HTML を返します。最初は短い HTML を Ruby の文字列として返し、その後で ERB テンプレートへ移します。最後に、Ruby の配列とハッシュで用意した映画データを ERB で HTML に埋め込み、共通のレイアウトを使った映画一覧を表示します。

この章は、第2章で作った `sinatra-movies` ディレクトリでそのまま続けます。第3章から読み始める場合は、第2章の最後（2.11）に示した `app.rb` を用意した状態から始めてください。

## 3.1 文字列ではなく HTML を返す

第2章の `app.rb` は、次の状態で終わりました。

```ruby
require "sinatra"

get "/" do
  redirect "/movies"
end

get "/movies" do
  "映画図鑑"
end
```

`"映画図鑑"` は、レスポンス本文になる文字列です。レスポンス本文に HTML を入れれば、ブラウザはその HTML を解釈して表示します。

試しに、`get "/movies"` のブロックを次のように変更します。

```ruby
get "/movies" do
  "<h1>映画図鑑</h1>"
end
```

アプリを再起動し、Chrome で次の URL を開きます。

```text
http://localhost:4567/movies
```

ブラウザには、大きな見出しとして「映画図鑑」と表示されます。Network パネルで `GET /movies` を選び、Response を見ると、次の HTML がレスポンス本文として届いていることを確認できます。

```html
<h1>映画図鑑</h1>
```

ここで重要なのは、ブラウザが Ruby のコードを読んでいるわけではない、という点です。Ruby のコードはサーバー側で実行され、ブラウザには実行結果の HTML が返ります。

ただし、HTML が少し長くなるだけで、Ruby の文字列として書くのは読みにくくなります。

```ruby
get "/movies" do
  "<h1>映画図鑑</h1><ul><li>月面喫茶</li><li>北風のリズム</li></ul>"
end
```

これは読みにくさを確認するための一時的な例です。最終的なコードには残しません。HTML は HTML として書けるファイルへ分けましょう。そのために ERB を使います。

## 3.2 `views/` と ERB テンプレート

ERB は、HTML の中に Ruby の処理を埋め込めるテンプレートです。Sinatra では、`views/` ディレクトリに置いた ERB ファイルを `erb` メソッドで表示できます。

`sinatra-movies` ディレクトリに `views` ディレクトリを作り、その中に `index.erb` を作ります。

```text
.
├── app.rb
└── views/
    └── index.erb
```

`views/index.erb` に、次の HTML を書きます。

```erb
<h1>映画図鑑</h1>
```

次に、`app.rb` の `get "/movies"` を変更します。

```ruby
get "/movies" do
  erb :index
end
```

`erb :index` は、`views/index.erb` を読み込み、その結果をレスポンス本文として返します。`:index` は Ruby のシンボルです。Sinatra の `erb` メソッドでは、テンプレート名をシンボルで指定します。

アプリを再起動して `/movies` を開くと、先ほどと同じように「映画図鑑」が見出しとして表示されます。見た目は同じですが、HTML を Ruby の文字列から `views/index.erb` へ移せました。

ERB では、次の二つの書き方をよく使います。

| ERB の書き方 | 役割 |
| --- | --- |
| `<% Ruby の処理 %>` | Ruby の処理を実行する。結果は画面に出力しない。 |
| `<%= Ruby の式 %>` | Ruby の式を評価し、結果を HTML に出力する。 |

この章では、映画の配列を繰り返すために `<% %>` を使い、映画のタイトルや公開年を出力するために `<%= %>` を使います。

## 3.3 `layout.erb` に共通の HTML 構造を書く

今の `views/index.erb` には、`h1` だけがあります。しかし、HTML 文書としては本来、`doctype`、`html`、`head`、`body` などの外枠も必要です。

それらを各画面の ERB に毎回書くと、画面が増えたときに同じ HTML が重複します。Sinatra では、`views/layout.erb` を用意すると、既定で各テンプレートの外側に使われます。

`views/layout.erb` を作り、次の内容を書きます。

```erb
<!doctype html>
<html lang="ja">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>映画図鑑</title>
  </head>
  <body>
    <header>
      <a href="/movies">映画図鑑</a>
    </header>

    <main>
      <%= yield %>
    </main>
  </body>
</html>
```

`<%= yield %>` の位置に、`views/index.erb` の内容が入ります。`layout.erb` は HTML 文書全体の共通構造を持ち、`index.erb` は映画一覧画面に固有の中身だけを持ちます。

`views/index.erb` には、`html`、`head`、`body` を書きません。これらは `layout.erb` の役割です。個別ビューに同じ外枠を書くと、画面ごとに HTML 文書が重複し、後から直す場所も増えてしまいます。

アプリを再起動して `/movies` を開き、Network パネルで Response を確認してください。レスポンス本文には、`layout.erb` の外枠と `index.erb` の見出しが組み合わさった HTML が返っています。

## 3.4 映画一覧の静的な HTML を書く

映画図鑑なので、一覧画面には映画を並べます。まずは Ruby のデータを使わず、静的な HTML として書きます。

`views/index.erb` を次のように変更します。

```erb
<h1>映画一覧</h1>

<p>登録されている映画を一覧で表示します。</p>

<table>
  <thead>
    <tr>
      <th scope="col">タイトル</th>
      <th scope="col">公開年</th>
      <th scope="col">ジャンル</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>月面喫茶</td>
      <td>2042</td>
      <td>SF</td>
    </tr>
    <tr>
      <td>北風のリズム</td>
      <td>2038</td>
      <td>ドラマ</td>
    </tr>
  </tbody>
</table>
```

ここでは、一覧にタイトル、公開年、ジャンルだけを表示します。映画データには監督や紹介文もありますが、一覧画面にすべての情報を詰め込む必要はありません。

一覧画面は、複数の映画を見比べて目的の映画へ進むための入口です。監督や紹介文まで含む詳しい情報は、後の章で作る詳細画面に表示します。一覧と詳細で情報量を分けると、画面ごとの役割がはっきりします。

## 3.5 Ruby の配列とハッシュから表示する

静的な HTML だけでは、映画が増えるたびに `tr` を手で増やす必要があります。Web アプリケーションでは、サーバー側のデータから HTML を組み立てます。

この章ではまだファイル保存をしません。まずは `app.rb` の中に、映画の配列を用意します。

ここで、Ruby の配列とハッシュを短く振り返ります。配列は、複数の値を順番にまとめるためのものです。ハッシュは、キーと値の組み合わせで一つのデータを表します。これから書くコードでは、映画 1 件をハッシュで表し、そのハッシュを配列に入れて複数の映画をまとめます。

`require "sinatra"` の下、ルート定義より前に、次のコードを追加します。この章では、アプリ起動時に用意する仮の映画データとして扱います。

```ruby
movies = [
  {
    "title" => "月面喫茶",
    "director" => "山田アキラ",
    "year" => "2042",
    "genre" => "SF",
    "description" => "月面にある小さな喫茶店を舞台にした物語。"
  },
  {
    "title" => "北風のリズム",
    "director" => "佐藤ミナ",
    "year" => "2038",
    "genre" => "ドラマ",
    "description" => "雪の町で古い楽器を修理する人々を描く。"
  },
  {
    "title" => "週末ロケット",
    "director" => "鈴木トオル",
    "year" => "2040",
    "genre" => "コメディ",
    "description" => "町工場の仲間たちが小さなロケット作りに挑む。"
  }
]
```

外側の `[` と `]` が配列です。その中にある一組ずつの `{` と `}` が、映画 1 件を表すハッシュです。例えば `"title" => "月面喫茶"` は、`"title"` というキーと `"月面喫茶"` という値の組み合わせです。この映画の配列全体を、`movies` という変数に代入しています。

続いて、`get "/movies"` を次のように変更します。

```ruby
get "/movies" do
  @movies = movies
  erb :index
end
```

`@movies` はインスタンス変数です。Sinatra のルート内で代入したインスタンス変数は、ERB テンプレートから参照できます。ここでは、`app.rb` で用意した映画の配列を `views/index.erb` で使えるようにしています。

`views/index.erb` の `tbody` を、次のように変更します。

```erb
<tbody>
  <% @movies.each do |movie| %>
    <tr>
      <td><%= movie["title"] %></td>
      <td><%= movie["year"] %></td>
      <td><%= movie["genre"] %></td>
    </tr>
  <% end %>
</tbody>
```

`<% @movies.each do |movie| %>` は、映画の件数分だけ Ruby の繰り返しを実行します。この行自体は HTML に出力しないため、`<% %>` を使います。

`<%= movie["title"] %>` は、映画ハッシュの `"title"` に対応する値を HTML に出力します。値を画面に出すため、`<%= %>` を使います。

この章の映画データは、教材の中で用意した固定データです。そのため、ここでは値をそのまま出力しています。後の章で利用者が入力した値を表示するときは、ブラウザに HTML として解釈されないようエスケープする必要があります。安全な表示の方法は第5章で扱います。

アプリを再起動し、`/movies` を開いてください。3 件の映画が一覧に表示されます。`movies` の配列に 1 件追加して再起動すると、`views/index.erb` の `tr` を増やさなくても行が増えます。

ERB の書き間違いで `500 Internal Server Error` が表示された場合は、ブラウザだけでなく、アプリを起動しているターミナルのログも見てください。詳しいデバッグ方法は第11章で扱います。

## 3.6 映画が持つ 5 つの情報

映画図鑑で扱う映画は、次の属性を持ちます。

| キー | 画面上の名前 | 役割 |
| --- | --- | --- |
| `title` | タイトル | 映画のタイトル。 |
| `director` | 監督 | 監督名。 |
| `year` | 公開年 | 公開された年。 |
| `genre` | ジャンル | 映画のジャンル。 |
| `description` | 紹介文 | 映画についての短い説明。 |

これらは、後の章で利用者がフォームから入力する項目でもあります。

この章の一覧画面では、`title`、`year`、`genre` だけを使います。`director` と `description` は、後の詳細画面で使います。ここでは、一覧に必要な情報だけを ERB へ渡して表示する流れに集中します。

## 3.7 `public/` に CSS を置く

今の一覧は HTML としては表示できますが、画面の区切りが分かりにくい状態です。最低限の CSS を追加します。

Sinatra では、既定で `public/` ディレクトリに置いた静的ファイルをブラウザへ返せます。ここでいう静的ファイルとは、Sinatra のルートでリクエストごとに組み立てるのではなく、そのまま配信するファイルです。CSS や画像などが該当します。

次の場所に CSS ファイルを作ります。

```text
public/
└── stylesheets/
    └── application.css
```

`views/layout.erb` の `head` に、CSS を読み込む `link` 要素を追加します。

```erb
<link rel="stylesheet" href="/stylesheets/application.css">
```

ブラウザはこの `href` を見て、CSS ファイルを取得するための新しいリクエストを送ります。ファイルは `public/stylesheets/application.css` にありますが、URL は `/stylesheets/application.css` です。`public` というディレクトリ名は URL に含めません。

Chrome で次の URL を開くと、CSS ファイルの内容を直接確認できます。

```text
http://localhost:4567/stylesheets/application.css
```

これは、`public/` がブラウザから直接参照できるファイルの置き場所であることを意味します。後の章で扱う保存用 JSON は、`public/` には置きません。利用者が登録したデータを、ブラウザから直接読める場所へ置かないためです。保存データは第5章で `data/movies.json` に置きます。

## 3.8 最小限の CSS を追加する

`public/stylesheets/application.css` に、次の CSS を書きます。

```css
body {
  margin: 0;
  color: #222222;
  font-family: system-ui, sans-serif;
  line-height: 1.7;
  background: #f7f7f4;
}

.site-header {
  border-bottom: 1px solid #dddddd;
  background: #ffffff;
}

.site-title {
  display: inline-block;
  padding: 16px 24px;
  color: #1f4f5f;
  font-size: 20px;
  font-weight: 700;
  text-decoration: none;
}

.site-title:hover {
  text-decoration: underline;
}

.site-main {
  width: min(100% - 32px, 880px);
  margin: 32px auto;
}

h1 {
  margin: 0 0 16px;
  font-size: 28px;
  line-height: 1.3;
}

.table-scroll {
  overflow-x: auto;
}

.movie-table {
  width: 100%;
  margin-top: 24px;
  border-collapse: collapse;
  background: #ffffff;
  min-width: 520px;
}

.movie-table th,
.movie-table td {
  padding: 12px 14px;
  border: 1px solid #dddddd;
  text-align: left;
  vertical-align: top;
}

.movie-table th {
  background: #edf3f4;
}
```

`views/layout.erb` の `header` と `main` に、CSS 用のクラスを付けます。

```erb
<header class="site-header">
  <a class="site-title" href="/movies">映画図鑑</a>
</header>

<main class="site-main">
  <%= yield %>
</main>
```

`views/index.erb` の `table` にもクラスを付け、外側を `div` で囲みます。

```erb
<div class="table-scroll">
  <table class="movie-table">
    ...
  </table>
</div>
```

この章の CSS は、デザインを深く学ぶためのものではありません。一覧、本文、ナビゲーションの区切りが分かり、表の項目を読みやすくするための最小限の指定です。

## 3.9 Network パネルで HTML と CSS を見る

アプリを再起動し、`/movies` を開きます。Network パネルを開いた状態で再読み込みすると、少なくとも次の二つのリクエストが見えます。

| リクエスト | 役割 |
| --- | --- |
| `GET /movies` | Sinatra のルートが処理し、HTML を返す。 |
| `GET /stylesheets/application.css` | `public/` にある CSS ファイルを返す。 |

`GET /movies` を選び、Headers の `Content-Type` と Response を確認します。`Content-Type` には、たとえば `text/html;charset=utf-8` のように `text/html` を含む値が表示されます。Response には、`layout.erb` と `index.erb` から作られた HTML が入っています。

次に `GET /stylesheets/application.css` を選びます。こちらの `Content-Type` には `text/css` を含む値が表示され、Response には CSS の内容が入っています。HTML の中に CSS ファイルの中身が埋め込まれているのではありません。ブラウザは、HTML の `link` 要素を見つけて、CSS ファイルを取得するための別の `GET` リクエストを送っています。

第2章では `GET /movies` が短い文字列を返していました。この章では、同じ `GET /movies` が HTML 文書を返すようになりました。URL とルートの対応は同じでも、ルートの処理を変えることでレスポンス本文の内容が変わります。

## 3.10 この章のコードを確認する

この章の最後に、ファイルの役割を整理します。

| ファイル | 役割 |
| --- | --- |
| `app.rb` | ルートを定義し、映画データを `@movies` としてテンプレートへ渡す。 |
| `views/layout.erb` | HTML 文書全体の共通構造を持つ。 |
| `views/index.erb` | 映画一覧画面に固有の HTML を組み立てる。 |
| `public/stylesheets/application.css` | ブラウザから直接取得される CSS を置く。 |

章終了時点の `app.rb` は次の状態です。

```ruby
require "sinatra"

movies = [
  {
    "title" => "月面喫茶",
    "director" => "山田アキラ",
    "year" => "2042",
    "genre" => "SF",
    "description" => "月面にある小さな喫茶店を舞台にした物語。"
  },
  {
    "title" => "北風のリズム",
    "director" => "佐藤ミナ",
    "year" => "2038",
    "genre" => "ドラマ",
    "description" => "雪の町で古い楽器を修理する人々を描く。"
  },
  {
    "title" => "週末ロケット",
    "director" => "鈴木トオル",
    "year" => "2040",
    "genre" => "コメディ",
    "description" => "町工場の仲間たちが小さなロケット作りに挑む。"
  }
]

get "/" do
  redirect "/movies"
end

get "/movies" do
  @movies = movies
  erb :index
end
```

`views/layout.erb` は次の状態です。

```erb
<!doctype html>
<html lang="ja">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>映画図鑑</title>
    <link rel="stylesheet" href="/stylesheets/application.css">
  </head>
  <body>
    <header class="site-header">
      <a class="site-title" href="/movies">映画図鑑</a>
    </header>

    <main class="site-main">
      <%= yield %>
    </main>
  </body>
</html>
```

`views/index.erb` は次の状態です。

```erb
<h1>映画一覧</h1>

<p>登録されている映画を一覧で表示します。</p>

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
          <td><%= movie["title"] %></td>
          <td><%= movie["year"] %></td>
          <td><%= movie["genre"] %></td>
        </tr>
      <% end %>
    </tbody>
  </table>
</div>
```

`public/stylesheets/application.css` は次の状態です。

```css
body {
  margin: 0;
  color: #222222;
  font-family: system-ui, sans-serif;
  line-height: 1.7;
  background: #f7f7f4;
}

.site-header {
  border-bottom: 1px solid #dddddd;
  background: #ffffff;
}

.site-title {
  display: inline-block;
  padding: 16px 24px;
  color: #1f4f5f;
  font-size: 20px;
  font-weight: 700;
  text-decoration: none;
}

.site-title:hover {
  text-decoration: underline;
}

.site-main {
  width: min(100% - 32px, 880px);
  margin: 32px auto;
}

h1 {
  margin: 0 0 16px;
  font-size: 28px;
  line-height: 1.3;
}

.table-scroll {
  overflow-x: auto;
}

.movie-table {
  width: 100%;
  margin-top: 24px;
  border-collapse: collapse;
  background: #ffffff;
  min-width: 520px;
}

.movie-table th,
.movie-table td {
  padding: 12px 14px;
  border: 1px solid #dddddd;
  text-align: left;
  vertical-align: top;
}

.movie-table th {
  background: #edf3f4;
}
```

`app.rb` は、リクエストに合うルートを選び、表示に使うデータを用意します。`views/index.erb` は、そのデータを使って映画一覧の HTML を組み立てます。`views/layout.erb` は、全画面に共通する HTML 文書の外枠を担当します。

最後に、自分の言葉で確認してみてください。`app.rb`、`views/layout.erb`、`views/index.erb` は、それぞれ何を担当しているでしょうか。

次章では、表示するだけでなく、ブラウザから映画の情報を送るフォームを作ります。

## さらに学ぶ

この章では、Sinatra の ERB テンプレート、レイアウト、静的ファイル配信を必要な範囲だけ使いました。より詳しい仕組みを知りたい場合は、次の観点で調べると理解を広げられます。

- Sinatra のテンプレート機能では、テンプレートの場所やレイアウトの指定を変更できます。
- ERB には、この章で扱った `<% %>` と `<%= %>` 以外の記法もあります。
- CSS は HTML とは別のリクエストで取得され、ブラウザが HTML と組み合わせて表示します。

## 参考資料

- ◎ Sinatra 公式 Views / Templates: <https://sinatrarb.com/intro.html#Views%20/%20Templates>
- ◎ Sinatra 公式 Static Files: <https://sinatrarb.com/intro.html#Static%20Files>
- ◎ Ruby 公式 ERB: <https://docs.ruby-lang.org/en/4.0/ERB.html>
- ○ MDN Content-Type: <https://developer.mozilla.org/ja/docs/Web/HTTP/Headers/Content-Type>
- ○ MDN CSS の第一歩: <https://developer.mozilla.org/ja/docs/Learn/CSS/First_steps>
