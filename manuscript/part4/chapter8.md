# 第8章 リダイレクトは二つのリクエストをつなぐ

第7章までで、映画図鑑には一覧、詳細、登録、編集、削除が揃いました。登録、更新、削除の後には、すでに `redirect` を使っています。

この章では、これまで使ってきたリダイレクトを、POST、リダイレクト、GET を順につなぐ PRG パターンとして捉え直します。状態を変えるリクエストの後に直接 HTML を返さない理由を、実際の通信から確かめます。

## 先に使っていたリダイレクト

映画図鑑では、登録成功後に詳細画面へ移動しています。

```ruby
post "/movies" do
  # 省略

  redirect "/movies/#{movie["id"]}"
end
```

更新成功後も、詳細画面へ移動します。

```ruby
patch "/movies/:id" do
  # 省略

  redirect "/movies/#{movie["id"]}"
end
```

削除成功後は、削除した映画の詳細画面には戻れないため、一覧画面へ移動します。

```ruby
delete "/movies/:id" do
  # 省略

  redirect "/movies"
end
```

ここまでは「処理が終わった後に別の画面へ移動するための仕組み」として使ってきました。この章では、リダイレクトが HTTP のリクエストをどう分けているかを見ます。

## PRG パターンとは

PRG は、Post/Redirect/Get の略です。

```text
POST
↓
Redirect
↓
GET
```

状態を変えるリクエストの後に、直接 HTML を返さず、表示用の GET へリダイレクトする形です。

名前は Post/Redirect/Get ですが、この本では、状態を変える処理の後に表示用の GET へ移る設計として扱います。更新や削除でも、最後は表示用の GET へ移動します。

映画図鑑では、登録だけでなく、更新や削除でも同じ考え方を使っています。

```text
POST /movies
↓
303 See Other
↓
GET /movies/:id
```

```text
PATCH /movies/:id
↓
303 See Other
↓
GET /movies/:id
```

```text
DELETE /movies/:id
↓
303 See Other
↓
GET /movies
```

更新と削除では、Network タブ上は PATCH や DELETE ではなく、POST と `_method` として見えます。この章では、全体の設計を先に図で見てから、Network タブと Sinatra ログで実際の見え方を確認します。

## 直接 HTML を返すと何が困るのか

もし登録処理の最後で、リダイレクトせずに HTML を直接返したらどうなるでしょうか。

例えば、次のようなコードを一時的に想像します。これは説明のための比較コードです。本文を読みながら写す必要はありません。

```ruby
post "/movies" do
  @movie = movie_params
  @errors = []

  if @movie["title"].strip.empty?
    @errors << "タイトルを入力してください"
    return erb :new
  end

  movies = load_movies
  movie = { "id" => SecureRandom.uuid }.merge(@movie)
  movies << movie
  save_movies(movies)

  "登録しました"
end
```

この場合、ブラウザに表示されているページは `POST /movies` の結果です。その画面で再読み込みすると、ブラウザはもう一度 `POST /movies` を送ろうとします。

同じ登録処理が再実行されると、同じような映画がもう一度保存される可能性があります。更新なら同じ更新が再送信され、削除なら削除リクエストが再送信されます。

この比較コードは、仕組みを理解するための一時的な例です。映画図鑑の完成コードには残しません。

## 登録後の流れを見る

Chrome DevTools の Network タブを開き、`/movies/new` から映画を登録してください。リダイレクト前後のリクエストを見失う場合は、Network タブの Preserve log を有効にしてから操作すると追いやすくなります。

Network タブには、次の流れが表示されます。

```text
POST /movies
303 See Other
GET /movies/:id
```

`POST /movies` は、映画を保存するリクエストです。このレスポンスは、詳細画面の HTML ではありません。別の URL を見るように指示するリダイレクトレスポンスです。

この環境では、ステータスコードとして `303 See Other` を確認できます。`303 See Other` は、別の URL を GET で取りに行くよう示すリダイレクトです。

その後、ブラウザは `GET /movies/:id` を送ります。画面に表示される映画詳細は、この GET へのレスポンスです。

## 再読み込みで何が起きるか

登録後に表示されている詳細画面で、ブラウザの再読み込みをしてください。

再読み込みで送られるのは、表示中の詳細画面への GET です。

```text
GET /movies/:id
```

`POST /movies` は再実行されません。つまり、再読み込みしても同じ映画がもう一度登録されることはありません。

