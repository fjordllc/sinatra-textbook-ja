# 第2章 章設計

## 基本情報

- 章タイトル: Sinatra をはじめる
- 対応する OUTLINE: `OUTLINE.md` 第2章
- 状態: 完了

## この章の主張

Sinatra のルートは、HTTP メソッドと URL のパスを Ruby の処理へ対応付けます。ブラウザから届いたリクエストに一致するルートが実行され、そのブロックの戻り値からレスポンスが作られるためです。

## 学習ゴール

Sinatra アプリを起動し、URL とルーティングの対応を追いながら最小のレスポンスを返せる。

## 読者が持ち帰る一文

`get "/movies"` は単なる Ruby の記法ではなく、`GET /movies` というリクエストとレスポンスを作る処理の対応である。

## 必要な前提知識

- 第1章を読み、ブラウザ、サーバー、リクエスト、レスポンスの関係を説明できる。
- Ruby のメソッド呼び出し、文字列、ブロックの基本を理解している。
- ターミナルでコマンドを実行できる。
- Git リポジトリを clone し、ブランチを作成できる。
- Ruby のバージョン管理環境を利用でき、リポジトリの `.ruby-version` に対応する Ruby を用意できる。
- Chrome DevTools の Network パネルを開き、リクエストを選択できる。

## 前章から受け取るもの

- ブラウザはリクエストを送り、サーバー側のプログラムがレスポンスを返す。
- URL のパスは物理ファイル名とは限らず、ルーティングで処理へ対応付けられる。
- Network パネルで Request URL、Request Method、Status Code、Headers、Response を確認できる。

## 次章へ渡すもの

- `bundle exec ruby app.rb` で Sinatra アプリを起動する方法
- HTTP メソッドとパスの組み合わせがルートを選ぶという理解
- ルートブロックの文字列がレスポンス本文になるという理解
- リダイレクトレスポンスと、その後にブラウザが送る新しいリクエストの区別
- `GET /movies` の文字列レスポンスを、次章で HTML と ERB へ発展させるためのコード

## サンプルアプリへ加える変更

第1章時点では存在しなかった `app.rb` を追加します。最初に `GET /` へ文字列を返し、次に `GET /movies` を追加します。最後に `GET /` の処理を `/movies` へのリダイレクトへ変更します。

章終了時点の `app.rb` は次の状態です。

```ruby
# frozen_string_literal: true

require "sinatra"

get "/" do
  redirect "/movies"
end

get "/movies" do
  "映画図鑑"
end
```

`enable :method_override` は第7章で PATCH と DELETE が必要になったときに追加します。使わない設定を第2章で先に置きません。

## 技術基盤の説明範囲

### `.ruby-version`

- 本書で動作確認した Ruby 4.0.6 を示す。
- 対応するバージョン管理ツールが、ディレクトリに入ったときに参照できるファイルである。
- Ruby のインストール方法やバージョン管理ツールの比較は扱わない。

### `Gemfile`

- このアプリが必要とする Gem と許容するバージョン範囲を宣言する。
- Sinatra 4.2 系、Puma 8.0 系、rackup 2.3 系を使う理由を一文ずつ説明する。
- Gem の網羅的なバージョン制約記法は扱わない。

### `Gemfile.lock`

- `bundle install` で実際に選ばれた Gem とバージョンを記録する。
- 同じリポジトリを使う人が同じ組み合わせを再現するためにコミットする。
- 手で編集せず、Bundler に更新させる。

### `bundle exec`

- `Gemfile` と `Gemfile.lock` の組み合わせを使える環境でコマンドを実行する。
- 本書の起動コマンドを `bundle exec ruby app.rb` に統一する。
- Bundler の環境変数変更や Rubygems 内部処理へは踏み込まない。

## Sinatra、Puma、Rack の関係

- Puma はブラウザから HTTP リクエストを受け取る Web サーバーである。
- Rack は Ruby の Web サーバーと Web アプリケーションの間で、リクエストとレスポンスを受け渡す共通のインターフェースを定める。
- Sinatra は Rack アプリケーションであり、ルーティングを Ruby で書くための DSL を提供する。
- `require "sinatra"` を使い、トップレベルへルートを書くクラシックスタイル（Classic Style）を採用する。
- 一つの小さなアプリを一つのファイルから始める本書ではクラシックスタイルが理解しやすい。モジュラースタイル（Modular Style）の書き方や比較は扱わない。
- Rails も Rack の上で動くことを一文だけ示し、Rails の内部構造へ進まない。

