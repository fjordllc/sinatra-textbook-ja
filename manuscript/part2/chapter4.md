# 第4章 フォームはリクエストを作る

第3章では、Ruby の配列とハッシュから映画一覧の HTML を作りました。今の映画図鑑は、サーバーが用意した映画を表示できます。しかし、ブラウザから新しい映画の情報を送る方法はまだありません。

この章では、映画を登録するためのフォームを作ります。ここでの目的は、保存ではありません。フォームの HTML がどのような HTTP リクエストを作り、その値が Sinatra の `params` にどう届くのかを確認することです。

**この章のゴール:** 映画登録フォームを作り、フォームの HTML から送信先、HTTP メソッド、送信されるキーと値を説明できる。

この章は、第3章から続けて同じ `sinatra-movies` ディレクトリで進めます。第4章から読み始める場合は、第3章の最後（3.10）に示したコードを用意した状態から始めてください。

## 4.1 登録画面 `GET /movies/new`

まず、映画一覧から登録画面へ移動できるようにします。`views/index.erb` の説明文の下に、次のリンクを追加します。

```erb
<p>
  <a class="button-link" href="/movies/new">新しい映画を登録</a>
</p>
```

見た目はボタンのようにしますが、HTML としてはリンクです。リンクをクリックすると、ブラウザは `GET /movies/new` を送ります。まだ対応するルートがないため、このままでは登録画面を表示できません。

`app.rb` に、次のルートを追加します。

```ruby
get "/movies/new" do
  erb :new
end
```

`views/new.erb` を作り、まずは見出しだけを書きます。

```erb
<h1>映画登録</h1>

<p>登録したい映画の情報を入力します。</p>
```

アプリを再起動し、`/movies` を開いて「新しい映画を登録」をクリックします。`/movies/new` で登録画面が表示されます。Network パネルでは、リンクのクリックによって `GET /movies/new` が送られ、`200 OK` の HTML が返ることを確認してください。

ここでは、リンクによる画面移動なので `GET` です。これから作るフォーム送信では、入力した値をサーバーへ送るために `POST` を使います。

## 4.2 `form` の `action` と `method`

フォームは、ブラウザに HTTP リクエストを作らせるための HTML です。最小のフォームを見てみます。

```erb
<form action="/movies" method="post">
  <label for="title">タイトル</label>
  <input type="text" id="title" name="title">

  <button type="submit">送信内容を確認</button>
</form>
```

`form` の二つの属性が、送信されるリクエストを決めます。

| 属性 | 役割 | このフォームでの意味 |
| --- | --- | --- |
| `action` | 送信先のパス | `/movies` に送る |
| `method` | 送信に使う HTTP メソッド | `POST` で送る |

HTML では `method="post"` と小文字で書いています。HTTP メソッドとして説明するときは `POST` と大文字で書きます。

このフォームの送信ボタンを押すと、ブラウザは次のようなリクエストを作ります。

```http
POST /movies HTTP/1.1
Host: localhost:4567
Content-Type: application/x-www-form-urlencoded

title=月面喫茶
```

実際のリクエストには、ほかにもヘッダーが含まれます。ここでは、フォームの `action`、`method`、入力欄の値がリクエストに反映されることに注目してください。

## 4.3 `name` が `params` のキーになる

フォーム部品には、`id` と `name` がよく出てきます。

```erb
<label for="title">タイトル</label>
<input type="text" id="title" name="title">
```

`id` は、HTML の中で要素を識別するための属性です。ここでは `label` の `for="title"` と `input` の `id="title"` が対応し、ラベルと入力欄を結び付けています。

`name` は、フォーム送信時のキーを決める属性です。`name="title"` の入力欄に「月面喫茶」と入力して送信すると、Sinatra では次のように取り出せます。

```ruby
params["title"]
```

`params` は、Sinatra が用意するパラメーターの入れ物です。ハッシュのようにキーを指定して値を取り出せます。本書では、フォームから送られた値を `params["title"]` のように文字列キーで扱います。

ここで混同しやすいのは、`label` の表示文字列や `id` が `params` のキーになるわけではない、という点です。キーを決めるのは `name` です。

## 4.4 映画の登録フォーム

映画図鑑では、利用者が次の 5 項目を入力します。