PRG パターンは、処理後の見た目を整えるためだけのものではありません。状態を変えるリクエストと、結果を表示する GET を分けることで、再読み込み時の再送信を避けています。

また、状態を変える処理と表示を別のリクエストに分けると、それぞれの役割も明確になります。POST、PATCH、DELETE はデータを変えるための処理であり、GET は結果を表示するための処理です。

## 更新後の流れを見る

次に、映画の詳細画面から編集画面へ移動し、映画を更新してください。

HTML フォームは PATCH を直接送れません。そのため、Network タブでは次のように見えます。

```text
POST /movies/:id
Form Data: _method=patch
303 See Other
GET /movies/:id
```

ブラウザが送る HTTP メソッドは POST です。Form Data に `_method=patch` が含まれています。

一方、Sinatra のログでは、Rack の method override を通過した後のリクエストとして、次のように確認できます。

```text
"PATCH /movies/:id HTTP/1.1" 303
```

Network タブの POST と、Sinatra ログの PATCH は矛盾していません。ブラウザは POST を送り、Rack が `_method=patch` を見て、Sinatra へ PATCH として渡しています。

更新後に表示されている詳細画面で再読み込みすると、送られるのは `GET /movies/:id` です。更新処理は再実行されません。

再実行されていないことは、Sinatra のログに新しい PATCH が増えないことで確認できます。

## 削除後の流れを見る

削除も同じ考え方です。詳細画面の削除フォームは、POST と `_method=delete` を送ります。

Network タブでは次のように見えます。

```text
POST /movies/:id
Form Data: _method=delete
303 See Other
GET /movies
```

Sinatra のログでは、Rack の method override を通過した後のリクエストとして確認できます。

```text
"DELETE /movies/:id HTTP/1.1" 303
```

削除後は、削除した映画の詳細画面ではなく一覧画面へリダイレクトします。削除した映画はもう存在しないためです。

一覧画面で再読み込みすると、送られるのは `GET /movies` です。削除処理は再実行されません。

再実行されていないことは、Sinatra のログに新しい DELETE が増えないことで確認できます。

## `GET /` のリダイレクトとの違い

第2章では、`GET /` から `/movies` へリダイレクトしました。

```ruby
get "/" do
  redirect "/movies"
end
```

これは、アプリの入口を `/movies` にそろえるためのリダイレクトです。状態を変える処理の後ではありません。

一方、この章で見ているリダイレクトは、登録、更新、削除の後に使っています。状態を変えるリクエストを終えた後、表示用の GET へ移るためのリダイレクトです。

同じ `redirect` でも、使う場面によって意味が変わります。

## この章の完成コード

この章では、完成コードに残す変更はありません。第7章までのコードをそのまま使い、リダイレクトの意味を HTTP の流れとして確認します。

確認するルートは次の 3 つです。

```ruby
post "/movies" do
  # 省略
  redirect "/movies/#{movie["id"]}"
end

patch "/movies/:id" do
  # 省略
  redirect "/movies/#{movie["id"]}"
end

delete "/movies/:id" do
  # 省略
  redirect "/movies"
end
```

## 確認しよう

1. 映画を登録し、Network タブで `POST /movies`、`303 See Other`、`GET /movies/:id` を確認する。
2. 登録後の詳細画面で再読み込みし、送られるのが `GET /movies/:id` であることを確認する。
   JSON ファイルの件数が増えないことも確認する。
3. 映画を更新し、Network タブで POST と `_method=patch`、Sinatra のログで PATCH を確認する。
4. 更新後の詳細画面で再読み込みし、更新処理が再実行されないことを確認する。
5. 映画を削除し、Network タブで POST と `_method=delete`、Sinatra のログで DELETE を確認する。
6. 削除後の一覧画面で再読み込みし、削除処理が再実行されないことを確認する。

## 考えてみよう

- なぜ登録、更新、削除の後に直接 HTML を返さないのでしょうか。
- Network タブでは POST と表示されるのに、Sinatra のログでは PATCH や DELETE と表示されるのはなぜでしょうか。
- `GET /` から `/movies` へのリダイレクトと、登録後のリダイレクトは何が違うのでしょうか。

## さらに学ぶ

- ◎ MDN HTTP リダイレクト: <https://developer.mozilla.org/ja/docs/Web/HTTP/Redirections>
- ◎ MDN 303 See Other: <https://developer.mozilla.org/ja/docs/Web/HTTP/Status/303>
- ◎ Sinatra: <https://sinatrarb.com/intro.html>