## 節ごとの展開

### 2.1 Sinatra が結ぶリクエストと Ruby

第1章の図の Web アプリケーション側を実装すると位置付けます。Sinatra は、HTTP メソッドとパスの組み合わせを Ruby のブロックへ対応付ける道具だと説明します。

### 2.2 作業用リポジトリを用意する

本書の公開リポジトリを clone し、`chapter-01` タグから `chapter-02-work` ブランチを作ります。既定ブランチのコードが執筆とともに進むため、章の開始タグから作業する理由を説明します。`pwd` でリポジトリのルートにいることを確認します。

### 2.3 バージョンをそろえる三つのファイル

`.ruby-version`、`Gemfile`、`Gemfile.lock` を順に読みます。「Ruby 本体」「必要な Gem の条件」「実際に選ばれた Gem」という役割を表で対比します。

### 2.4 Bundler で必要な Gem を用意する

`ruby -v` と `bundle -v` を確認し、Bundler 4.0.16 がない場合は同じ版を用意します。`bundle install` を実行し、出力全文の一致は求めず、エラーなく終了することを確認します。`bundle exec` の役割を説明します。

### 2.5 最初のルートを `app.rb` に書く

`require "sinatra"` と `get "/"` を追加します。`get`、`"/"`、ブロック、最後の文字列を `GET /` のリクエストとレスポンスへ対応付けます。

### 2.6 Puma で Sinatra アプリを起動する

`bundle exec ruby app.rb` だけを起動方法として示します。起動中のターミナルはリクエストを待ち受けているため、コマンド入力へ戻らないことを説明します。停止は `Control + C`、コード変更後は停止して再起動します。

### 2.7 Puma、Rack、Sinatra の受け渡し

初回起動の表示を見た後に、ブラウザ、Puma、Rack、Sinatra の関係を図 2-1 で示します。Rack 自体が Web サーバーやフレームワークではなく、Puma と Sinatra が従う共通ルールを定める境界であることを説明します。rackup は Sinatra が Puma を起動するために使うサーバーハンドラーを提供します。

### 2.8 URL ごとに別のルートを選ぶ

`get "/movies"` を追加し、`/` と `/movies` のレスポンスが異なることを確認します。ルートは HTTP メソッドとパスの組み合わせで選ばれると説明します。

### 2.9 `/` から `/movies` へ移動させる

`get "/"` の戻り値を `redirect "/movies"` へ変更します。ここではリダイレクトを「ブラウザへ別の URL をリクエストするよう指示するレスポンス」として説明します。PRG という名前やフォーム送信後の再読み込み問題は第8章へ残します。

### 2.10 Network パネルで二つの GET を見る

`http://localhost:4567/` へアクセスし、次の順序を確認します。

1. `GET /` に対する `302 Found`
2. `Location: http://localhost:4567/movies`
3. ブラウザが新しく送る `GET /movies`
4. `GET /movies` に対する `200 OK`

アドレスバーが最終的に `/movies` へ変わるだけでなく、二つのリクエストと二つのレスポンスがあることを言語化します。

### 2.11 この章のコードを確認する

最終的な `app.rb` と、HTTP メソッド、パス、処理結果を表で照合します。次章では文字列 `"映画図鑑"` を HTML レスポンスへ育てることを示します。

## 本文中へ組み込む確認

- 2.2: `chapter-01` タグから作業を始め、リポジトリのルートを確認する。
- 2.3: `.ruby-version`、`Gemfile`、`Gemfile.lock` のどれを見れば何が分かるかを対応付ける。
- 2.5: `get "/"` の各部分を `GET /` とレスポンス本文へ対応付ける。
- 2.8: `/` と `/movies` を開き、同じプロセスでもパスによってレスポンスが変わることを確認する。
- 2.10: Network パネルで二つの GET と 302、200、Location ヘッダーを確認し、ブラウザが二つ目の GET を送る流れを一文で説明する。
- 章末: `redirect` が `/movies` の HTML をその場で返している、という説明の誤りを言語化する。

