# 第9章 章設計: 利用者の入力はそのまま HTML にしない

## この章の目的

映画図鑑に保存される値がすべて利用者入力であることを確認し、利用者入力を HTML として出力すると XSS につながることを学ぶ。第5章で導入した `h` ヘルパーの意味を、危険な表示との比較で理解する。

## 読了後にできるようになること

- XSS が、利用者入力をブラウザに HTML として解釈させてしまう問題であると説明できる。
- `<script>alert("xss")</script>` だけでなく、属性値や `textarea` の文脈で壊れる入力例を確認できる。
- Sinatra の ERB が自動エスケープされる前提にしない理由を説明できる。
- `Rack::Utils.escape_html` を呼び出す `h` ヘルパーを使う理由を説明できる。
- タイトル、監督、公開年、ジャンル、紹介文を表示するときに `h` を使う必要があると判断できる。

## 必要な前提知識

- 第5章で導入した `h` ヘルパー。
- ERB の `<%= %>` が値を出力すること。
- HTML のタグ、属性値、`textarea` の基本。

## サンプルアプリへ加える変更

完成コードに残す変更は行わない。現在の `views/*.erb` では、利用者入力を `h` で表示している状態を維持する。

章内では、ローカル環境で一時的に `h` を外した例を示す。ただし、確認後は必ず元の安全なコードへ戻す。

## Network タブなどで観察する対象

- 入力値が JSON に保存されること。
- `h` を使っている状態では、`<script>` などが HTML タグとして実行されず文字として表示されること。
- `h` を一時的に外した場合、ブラウザが入力を HTML として解釈してしまうこと。
- 最終的なレスポンス HTML で、`<` や `"` が文字参照になっていること。

## この章では扱わないこと

- CSRF。
- Content Security Policy。
- Cookie、セッション、認証。
- XSS 攻撃手法の網羅。
- サニタイズライブラリの比較。
- ERB 以外のテンプレートエンジン。

## 章固有の設計判断

危険なコードは章内の一時的な確認に閉じる。完成コード、コミット、章末の完成状態には残さない。

`description` の改行表示は、第6章で導入した `white-space: pre-line` を使い続ける。Ruby 側で `<br>` を生成しない。

## 参考にする一次情報

- OWASP XSS: <https://owasp.org/www-community/attacks/xss/>
- MDN Cross-site scripting: <https://developer.mozilla.org/ja/docs/Glossary/Cross-site_scripting>
- Rack Utils: <https://rack.github.io/rack/main/Rack/Utils.html>
- Ruby ERB: <https://docs.ruby-lang.org/ja/latest/library/erb.html>
