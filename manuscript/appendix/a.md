# 付録A README

README は、リポジトリを開いた人が最初に読む説明です。

アプリケーションが手元では動いていても、第三者が `git clone` したあとに起動できなければ、再現可能な状態とは言えません。README には、アプリケーションの概要と、起動までに必要な手順を書きます。

## README に書くこと

小さな Sinatra アプリケーションなら、まず次の内容があれば十分です。

- アプリケーションの概要
- 必要な Ruby バージョン
- セットアップ手順
- 起動方法
- ブラウザで開く URL
- 利用している保存方法

例えば、映画図鑑なら次のように書けます。

````markdown
# 映画図鑑

映画の情報を登録、表示、編集、削除できる Sinatra アプリケーションです。

## 必要なもの

- Ruby 4.0.6
- Bundler 4.0.16

## セットアップ

```sh
bundle install
```

## 起動方法

```sh
bundle exec ruby app.rb
```

起動後、ブラウザで <http://localhost:4567/> を開きます。

## データ保存

映画データは `data/movies.json` に保存します。
````

実際の README では、使っている Ruby や Bundler のバージョンを、自分のリポジトリに合わせて書きます。本書の映画図鑑では、`.ruby-version`、`Gemfile`、`Gemfile.lock` にバージョンを記録しています。

## 起動コマンドを一つにする

README では、起動方法を一つに統一します。

本書では、次のコマンドに統一しました。

```sh
bundle exec ruby app.rb
```

`ruby app.rb`、`bundle exec ruby app.rb`、`rackup` のように複数の起動方法を並べると、初めて読む人はどれを使えばよいか迷います。実際に確認した手順を一つ書く方が親切です。

## `bundle exec` を付ける

Bundler を使うアプリケーションでは、README のコマンドにも `bundle exec` を付けます。

```sh
bundle exec ruby app.rb
```

`bundle exec` を付けると、`Gemfile.lock` に記録されたバージョンの gem を使ってコマンドを実行できます。手元の環境に別バージョンの gem が入っていても、README に書いた手順で再現しやすくなります。

## README に書きすぎない

README は、本編の代わりにすべてを説明する場所ではありません。

例えば、PRG パターン、XSS 対策、method override の詳しい説明まで README に書く必要はありません。README には、第三者がアプリケーションの目的を理解し、起動して確認するために必要な情報を置きます。

## 確認しよう

- 新しいディレクトリへリポジトリを clone したつもりで、README の手順だけを読んで起動できるか確認する。
- 起動コマンドに `bundle exec` が付いているか確認する。
- 保存データの場所が `public/` ではなく `data/` であることを確認する。
