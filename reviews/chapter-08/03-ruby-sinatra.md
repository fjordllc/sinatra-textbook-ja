# レビュー担当

Ruby・Sinatra・Rack に詳しい技術者

# 対象

第8章「リダイレクトは二つのリクエストをつなぐ」

# 総評

Sinatra 4.2.1 の実際の挙動に基づき、POST/PATCH/DELETE 後の `redirect` が 303 として観察できることを扱っている。method override の観察箇所も技術的に正確である。

# 良い点

- Network タブと Sinatra ログの違いを正確に説明している。
- 303 を現在の固定環境での観察結果として扱い、リダイレクト仕様全体に広げすぎていない。
- 完成コードに残す変更がないことを明記している。
- method override 後の PATCH/DELETE は Rack 通過後の Sinatra 側で確認する、という説明が正確である。

# 改善が必要な点

## must

なし。

## should

- 問題: `PATCH /movies/:id ↓ 303 ↓ GET /movies/:id` という図は、Network タブ上では POST と見える点と少しずれる。
- 理由: 本文では後で説明しているが、先に出る図だけを見ると Network タブでも PATCH と見えると誤解される可能性がある。
- 修正案: 図の直後に「更新・削除では、Network タブ上は POST と `_method` として見える」と注記する。

## could

- 改善案: 303 が `See Other` で GET を促すことは現在の説明で十分。

# 疑問点

なし。

# 判定

軽微な注記後に次へ進める。
