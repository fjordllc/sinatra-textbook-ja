# 第2章 Sinatra をはじめる

第1章では、ブラウザがリクエストを送り、Web アプリケーションがレスポンスを返す往復を見ました。この章では、その往復のサーバー側を初めて作ります。

最初に返す内容は、「映画図鑑」という短い文字列だけです。Sinatra アプリを実際に起動し、URL、Sinatra のルート、ブラウザに返る内容の対応を一つずつ追います。

## 2.1 Sinatra が結ぶリクエストと Ruby

Sinatra は、Ruby で Web アプリケーションを作るためのフレームワークです。2007 年に、ソフトウェア開発者の Blake Mizerany（ブレイク・マイゼラニー）が作り始めました。その後も多くの開発者がコードやドキュメントの改善を重ね、現在まで使われる OSS として育てています。

Sinatra を使うと、第1章で説明したリクエストのうち、**HTTP メソッドとパスの組み合わせ**を Ruby の処理へ対応付けられます。

たとえば、次のコードは `GET /movies` というリクエストに対応します。

```ruby
get "/movies" do
  "映画図鑑"
end
```

このような対応を**ルート**と呼びます。コードの各部分は、次の意味を持ちます。

| コード | 対応するもの |
| --- | --- |
| `get` | HTTP メソッドの `GET` |
| `"/movies"` | リクエストのパス `/movies` |
| `do` から `end` | リクエストが一致したときに実行する処理 |
| `"映画図鑑"` | レスポンス本文になる文字列 |

`get` は、Sinatra が用意する Ruby のメソッドです。`get "/movies"` と書くことで、HTTP の `GET /movies` と Ruby の処理を結び付けられます。まずは、この対応だけを押さえてください。

> Sinatra のように、特定の目的に合わせて用意された書き方を DSL と呼びます。この名前は、今すぐ覚えなくても先へ進めます。

このコードがブラウザで実行されるわけではありません。Sinatra アプリが `GET /movies` を受け取るとブロックを実行し、最後に評価された文字列を使ってレスポンスを作ります。

## 2.2 作業用ディレクトリを用意する

本書は、映画図鑑というサンプルアプリを、自分の手で一から作りながら進めるハンズオンです。コードを読むだけでなく、実際にファイルを作り、コマンドを実行しながら読み進めてください。

ここからは、映画図鑑を作るための新しいディレクトリを用意します。ターミナルで、作業したい場所へ移動してから、次のコマンドを実行します。

```sh
mkdir sinatra-movies
cd sinatra-movies
git init
```

`mkdir` は `sinatra-movies` という空のディレクトリを作ります。`cd` で、そのディレクトリへ移動します。`git init` は、このディレクトリを Git で管理し始めるためのコマンドです。これから作るファイルは、すべてこの `sinatra-movies` ディレクトリの中に置きます。

現在いるディレクトリは、次のコマンドで確認できます。

```sh
pwd
```

出力の末尾が `sinatra-movies` なら、以降のコマンドを実行する**作業用ディレクトリ**にいます。

## 2.3 バージョンをそろえる三つのファイル

コードを書く前に、本書と同じ環境を用意します。Ruby や Gem は、バージョンによって書き方や動作が変わることがあります。バージョンが違うと、本書のとおりに書いても、違う結果が表示されたりエラーになったりします。

この違いを避けるため、最初にバージョンをそろえます。使うファイルは次の三つです。

| ファイル | 決めるもの | 本書での例 |
| --- | --- | --- |
| `.ruby-version` | Ruby 本体のバージョン | Ruby 4.0.6 |
| `Gemfile` | 必要な Gem と許容するバージョン範囲 | Sinatra 4.2 系 |
| `Gemfile.lock` | 実際に使う Gem の組み合わせ | Sinatra 4.2.1 |

このうち `.ruby-version` と `Gemfile` は、これから自分で作ります。`Gemfile.lock` は、次の 2.4 で `bundle install` を実行すると自動で作られます。

まず、`sinatra-movies` ディレクトリに `.ruby-version` を作り、次の一行を書きます。

