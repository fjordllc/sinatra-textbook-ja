#!/usr/bin/env python3
"""Sinatra 教科書の自作 SVG を再生成する。

出力先: manuscript/assets/fig-*.svg
方針: 1 図 1 主張。色だけに依存せず、ラベルと矢印でも関係を示す。
"""

import html
import pathlib


ASSETS = pathlib.Path(__file__).resolve().parents[2] / "manuscript/assets"
ASSETS.mkdir(parents=True, exist_ok=True)

INK = "#1f2933"
SUB = "#52606d"
ACC = "#3a6ea5"
NEUT = "#eef1f5"
BLUE = "#dce9f2"
LINE = "#b8c2cc"


def esc(value):
    return html.escape(str(value), quote=True)


def head(width, height, aria_label):
    return [
        (
            f'<svg xmlns="http://www.w3.org/2000/svg" '
            f'viewBox="0 0 {width} {height}" font-family="sans-serif" '
            f'role="img" aria-label="{esc(aria_label)}">'
        ),
        "<defs>",
        (
            '<marker id="arrow" markerWidth="10" markerHeight="10" '
            'refX="7" refY="3" orient="auto">'
            f'<path d="M0,0 L7,3 L0,6 Z" fill="{ACC}"/>'
            "</marker>"
        ),
        "</defs>",
    ]


def rect(x, y, width, height, fill="#fff", stroke=LINE, radius=0):
    return (
        f'<rect x="{x}" y="{y}" width="{width}" height="{height}" '
        f'rx="{radius}" fill="{fill}" stroke="{stroke}" stroke-width="1.5"/>'
    )


def txt(x, y, value, size=16, fill=INK, anchor="start", weight="normal"):
    return (
        f'<text x="{x}" y="{y}" text-anchor="{anchor}" '
        f'font-size="{size}" font-weight="{weight}" fill="{fill}">'
        f"{esc(value)}</text>"
    )


def line(x1, y1, x2, y2, stroke=ACC, width=2, marker=None):
    marker_attribute = f' marker-end="url(#{marker})"' if marker else ""
    return (
        f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" '
        f'stroke="{stroke}" stroke-width="{width}"{marker_attribute}/>'
    )


def save(name, elements):
    elements.append("</svg>")
    (ASSETS / name).write_text("\n".join(elements), encoding="utf-8")
    print(f"wrote {name}")


def fig_1_1():
    width, height = 760, 230
    elements = head(
        width,
        height,
        "ブラウザが Web アプリケーションへリクエストを送り、Web アプリケーションがブラウザへレスポンスを返す往復",
    )
    elements += [
        rect(40, 60, 220, 110, NEUT, LINE, 8),
        txt(150, 108, "ブラウザ", 22, INK, "middle", "bold"),
        txt(150, 138, "レスポンスを表示", 14, SUB, "middle"),
        rect(490, 60, 230, 110, BLUE, ACC, 8),
        txt(605, 108, "Web アプリケーション", 19, ACC, "middle", "bold"),
        txt(605, 138, "リクエストを処理", 14, SUB, "middle"),
        line(270, 85, 478, 85, ACC, 2.5, "arrow"),
        txt(380, 68, "リクエスト", 16, ACC, "middle", "bold"),
        line(480, 148, 272, 148, ACC, 2.5, "arrow"),
        txt(380, 178, "レスポンス", 16, ACC, "middle", "bold"),
    ]
    save("fig-1-1.svg", elements)


def fig_2_1():
    width, height = 650, 720
    elements = head(
        width,
        height,
        "ブラウザから届いたリクエストを Puma が受け、Rack の共通インターフェースを介して Sinatra が処理し、レスポンスが逆向きに戻る流れ",
    )

    elements += [
        rect(125, 25, 400, 105, NEUT, LINE, 8),
        txt(325, 72, "ブラウザ", 25, INK, "middle", "bold"),
        txt(325, 103, "HTTP を送受信", 16, SUB, "middle"),
        rect(125, 225, 400, 105, NEUT, LINE, 8),
        txt(325, 272, "Puma", 25, INK, "middle", "bold"),
        txt(325, 303, "Web サーバー", 16, SUB, "middle"),
        '<rect x="75" y="405" width="500" height="90" rx="8" '
        f'fill="{BLUE}" fill-opacity="0.55" stroke="{ACC}" '
        'stroke-width="2" stroke-dasharray="8 7"/>',
        txt(325, 444, "Rack の共通インターフェース", 22, ACC, "middle", "bold"),
        txt(325, 475, "同じ形式で受け渡すための取り決め", 15, SUB, "middle"),
        rect(125, 590, 400, 105, BLUE, ACC, 8),
        txt(325, 637, "Sinatra", 25, ACC, "middle", "bold"),
        txt(325, 668, "ルートを実行", 16, SUB, "middle"),
        line(235, 140, 235, 213, ACC, 2.5, "arrow"),
        line(235, 340, 235, 393, ACC, 2.5, "arrow"),
        line(235, 507, 235, 578, ACC, 2.5, "arrow"),
        line(415, 578, 415, 507, ACC, 2.5, "arrow"),
        line(415, 393, 415, 340, ACC, 2.5, "arrow"),
        line(415, 213, 415, 140, ACC, 2.5, "arrow"),
        # ラベルは矢印の外側に置き、文字と線が重ならないようにする。
        txt(150, 184, "リクエスト ↓", 17, ACC, "middle", "bold"),
        txt(500, 184, "↑ レスポンス", 17, ACC, "middle", "bold"),
    ]
    save("fig-2-1.svg", elements)


def main():
    fig_1_1()
    fig_2_1()


if __name__ == "__main__":
    main()
