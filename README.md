# FBC Press: Sinatra 教科書

Sinatra を使って、Web アプリケーション開発の基礎を学ぶ初学者向けの OSS 技術書です。

## 必要なもの

- mdBook 0.4.52

## 書籍のプレビュー

```sh
mdbook serve --open
```

ブラウザを自動で開かない場合は、`mdbook serve` を実行し、表示された URL へアクセスします。

## 書籍のビルド

```sh
mdbook build
```

生成物は `book/` に出力されます。

## サンプルアプリ

本書で作成するサンプルアプリ（`sinatra-movies`）の完成版は、次のリポジトリで公開しています。

- [fjordllc/sinatra-movies](https://github.com/fjordllc/sinatra-movies)

## 執筆・レビュー

- 全体設計: [`OUTLINE.md`](OUTLINE.md)
- 作業状況: [`STATUS.md`](STATUS.md)
- 執筆とレビューの手順: [`docs/WRITING_AND_REVIEW_WORKFLOW.md`](docs/WRITING_AND_REVIEW_WORKFLOW.md)

## ライセンス

[MIT License](LICENSE)