```text
4.0.6
```

Ruby のバージョン管理ツールは、このファイルに対応していれば、ディレクトリで使う Ruby を選ぶときに参照します。`.ruby-version` があるだけで Ruby 本体がインストールされるわけではありません。ターミナルで確認します。

```sh
ruby -v
```

出力の先頭が `ruby 4.0.6` であることを確認してください。異なる場合は、これまで使ってきた Ruby のバージョン管理方法で 4.0.6 を用意してから進みます。本書では、Ruby のインストール方法やバージョン管理ツールの比較は扱いません。

次に、`Gemfile` を作ります。**Gem** とは、Ruby のライブラリを再利用しやすい形にまとめて配布する仕組み、またはそのまとまりです。他の人が作った機能を Gem として取り込むことで、Web サーバーやルーティングなどを自分でゼロから書かずに済みます。この後で使う Sinatra や Puma も Gem として提供されています。

`Gemfile` は、そのアプリで使う Gem を宣言するファイルです。次の内容を書きます。

```ruby
source "https://rubygems.org"

ruby "4.0.6"

gem "puma", "~> 8.0.0"
gem "rackup", "~> 2.3.0"
gem "sinatra", "~> 4.2.0"
```

ここでは三つの Gem を宣言しています。それぞれの役割は次のとおりです。

- **Sinatra** は、Ruby で Web アプリケーションを書くためのフレームワークです。2.1 で見た `get "/movies"` のようなルーティングをはじめ、リクエストを処理してレスポンスを返す機能を提供します。本書の主役となる Gem です。
- **Puma** は、ブラウザから届く HTTP リクエストを受け付ける Web サーバーです。リクエストを Sinatra のアプリへ渡し、返ってきたレスポンスをブラウザへ送り返します。
- **rackup** は、Sinatra が Puma を起動するときに使う補助的な Gem です。それ自体が別のサーバーになるわけではありません。

この三つがどう連携するのかは、アプリを最初に動かした後、2.7 で図を使って確かめます。

`gem "sinatra", "~> 4.2.0"` の `~> 4.2.0` は、使ってよいバージョンの範囲を表します。ここでは、4.2.0 以上、4.3.0 未満を指定しています。

バージョンを指定しないと、後日 `bundle install` したときに、動作が大きく異なるバージョンが入るかもしれません。範囲を指定すれば、大きな変更を避けながら、4.2 系の細かな修正を取り込めます。

ただし、`Gemfile` だけでは、実際に使う 4.2 系のバージョンまでは決まりません。選ばれたバージョンを記録するのが、次の `Gemfile.lock` です。

`Gemfile.lock` には、Bundler が実際に選んだ Gem とバージョンが記録されます。このファイルは、次の 2.4 で `bundle install` を実行すると作られます。これにより、Sinatra 4.2.1、Puma 8.0.2、rackup 2.3.1 などのバージョンが固定されます。

`Gemfile.lock` は Bundler が更新するため、手では編集しません。Git へコミットして、同じリポジトリを使う人が同じ組み合わせを利用できるようにします。

## 2.4 Bundler で必要な Gem を用意する

**Bundler** は、Gem を管理するためのツールです。Bundler 自体も Gem の一つで、Ruby と一緒に使います。

Gem は、別の Gem を必要とすることがあります。必要な Gem とバージョンを一つずつ手作業で合わせるのは大変です。Bundler は、`Gemfile` を読み、同時に使える Gem の組み合わせを選びます。そして、選んだ結果を `Gemfile.lock` に記録します。

同じ `Gemfile.lock` を使えば、複数の人が同じ Gem の組み合わせでアプリを動かせます。

まず、Bundler のバージョンを確認します。

```sh
bundle -v
```

本書では Bundler 4.0.16 で動作を確認しています。異なるバージョンが表示された場合は、次のコマンドで 4.0.16 をインストールします。

```sh
gem install bundler -v 4.0.16
```

インストール後、`sinatra-movies` ディレクトリでもう一度 `bundle -v` を実行し、出力に `4.0.16` が含まれることを確認します。続いて、必要な Gem をインストールします。

