+++
title = "GolangでExcelファイル(.xlsx)を読み込む"
date = 2017-09-03T22:47:31+08:00
description = "GolangでどうすればExcelファイルを読み込めるのか調べました。"
tags = []
Categories = ["Golang"]
images = ["images/6052788455_79a263eeea.jpg"]
+++

`github.com/tealeg/xlsx`を用いればいいみたいということがわかりました。

## とりあえず使ってみる
`github`のページに記載してあるように動かします。ここでは`test_draft.xlsx`を読み込むこととします。

```
package main

import (
	"fmt"

	"github.com/tealeg/xlsx"
)

func main() {
    excelFileName := "./test_draft.xlsx"
    xlFile, err := xlsx.OpenFile(excelFileName)
    if err != nil {
        panic(err)
    }
    for _, sheet := range xlFile.Sheets {
        for _, row := range sheet.Rows {
            for _, cell := range row.Cells {
                text := cell.String()
                fmt.Printf("%s\n", text)
            }
        }
    }
}
```

## 細々とした使い方
きちんと利用するにあたって調べたことをまとめます。

### シート名を取得したい
シート名は以下のようにして参照します。`sheet.Name`にシート名が格納されます:

```
package main

import (
	"fmt"

	"github.com/tealeg/xlsx"
)

func main() {
    excelFileName := "./test_draft.xlsx"

    xlFile, err := xlsx.OpenFile(excelFileName)
    if err != nil {
        panic(err)
    }

    for _, sheet := range xlFile.Sheets {
        if sheet.Name != "Sheet1" {
	    	      fmt.Println(sheet.Name)
	       }
    }
}
```

### 列ごとに何かする
こんな感じになります:

```
package main

import (
	"fmt"

	"github.com/tealeg/xlsx"
)

func main() {
    excelFileName := "./test_draft.xlsx"

    xlFile, err := xlsx.OpenFile(excelFileName)
    if err != nil {
        panic(err)
    }

    for _, sheet := range xlFile.Sheets {
        for _, row := range sheet.Rows {
            // 列ごとの処理。例えばこんな感じ
            for _, cell := range row.Cells
                // セル単位の処理
            }
        }
    }
}
```

## 最後に
とりあえずメモでした。
