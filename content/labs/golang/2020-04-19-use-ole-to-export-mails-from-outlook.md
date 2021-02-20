+++
title = "GolangでOLEを利用してOutlookを操作、メールをエクスポートする"
date = 2020-04-19T18:12:22+08:00
description = "GolangからOLEを利用することでOutlookを操作してみました。"
tags = []
Categories = ["golang", "programming"]
+++

お仕事上の便利ツール開発を目的に、GolangからOLE経由でOutlookを操作してみました。

[Big Sky :: GoでWindowsのCOMを操作出来るライブラリgo-ole書いた。](https://mattn.kaoriya.net/software/lang/go/20110122001853.htm)を利用させていただくことで、Oleの操作は問題がなかったのですが、問題はどのようなAPIをOutlook側が提供しているかを調べることでした。。

## やりたいこと
指定した日付以降に受信・送信したメールを、受信ボックス・送信ボックスから指定したフォルダにエクスポートしたいです。

## 先人の跡を辿る
他の言語でOutlookを操作した場合のサンプルがインターネット上に多く公開されているため、それを参考にします。Outlookが提供するAPIは同一のはずで、後は上記のライブラリのお作法に則って呼び出すだけのはずだからです。

見つけたサイトはこちら:

- [Win32OLE 活用法 【第 5 回】 Outlook](https://magazine.rubyist.net/articles/0007/0007-Win32OLE.html)
- [PowerShellでOutlookにアクセスする](https://kapibara-sos.net/archives/394)

## スニペット集
後で参照するためのスニペット集です。

### 受信ボックス or 送信ボックスのアイテムを一つずつなめていく
`olFolderInbox`という定数を使っていますが、値は6になります。送信ボックの場合には5を指定してください;

```
	folder := oleutil.MustCallMethod(ns, "GetDefaultFolder", olFolderInbox).ToIDispatch()

	items := oleutil.MustCallMethod(folder, "Items").ToIDispatch()

	count := oleutil.MustGetProperty(items, "Count").Value().(int32)

	for i := 1; i <= int(count); i++ {
		// Itemsの中からi番目のItemを取得する
		item, err := oleutil.GetProperty(items, "Item", i)

		// 無事に取得できたら
		if err == nil && item.VT == ole.VT_DISPATCH {
			// do something
		}
	}
```

### メールかどうかを判別する
受信ボックスや送信ボックスの中にあるアイテムがメールかどうかを判別する必要があります。こんな感じでした:

```
// メールオブジェクトかどうかを判定する
func isMail(oleobj *ole.VARIANT) (bool, error) {
	classObj, err := oleutil.GetProperty(oleobj.ToIDispatch(), "Class")
	if err == nil {
		if classObj.Value() == olMail {
			return true, nil
		}
	}

	return false, err
}
```

### メールから各種情報を取得する
`oleutil.GetProperty()`メソッドを利用します。どのような情報が取得できるかは、[MailItem object (Outlook) | Microsoft Docs](https://docs.microsoft.com/en-us/office/vba/api/outlook.mailitem)を参照すると幸せになれると思います。

```
				// 件名を取得する
				subject, err := oleutil.GetProperty(item.ToIDispatch(), "Subject")
				if err != nil {
					log.Println(err)
				}

				// 送信者を取得する
				sender, err := oleutil.GetProperty(item.ToIDispatch(), "SenderName")
				if err != nil {
					log.Println(err)
				}

				// 日付を取得する
				receivedTime, err := oleutil.GetProperty(item.ToIDispatch(), "ReceivedTime")
				if err != nil {
					log.Println(err)
				}
```

### 受信日時・送信日時のタイムゾーンを修正する
どこの問題か判別できていませんが、取得した受信日時・送信日時はローカルの日時になっているのですが、タイムゾーンはUTC固定になっています。これではうまく日時をキーにしたエクスポートができないため、タイムゾーンをローカルのタイムゾーンに変換してあげます:

```
// Outlookから取得した受信日時がローカル日時だけど、タイムゾーンがUTC固定のため、
// ローカルタイムゾーンでtime.Timeオブジェクトを作成し直す
func modifyTimeZone(t *time.Time) time.Time {
	loc, _ := time.LoadLocation("Local")
	tmp := t.Format(DateFormat)

	modified, err := time.ParseInLocation(DateFormat, tmp, loc)
	if err != nil {
		log.Fatal(err)
	}

	return modified
}
```


## 成果物
[kazu634/Outlook -  Outlook - Gitea: Git with a cup of tea](https://gitea.kazu634.com/kazu634/Outlook)で成果物を公開しています。

## 参考
- [Big Sky :: GoでWindowsのCOMを操作出来るライブラリgo-ole書いた。](https://mattn.kaoriya.net/software/lang/go/20110122001853.htm)
- [GitHub - go-ole/go-ole: win32 ole implementation for golang](https://github.com/go-ole/go-ole)
- [Win32OLE 活用法 【第 5 回】 Outlook](https://magazine.rubyist.net/articles/0007/0007-Win32OLE.html)
- [PowerShellでOutlookにアクセスする](https://kapibara-sos.net/archives/394)