```sh
bundle install
```

初回は Gem のダウンロードに時間がかかることがあります。最後に `Bundle complete!` と表示され、エラーなくコマンドが終了すれば準備できています。このとき、選ばれた Gem の組み合わせが `Gemfile.lock` に書き出されます。すでにインストール済みの場合も、Bundler は現在の状態を確認します。

## 2.5 最初のルートを `app.rb` に書く

`app.rb` は、映画図鑑のサーバー側の処理を書く中心的な Ruby ファイルです。`app` は application を短くした名前です。Sinatra がこのファイル名を必須としているわけではありませんが、本書では役割が分かりやすいように `app.rb` へ統一します。

このファイルに Sinatra の読み込みやルートを書き、後で `ruby app.rb` と実行します。まず、`sinatra-movies` ディレクトリに `app.rb` を作り、次のコードを書きます。

```ruby
require "sinatra"

get "/" do
  "映画図鑑を作ります"
end
```

`require "sinatra"` によって Sinatra を読み込み、`get` などの DSL を使えるようにします。

`"/"` は URL のルートとなるパスです。`GET /` を受け取ると、Sinatra はこのブロックを実行します。ブロックの最後の文字列 `"映画図鑑を作ります"` がレスポンス本文になります。

第1章で見た対応に当てはめてみます。

```http
GET / HTTP/1.1
Host: localhost:4567
```

このリクエストに `get "/"` が一致し、レスポンス本文として次の文字列が返ります。

```text
映画図鑑を作ります
```

まだ HTML の要素は返していません。まずは、文字列を返す最小のルートが動くことを確認します。

## 2.6 Puma で Sinatra アプリを起動する

`app.rb` があるディレクトリで、次のコマンドを実行します。

```sh
bundle exec ruby app.rb
```

`ruby app.rb` は、今作った `app.rb` を Ruby で実行する指定です。先頭の `bundle exec` は、`Gemfile` と `Gemfile.lock` で管理している Gem を使える状態にして、後ろのコマンドを実行します。単に `ruby app.rb` とした場合、環境に別のバージョンの Sinatra が入っていれば、意図しない組み合わせが選ばれる可能性があります。本書では起動方法を一つにそろえるため、常に `bundle exec` を付けます。

起動に成功すると、Sinatra 4.2.1、Puma 8.0.2、Ruby 4.0.6 といった情報に続いて、次のような待ち受け先が表示されます。細かな出力は環境によって異なります。

```text
Listening on http://127.0.0.1:4567
```

コマンド入力へ戻らないのは、処理が止まったからではありません。Puma がポート 4567 でリクエストを待ち受けているためです。このターミナルはそのままにして、Chrome で次の URL を開きます。

```text
http://localhost:4567/
```

画面に「映画図鑑を作ります」と表示されれば、`GET /` のリクエストと `get "/"` のルートがつながっています。Network パネルでも、Request Method が `GET`、Status Code が `200 OK` であることを確認してください。Response には「映画図鑑を作ります」と表示されます。

アプリを停止するときは、起動したターミナルで `Control + C` を押します。本書の構成では、コードを変更しても起動中のアプリへ自動では反映されません。これから `app.rb` を変更するたびに、`Control + C` で停止し、同じ起動コマンドをもう一度実行します。

起動時に `Address already in use` と表示された場合は、別のターミナルで前に起動したアプリが動き続けていないか確認します。詳しい切り分けは、[付録D「よくあるエラー」](../appendix/d.md)で扱います。

## 2.7 Puma、Rack、Sinatra の受け渡し

起動時の表示には、Sinatra と Puma という名前がありました。`Gemfile` に書いた Sinatra、Puma、rackup は、それぞれ同じ役割を持つものではありません。

<figure>
  <img src="../assets/fig-2-1.svg" alt="ブラウザのリクエストを Puma が受け、Rack の共通インターフェースで Sinatra へ渡し、Sinatra のレスポンスを逆向きに返す流れ。Rack は独立した実行主体ではなく、Puma と Sinatra の間の境界として示されている">
  <figcaption>図 2-1 Puma、Rack、Sinatra の受け渡し</figcaption>