| 画面上の項目 | フォーム部品 | `name` |
| --- | --- | --- |
| タイトル | `input type="text"` | `title` |
| 監督 | `input type="text"` | `director` |
| 公開年 | `input type="text"` | `year` |
| ジャンル | `select` | `genre` |
| 紹介文 | `textarea` | `description` |

`views/new.erb` を次の内容に変更します。

```erb
<h1>映画登録</h1>

<p>登録したい映画の情報を入力します。</p>

<form class="movie-form" action="/movies" method="post">
  <div class="form-field">
    <label for="title">タイトル</label>
    <input type="text" id="title" name="title">
  </div>

  <div class="form-field">
    <label for="director">監督</label>
    <input type="text" id="director" name="director">
  </div>

  <div class="form-field">
    <label for="year">公開年</label>
    <input type="text" id="year" name="year">
  </div>

  <div class="form-field">
    <label for="genre">ジャンル</label>
    <select id="genre" name="genre">
      <option value="アクション">アクション</option>
      <option value="コメディ">コメディ</option>
      <option value="ドラマ">ドラマ</option>
      <option value="ホラー">ホラー</option>
      <option value="SF">SF</option>
      <option value="アニメーション">アニメーション</option>
      <option value="その他">その他</option>
    </select>
  </div>

  <div class="form-field">
    <label for="description">紹介文</label>
    <textarea id="description" name="description" rows="5"></textarea>
  </div>

  <div class="form-actions">
    <button type="submit">送信内容を確認</button>
    <a href="/movies">一覧へ戻る</a>
  </div>
</form>
```

`select` の選択肢は `option` で作ります。この章では、画面に表示する日本語と送信される値を同じにしています。たとえば「コメディ」を選ぶと、`genre` の値として `"コメディ"` が送られます。このフォームでは、最初の選択肢である「アクション」が初期状態で選ばれています。

`textarea` は複数行の入力欄です。`input` と違い、初期値を書く場合は `value` 属性ではなく、開始タグと終了タグの間に書きます。この章では空のままにしておきます。

まだ入力チェックはしません。空欄のまま送るとどう届くのかも、フォームの仕組みを理解する材料になります。タイトル必須の入力チェックは第5章で扱います。

## 4.5 `POST /movies` で送信値を確認する

今のまま送信ボタンを押すと、ブラウザは `POST /movies` を送ります。しかし、`app.rb` にはまだ `POST /movies` に対応するルートがありません。

`app.rb` に次のルートを追加します。

```ruby
post "/movies" do
  content_type :text
  params.inspect
end
```

`post "/movies"` は、`POST /movies` に対応するルートです。`get "/movies"` と同じパスですが、HTTP メソッドが違うため別のルートとして扱われます。

`params.inspect` は、`params` の中身を確認しやすい文字列にします。この章では、送信された値が Sinatra に届いたことを確認するためだけに使います。まだ映画は保存されません。この `post "/movies"` は第4章だけの確認用コードで、第5章で保存処理とリダイレクトに置き換えます。

`content_type :text` は、レスポンスを HTML ではなくテキストとして返す指定です。第5章で安全な表示を扱う前に、利用者が入力した値を HTML として返すことを避けるため、この章の確認用レスポンスではテキストとして表示します。

アプリを再起動し、`/movies/new` でフォームを送信してみます。たとえば、次のように入力します。

| 項目 | 入力例 |
| --- | --- |
| タイトル | 星降る駅 |
| 監督 | 田中ユイ |
| 公開年 | 2041 |
| ジャンル | ドラマ |
| 紹介文 | 夜行列車の終着駅を舞台にした物語。 |

送信後、ブラウザには次のようなテキストが表示されます。

```text
{"title" => "星降る駅", "director" => "田中ユイ", "year" => "2041", "genre" => "ドラマ", "description" => "夜行列車の終着駅を舞台にした物語。"}
```

これは完成画面ではありません。フォームから送られた値を確認するための一時的な表示です。次章で、この値を映画データとして保存する処理へ進めます。

`params.inspect` の表示順は重要ではありません。注目するのは、`title`、`director`、`year`、`genre`、`description` というキーと、入力した値が届いていることです。

タイトルを空欄で送ると、`"title" => ""` のように空文字として届きます。空文字を保存してよいかどうかは、サーバー側で確認する必要があります。タイトル必須の入力チェックは第5章で扱います。