## 図・表

### 図 2-1 Puma、Rack、Sinatra の受け渡し

- 配置: 2.7
- 目的: ブラウザからの HTTP リクエストを Puma が受け、Rack の共通インターフェースを通して Sinatra が処理する位置関係を示す。
- 要素: 縦に配置したブラウザ、Puma、Sinatra。Puma と Sinatra の間に破線の境界として示す Rack の共通インターフェース。下向きの「リクエスト」と上向きの「レスポンス」。
- 可読性: 500 px 幅でも図中文字が読める縦横比にする。
- 制約: Rack の env ハッシュ、3 要素配列、middleware stack、スレッドモデルは描かない。
- 保存先: `manuscript/assets/fig-2-1.svg`
- alt テキスト案: ブラウザから届いたリクエストを Puma が受け、Rack の共通インターフェースを介して Sinatra が処理し、レスポンスが逆向きに戻る流れ。
- 生成方法: `scripts/figures/build_all.py` に定義を追加して再生成する。

### 表 バージョンをそろえる三つのファイル

- `.ruby-version`: Ruby 本体のバージョン
- `Gemfile`: 必要な Gem と許容するバージョン範囲
- `Gemfile.lock`: 実際に使う Gem の組み合わせ

### 表 最終ルーティング

- `GET /`: `/movies` へのリダイレクトレスポンス
- `GET /movies`: `映画図鑑` というレスポンス本文

## この章では扱わないこと

- ERB、`views/`、`layout.erb`
- HTML 文書の構造と CSS
- フォーム、`POST`、`params`
- JSON ファイルと映画データ
- method override、`PATCH`、`DELETE`
- PRG パターンの名前と目的
- 303 See Other の採用判断
- Rack の env ハッシュ、レスポンス配列、middleware の詳細
- モジュラースタイル、`config.ru`、`rackup` による起動
- 自動リロード用 Gem
- Ruby のインストール方法とバージョン管理ツールの比較
- Git と GitHub の基本操作

## 先回りして防ぐ誤解

- `get` はブラウザ側で動く処理である。
- `get "/movies"` は `movies` というファイルを開く処理である。
- ルートはパスだけで決まり、HTTP メソッドは関係ない。
- `redirect "/movies"` が `/movies` のレスポンス本文をその場で返す。
- 起動コマンドが終了せず入力待ちに見えるのは、アプリが止まったためである。
- コードを保存すれば、起動中のアプリへ自動的に反映される。
- `Gemfile.lock` は不要な生成物なのでコミットしない。
- 公開リポジトリの既定ブランチをそのまま使えば、第2章の開始状態になる。

## 技術確認に使う資料

- Sinatra 公式「Getting Started」「Routes」「Return Values」「Browser Redirect」「Modular vs. Classic Style」「Rack Middleware」: <https://sinatrarb.com/intro.html>
- Bundler 公式「Gemfile」: <https://bundler.io/guides/gemfile.html>
- Bundler 公式「bundle exec」: <https://bundler.io/man/bundle-exec.1.html>
- Rack 公式: <https://rack.github.io/>
- RubyGems Sinatra 4.2.1: <https://rubygems.org/gems/sinatra/versions/4.2.1>
- RubyGems Puma 8.0.2: <https://rubygems.org/gems/puma/versions/8.0.2>

## 執筆開始条件

- [x] Ruby 4.0.6、Sinatra 4.2.1、Puma 8.0.2、Rack 3.2.6 の起動構成を検証済みである。
- [x] `redirect "/movies"` が `GET /` に対して 302 と Location ヘッダーを返すことを固定バージョンのソースと実動作で確認済みである。
- [x] クラシックスタイル、ルートの戻り値、Puma と Rack の関係を Sinatra 公式資料で確認した。
- [x] Bundler と `bundle exec` の説明を Bundler 公式資料で確認した。
- [x] 図 2-1 を生成し、XML と表示を確認する。
- [x] 章終了時点の `app.rb` を追加し、起動と HTTP 応答を再検証する。