</figure>

図の下向きの矢印は、ブラウザから Sinatra へ届くリクエストです。上向きの矢印は、Sinatra からブラウザへ戻るレスポンスです。

ブラウザから届いた HTTP リクエストを最初に受け付けるのが Puma です。Puma は、Ruby の Web アプリケーションへリクエストを渡し、返されたレスポンスをブラウザへ送ります。

Puma が渡す情報の形と、Sinatra が受け取る情報の形は、同じである必要があります。この共通の形を決めるのが Rack です。このような受け渡しの決まりを、インターフェースと呼びます。

Rack 自体が、Puma や Sinatra と同じように独立して動くわけではありません。図では、Puma と Sinatra の間にある共通の決まりとして示しています。

Sinatra は Rack の決まりに従って、Puma からリクエストを受け取ります。一方、私たちは `get "/movies"` のような短いコードでルートを書けます。Rack との細かな受け渡しは、Sinatra が担当するためです。

Rails も Rack の決まりに従います。今後 Rails を使うときにも、ブラウザ、Web サーバー、Rack、アプリケーションという関係は残ります。

rackup は、本書の起動方法で Sinatra が Puma を起動するために使うサーバーハンドラーを提供します。アプリを起動するために必要な Gem ですが、別のサーバーとして起動するわけではありません。

本書では、`require "sinatra"` と書き、ルートをそのまま並べるクラシックスタイル（Classic Style）を使います。クラスを定義せず、一つの `app.rb` から始められる書き方です。Sinatra には別の書き方もありますが、この本では比較しません。

## 2.8 URL ごとに別のルートを選ぶ

映画図鑑の入口には `/movies` というパスを使います。`app.rb` の末尾へ、二つ目のルートを追加します。

```ruby
get "/movies" do
  "映画図鑑"
end
```

アプリを再起動し、二つの URL を順に開きます。

```text
http://localhost:4567/
http://localhost:4567/movies
```

`/` では「映画図鑑を作ります」、`/movies` では「映画図鑑」と表示されます。同じ Puma と Sinatra のプロセスへ送った `GET` リクエストでも、パスが異なるため別のルートが選ばれます。

ルートはパスだけで決まるものではありません。Sinatra では、HTTP メソッドとパスの組み合わせが一致するルートを探します。この章では `GET` だけを使いますが、後の章では同じ `/movies` というパスへ `POST` を送るルートも作ります。

## 2.9 `/` から `/movies` へ移動させる

映画図鑑の一覧は `/movies` で表示する方針です。利用者がルート URL の `/` を開いたときも、`/movies` へ移動するようにします。

`get "/movies"` は残したまま、`get "/"` のブロックだけを次のように変更します。

```ruby
get "/" do
  redirect "/movies"
end
```

`redirect` は Sinatra が用意するヘルパーメソッドです。この場合、`/movies` の内容を `GET /` のレスポンス本文として返すわけではありません。ブラウザへ「次は `/movies` をリクエストしてください」と伝える**リダイレクトレスポンス**を返します。

アプリを再起動し、アドレスバーへ次の URL を入力します。

```text
http://localhost:4567/
```

最終的に「映画図鑑」と表示され、アドレスバーが `http://localhost:4567/movies` へ変わります。画面だけを見ると一度のアクセスで `/movies` が表示されたように見えますが、裏では二つのリクエストが発生しています。

## 2.10 Network パネルで二つの GET を見る

Network パネルを開いたまま、もう一度 `http://localhost:4567/` へアクセスします。記録されたリクエストを時刻順に見ると、次の流れを確認できます。

1. `GET /` に対して `302 Found` が返り、`/movies` へ移動するよう伝える。
2. `GET /movies` に対して `200 OK` が返り、「映画図鑑」という本文を受け取る。

最初の `GET /` を選び、`Headers` の `Response Headers` にある `Location` を探します。