確認用レスポンスからフォームへ戻るには、ブラウザの戻るボタンを使ってください。第5章では、送信後に別の画面へ移動する処理へ変えます。

## 4.6 Network パネルで Form Data を見る

フォーム送信は、画面だけでなく Network パネルでも確認します。

Chrome で `/movies/new` を開き、Network パネルを開いた状態でフォームを送信してください。リクエスト一覧から `movies` を選びます。確認する項目は次のとおりです。

| 見る場所 | 確認すること |
| --- | --- |
| Headers | Request Method が `POST` である |
| Headers | Request URL のパスが `/movies` である |
| Headers | Status Code が `200 OK` である |
| Headers | Request Headers に `Content-Type: application/x-www-form-urlencoded` が含まれる |
| Headers | Response Headers に `Content-Type: text/plain` が含まれる |
| Payload | Form Data に `title`、`director`、`year`、`genre`、`description` がある |
| Response | `params.inspect` のテキストが返っている |

Network パネルの表示名は Chrome のバージョンによって少し変わることがあります。Form Data が見つからない場合は、選択した `POST /movies` の Payload を確認してください。

フォームの HTML と Network パネルを対応させると、次のようになります。

| HTML | Network パネル / Sinatra |
| --- | --- |
| `<form action="/movies">` | Request URL が `/movies` |
| `<form method="post">` | Request Method が `POST` |
| `name="title"` | Form Data と `params` のキー `title` |
| 入力したタイトル | Form Data と `params["title"]` の値 |

ここで、`id="title"` やラベルの「タイトル」という文字が送信キーになるわけではないことをもう一度確認してください。送信キーは `name="title"` で決まります。

`POST` にしただけで、送信内容が秘密になるわけではありません。Network パネルを見れば、このように送信された値を確認できます。ここでは安全性ではなく、フォームがどのリクエストを作るのかを観察しています。

## 4.7 HTML フォームが直接送れるメソッドは GET と POST

HTTP リクエストとしてサーバーへ送る HTML フォームでは、`method` に `get` または `post` を指定するのが基本です。

`GET` は、情報の取得に使います。第4章の最初に作った `GET /movies/new` は、登録フォームを表示するためのリクエストです。

`POST` は、サーバーへデータを送るときに使います。この章の `POST /movies` は、映画フォームの値を送るリクエストです。まだ保存はしていませんが、送信の意味としては `POST` を使います。

後の章では、既存の映画を更新するために `PATCH`、削除するために `DELETE` を使います。ただし、HTML フォームは `PATCH` や `DELETE` を直接送れません。そのため、第7章で method override という仕組みを使います。

ここでは、次の区別を押さえてください。

| 操作 | この章で使う HTTP メソッド |
| --- | --- |
| 登録画面を表示する | `GET` |
| 登録フォームの値を送る | `POST` |

`POST` で送ったからといって、それだけでデータが保存されるわけではありません。保存するには、サーバー側で受け取った値をデータとして追加する処理が必要です。それを次章で作ります。

## 4.8 この章のコードを確認する

この章の最後に、追加したファイルとルートを確認します。

| 追加・変更したもの | 役割 |
| --- | --- |
| `GET /movies/new` | 映画登録フォームを表示する |
| `views/new.erb` | 映画登録フォームの HTML |
| `POST /movies` | フォームから送られた値を一時的に確認する |
| `views/index.erb` | 登録画面へのリンクを追加する |
| `public/stylesheets/application.css` | フォームの見た目を整える |

章終了時点の `app.rb` は次の状態です。

```ruby
# frozen_string_literal: true

require "sinatra"

movies = [
  {
    "id" => "b6f5e1c4-4b5f-4a7f-8f8f-3d9d3ef9d001",
    "title" => "月面喫茶",
    "director" => "山田アキラ",
    "year" => "2042",
    "genre" => "SF",
    "description" => "月面にある小さな喫茶店を舞台にした物語。"
  },
  {
    "id" => "b6f5e1c4-4b5f-4a7f-8f8f-3d9d3ef9d002",
    "title" => "北風のリズム",
    "director" => "佐藤ミナ",
    "year" => "2038",
    "genre" => "ドラマ",
    "description" => "雪の町で古い楽器を修理する人々を描く。"
  },
  {
    "id" => "b6f5e1c4-4b5f-4a7f-8f8f-3d9d3ef9d003",
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

get "/movies/new" do
  erb :new
end

post "/movies" do
  content_type :text
  params.inspect
end
```

