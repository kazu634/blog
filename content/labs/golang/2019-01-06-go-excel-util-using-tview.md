+++
title = "GolangのCUIライブラリを使ってExcelの中身を確認するツールを作ってみた"
date = 2019-01-06T23:07:40+07:00
description = "Golangのライブラリtviewを使うと、お気軽にCUIを作成できるみたいなので、お試しで使ってみました。今回はExcelファイルの中身を確認するよ。"
tags = []
categories = ["golang", "programming"]
images = ["https://farm5.staticflickr.com/4849/45718165635_328355a940_z.jpg"]
+++

「[gocuiのコンポーネントライブラリを作った話](https://qiita.com/gorilla0513/items/ea26398e6dfcaf0674c2)」という記事を読んでいて、[rivo/tview](https://github.com/rivo/tview)というライブラリを使うと、CUIをお手軽に作成できるようなので、お試しで使ってみました。

## できたもの
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/45718165635/in/dateposted/" title="tview Sample"><img src="https://farm5.staticflickr.com/4849/45718165635_328355a940_z.jpg" width="640" height="402" alt="tview Sample"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

## くわしく説明
細々と説明していきます。

### Excelファイルの操作の仕方
[GolangでExcelファイル\(\.xlsx\)を読み込む](http://localhost:1313/2017/09/03/golang-to-handle-xlsx-files/)を参考にしましたよ。

### ソースコード
こちらになります:

```
package main

import (
        "fmt"
        "os"
        "strconv"

        "github.com/gdamore/tcell"
        "github.com/rivo/tview"
        "github.com/tealeg/xlsx"
)

func main() {
        app := tview.NewApplication()

        // Generate Sheet List Instance
        generateSheets := func() *tview.List {
                result := tview.NewList().ShowSecondaryText(false)
                result.SetBorder(true).SetTitle("Sheets")

                return result
        }
        sheets := generateSheets()

        // Generate Column Table Instance
        tables := tview.NewTable().SetBorders(true)
        tables.SetBorder(true).SetTitle("Contents")

        // Create Excel instance
        createExcelInstance := func(excelFileName string) *xlsx.File {
                xlFile, err := xlsx.OpenFile(excelFileName)
                if err != nil {
                        panic(err)
                }

                return xlFile
        }
        excel := createExcelInstance("./test.xlsx")

        // Add Sheets to Sheet List
        addSheets := func(sheets *tview.List, excelInstance *xlsx.File) {
                for _, sheet := range excelInstance.Sheets {
                        tmp := sheet

                        sheets.AddItem(tmp.Name, "", 0, func() {
                                // Clear the table
                                tables.Clear()

                                for i, row := range tmp.Rows {
                                        // Add row number:
                                        tables.SetCellSimple(i, 0, strconv.Itoa(i+1))

                                        for j, cell := range row.Cells {
                                                tables.SetCellSimple(i, j+1, cell.String())
                                        }
                                }

                                tables.ScrollToBeginning()
                                app.SetFocus(tables)
                        })

                        sheets.SetDoneFunc(func() {
                                app.Stop()
                                os.Exit(0)
                        })

                        tables.SetDoneFunc(func(key tcell.Key) {
                                switch key {
                                case tcell.KeyEscape:
                                        tables.Clear()
                                        app.SetFocus(sheets)
                                case tcell.KeyEnter:
                                        // Press Enter to select the rows
                                        tables.SetSelectable(true, false)
                                }
                        })

                        tables.SetSelectedFunc(func(row int, column int) {
                                for i := 0; i < tables.GetColumnCount(); i++ {
                                        tables.GetCell(row, i).SetTextColor(tcell.ColorRed)
                                }
                                tables.SetSelectable(false, false)
                        })
                }

        }
        addSheets(sheets, excel)

        flex := tview.NewFlex().
                AddItem(sheets, 0, 1, true).
                AddItem(tables, 0, 5, false)

        if err := app.SetRoot(flex, true).Run(); err != nil {
                fmt.Printf("Error running application: %s\n", err)
        }
}
```

## 今後の展望
お仕事で利用しているとあるExcelファイル、とても分析がし辛いフォーマットになっていて、それをいい感じにするツールを個人用に作成していたのですが、誰でも活用できるようにしていこうと思っています。Excelマクロは個人的に触りたくないので、これでどうにかしていこうと思っています。

## 参考
- [rivo/tview: Rich interactive widgets for terminal\-based UIs written in Go](https://github.com/rivo/tview)
- [gocuiのコンポーネントライブラリを作った話 \- Qiita](https://qiita.com/gorilla0513/items/ea26398e6dfcaf0674c2)