```http
Location: http://localhost:4567/movies
```

`302 Found` はリダイレクトを表すステータスコードの一つです。ブラウザは `Location` ヘッダーを読み、新しい `GET /movies` リクエストを送ります。二つ目の `200 OK` のレスポンス本文を受け取ってから、「映画図鑑」を画面へ表示します。

<figure class="book-figure">
  <img src="../assets/captures/capture-2.jpg" alt="Network パネルに最初の GET の 302 と、それに続く movies への GET の 200 が順に並び、Location が movies を示す確認例">
  <figcaption>図 2-2 リダイレクトで発生する二つの GET</figcaption>
</figure>

起動したターミナルのログにも、次のような二行が表示されます。

```text
"GET / HTTP/1.1" 302
"GET /movies HTTP/1.1" 200
```

日時や処理時間など、前後の表示は環境によって異なります。ここで見るのは、HTTP メソッド、パス、ステータスコードです。

リダイレクトを使う理由やステータスコードの選び方は、フォームからデータを変更した後に重要になります。第8章で PRG パターンとして改めて説明します。この章では、リダイレクトが「別の URL へ移動した画面」ではなく、次のリクエストを促すレスポンスであることを押さえます。

`redirect "/movies"` が、`get "/movies"` のブロックをその場で呼び出しているわけではありません。最初のレスポンスを受け取ったブラウザが、別の `GET /movies` を送ることで二つ目のルートが実行されます。この区別は、Network パネルの二つの行とターミナルの二つのログで確認できます。

ここで見た流れを、「ブラウザ」「302 のレスポンス」「二つ目の GET」という三つの言葉を使って一文で説明してみてください。`/movies` の本文が最初のレスポンスに含まれている、という説明になっていないかも確認します。

## 2.11 この章のコードを確認する

この章の終了時点で、`app.rb` は次の内容になります。

```ruby
require "sinatra"

get "/" do
  redirect "/movies"
end

get "/movies" do
  "映画図鑑"
end
```

二つのルートを、リクエストとレスポンスへ対応付けると次のようになります。

- `GET /`: `redirect "/movies"` を実行し、302 と `/movies` を示す `Location` ヘッダーを返す。
- `GET /movies`: `"映画図鑑"` を評価し、200 と「映画図鑑」という本文を返す。

次章では、`"映画図鑑"` という文字列を HTML の画面へ育てます。`app.rb` に長い HTML を直接書き続けず、ERB テンプレートと `views/` ディレクトリを使って、Ruby のデータから映画一覧を作ります。そのときは、レスポンスヘッダーの `Content-Type` も Network パネルで確認します。

## さらに学ぶ

Rack は、Ruby の Web サーバーと Web アプリケーションが同じ方法でリクエストとレスポンスを受け渡すための共通インターフェースです。共通のインターフェースがあることで、Sinatra は Puma からリクエストを受け取れます。

本章では、Rack を独立したサーバーやフレームワークとして操作しませんでした。Sinatra を使うと、Rack の受け渡しを直接書かずにルーティングへ集中できます。後の章で method override を使うときには、フォームから届いたリクエストを Sinatra のルートへ渡す前に Rack が処理する例を見ます。

## 参考資料

- [Sinatra: About](https://sinatrarb.com/about.html)
- [Sinatra: README - Getting Started, Routes, Return Values, Browser Redirect, Modular vs. Classic Style, Rack Middleware](https://sinatrarb.com/intro.html)
- [sinatra 0.1.5 - RubyGems.org](https://rubygems.org/gems/sinatra/versions/0.1.5)
- [Bundler: Gemfile](https://bundler.io/guides/gemfile.html)
- [Bundler: bundle exec](https://bundler.io/man/bundle-exec.1.html)
- [Rack: a Ruby Webserver Interface](https://rack.github.io/)
- [sinatra 4.2.1 - RubyGems.org](https://rubygems.org/gems/sinatra/versions/4.2.1)
- [puma 8.0.2 - RubyGems.org](https://rubygems.org/gems/puma/versions/8.0.2)