この `post "/movies"` は第4章だけの確認用レスポンスです。第5章では、`params.inspect` を返すのではなく、受け取った値を映画データとして保存し、別の画面へ移動する処理へ置き換えます。

`views/index.erb` は次の状態です。

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
          <td><%= movie["title"] %></td>
          <td><%= movie["year"] %></td>
          <td><%= movie["genre"] %></td>
        </tr>
      <% end %>
    </tbody>
  </table>
</div>
```

`views/new.erb` は次の状態です。

```erb
<h1>映画登録</h1>

<p>登録したい映画の情報を入力します。</p>

<form class="movie-form" action="/movies" method="post">
  <div class="form-field">
    <label for="title">タイトル</label>
    <input type="text" id="title" name="title">
  </div>

  <div class="form-field">
    <label for="director">監督</label>
    <input type="text" id="director" name="director">
  </div>

  <div class="form-field">
    <label for="year">公開年</label>
    <input type="text" id="year" name="year">
  </div>

  <div class="form-field">
    <label for="genre">ジャンル</label>
    <select id="genre" name="genre">
      <option value="アクション">アクション</option>
      <option value="コメディ">コメディ</option>
      <option value="ドラマ">ドラマ</option>
      <option value="ホラー">ホラー</option>
      <option value="SF">SF</option>
      <option value="アニメーション">アニメーション</option>
      <option value="その他">その他</option>
    </select>
  </div>

  <div class="form-field">
    <label for="description">紹介文</label>
    <textarea id="description" name="description" rows="5"></textarea>
  </div>

  <div class="form-actions">
    <button type="submit">送信内容を確認</button>
    <a href="/movies">一覧へ戻る</a>
  </div>
</form>
```

第4章では、`public/stylesheets/application.css` に次の CSS を追加しました。

```css
a {
  color: #1f4f5f;
}

.button-link,
button {
  display: inline-block;
  border: 1px solid #1f4f5f;
  border-radius: 4px;
  padding: 8px 14px;
  color: #ffffff;
  font: inherit;
  text-decoration: none;
  background: #1f4f5f;
  cursor: pointer;
}

.button-link:hover,
button:hover {
  background: #173c48;
}

.movie-form {
  max-width: 640px;
  margin-top: 24px;
}

.form-field {
  margin-bottom: 18px;
}

.form-field label {
  display: block;
  margin-bottom: 6px;
  font-weight: 700;
}

.form-field input,
.form-field select,
.form-field textarea {
  box-sizing: border-box;
  width: 100%;
  border: 1px solid #c9c9c9;
  border-radius: 4px;
  padding: 8px 10px;
  font: inherit;
  background: #ffffff;
}

.form-field textarea {
  resize: vertical;
}

.form-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: center;
  margin-top: 24px;
}
```

最後に、次の問いを自分の言葉で確認してください。

- フォームの送信先は、どの HTML 属性で決まりますか。
- `params["genre"]` のキー `genre` は、どの HTML 属性から来ていますか。
- `POST /movies` のレスポンスに値が表示されても、まだ映画が保存されていないのはなぜですか。

次章では、`params.inspect` で確認した値を使い、JSON ファイルへ映画を保存します。

## さらに学ぶ

この章では、フォームから `POST` リクエストを送り、Sinatra の `params` で受け取るところまでを扱いました。さらに詳しく学ぶ場合は、次の観点を調べてください。

- フォームデータは既定で `application/x-www-form-urlencoded` という形式で送信されます。
- ファイルアップロードでは `multipart/form-data` を使いますが、本書では扱いません。
- HTML フォームの `method` には `dialog` もありますが、HTTP リクエスト送信としての `GET` / `POST` とは目的が異なります。

## 参考資料

- ◎ MDN `<form>`: <https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/form>
- ◎ MDN Sending form data: <https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Sending_and_retrieving_form_data>
- ◎ MDN Forms and buttons in HTML: <https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Structuring_content/HTML_forms>
- ◎ MDN POST request method: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Methods/POST>
- ○ Sinatra 公式: <https://sinatrarb.com/intro.html>
