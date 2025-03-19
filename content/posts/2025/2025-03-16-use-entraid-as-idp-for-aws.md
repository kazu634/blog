+++
title = "EntraIDをAWSのIdPとして利用して、シングルサインオンする"
date = 2025-03-16T22:23:00+09:00
lastmod = 2025-03-16T22:23:00+09:00
description = "お仕事で部門のサーバー管理者・クラウド管理者になって気になったものを検証してみたシリーズだよ。EntraIDをAWSのIdPとして利用して、シングルサインオンするための手順をまとめたよ"
tags = ["aws", "クラウド"]
categories = ["インフラ"]
author = "kazu634"
images = ["ogp/2025-03-16-use-entraid-as-idp-for-aws.webp"]
+++

お仕事で部門のサーバー管理者・クラウド管理者になって気になったものを検証してみたシリーズだよ。EntraIDをAWSのIdPとして利用して、シングルサインオンするための手順をまとめたよ

大まかな見取り図は以下の通りです:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54390453359/in/datetaken/" title="Untitled"><img src="https://live.staticflickr.com/65535/54390453359_cd965fd65a_z.jpg" width="640" height="301" alt="Untitled"/></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

## 必要なもの
- `EntraID` (個人のアカウントで`Azure`契約すると、自動的に`EntraID`が作成されるから、それを利用するのがお手軽)
- `AWS`

## SSO の設定手順
`SSO`に必要となる手順をまとめていきます。

1. `AWS`: `SSO`の`IdP`を指定し、設定ファイルを取得する
2. `EntraID`: Enterprise Applicationの登録
3. `EntraID`: `SSO` (SAML連携) の設定
4. `EntraID`: 連携する`Claim`の設定
5. `EntraID`: AWSにログインを許可するユーザー・グループの指定
6. `EntraID`: Federation設定用のファイルを取得する
7. `AWS`: Federation設定y設定用のファイルの読み込み
8. `AWS`: Automatic Provisioningの有効化
9. `EntraID`: Provisioningの設定
10. `EntraID`: Provisioningの実施
11. `AWS`: Permission sets作成
12. `AWS`: プロビジョニングされたユーザー・グループへの権限割り当て
13. 動作確認

### AWS: SSOのIdPを指定し、設定ファイルを取得する
AWS側にログインし、`IAM Identity Center`を開きます。`[Settings]`をクリックします。下部の`[Identity source]`をクリックし、右側の`[Actions]`から、`[Change identity source]`をクリックします。

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389751664/in/datetaken/" title="2025_03_16_13_41"><img src="https://live.staticflickr.com/65535/54389751664_5a0cb723ab_z.jpg" width="616" height="640" alt="2025_03_16_13_41"/></a>

`IdP`の種類として、`External identity provider`を選択し、`[Next]`ボタンをクリックします。
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54388683037/in/datetaken/" title="2025_03_16_13_45"><img src="https://live.staticflickr.com/65535/54388683037_1c5c3d359e_z.jpg" width="616" height="640" alt="2025_03_16_13_45"/></a>

`AWS`側の`IdP`の設定をまとめたファイルをダウンロードします。図の`[Download metadata file]`をクリックし、ダウンロードします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389755424/in/datetaken/" title="2025_03_16_13_48"><img src="https://live.staticflickr.com/65535/54389755424_438b66faa7_z.jpg" width="616" height="640" alt="2025_03_16_13_48"/></a>

### EntraID: Enterprise Applicationの登録
`EntraID`にログインして、左側のペインから`[Enterprise applications]`をクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54390020085/in/datetaken/" title="2025_03_16_13_49"><img src="https://live.staticflickr.com/65535/54390020085_cb1f0680ac_z.jpg" width="616" height="640" alt="2025_03_16_13_49"/></a>

表示される画面で`[New application]`をクリックします。

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54388769702/in/datetaken/" title="2025_03_16_13_51"><img src="https://live.staticflickr.com/65535/54388769702_2b8629356d_z.jpg" width="616" height="640" alt="2025_03_16_13_51"/></a>

検索用のテキストボックスに「aws iam」と入力し、表示された「AWS IAM Identity Center (successor to AWS Single Sign-On」をクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389645231/in/datetaken/" title="2025_03_16_13_52"><img src="https://live.staticflickr.com/65535/54389645231_fb5f97aebd_z.jpg" width="616" height="640" alt="2025_03_16_13_52"/></a>

次の画面が表示されます。`[Create]`ボタンをクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389874708/in/datetaken/" title="2025_03_16_13_52-02"><img src="https://live.staticflickr.com/65535/54389874708_015c5ed3d3_z.jpg" width="616" height="640" alt="2025_03_16_13_52-02"/></a>

### EntraID: SSO (SAML連携) の設定
SAML連携の設定を行います。作成した`AWS IAM Identity Center`をクリックし、左側のペインから`[Single sign-on]`をクリック、右側に表示される`SAML`をクリックします:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389840454/in/datetaken/" title="2025_03_16_13_54"><img src="https://live.staticflickr.com/65535/54389840454_c2c10cb975_z.jpg" width="616" height="640" alt="2025_03_16_13_54"/></a>

表示される画面で`Upload metadata file`をクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389874713/in/datetaken/" title="2025_03_16_13_55"><img src="https://live.staticflickr.com/65535/54389874713_3750856e91_z.jpg" width="616" height="640" alt="2025_03_16_13_55"/></a>

`AWS`からダウンロードした設定ファイルをアップロードします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389840439/in/datetaken/" title="2025_03_16_13_56"><img src="https://live.staticflickr.com/65535/54389840439_e7442bc2f7_z.jpg" width="640" height="223" alt="2025_03_16_13_56"/></a>

`Save`ボタンをクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54388769782/in/datetaken/" title="2025_03_16_13_57"><img src="https://live.staticflickr.com/65535/54388769782_036524a385_z.jpg" width="616" height="640" alt="2025_03_16_13_57"/></a>

### EntraID: 連携するClaimの設定
以下の`Claim`を追加します:

| #   | Type  | Claim          | Value              |
| --- | ----- | -------------- | ------------------ |
| 1   | -     | Role           | user.assignedroles |
| 2   | Group | Security Group | Group ID           |
 
`Attributes & Claims`から、`Add new claim`をクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389840494/in/datetaken/" title="2025_03_16_14_04"><img src="https://live.staticflickr.com/65535/54389840494_7431012d03_z.jpg" width="616" height="640" alt="2025_03_16_14_04"/></a>

以下のように入力し、`Save`ボタンをクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389840499/in/datetaken/" title="2025_03_16_14_04-02"><img src="https://live.staticflickr.com/65535/54389840499_158bbcff4e_z.jpg" width="616" height="640" alt="2025_03_16_14_04-02"/></a>

次に`Add a group claim`をクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389645276/in/datetaken/" title="2025_03_16_14_07"><img src="https://live.staticflickr.com/65535/54389645276_23200e7368_z.jpg" width="616" height="640" alt="2025_03_16_14_07"/></a>

`Security groups`を選択し、`Group ID`を選択します。その後、`Save`ボタンをクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389874783/in/datetaken/" title="2025_03_16_14_07-02"><img src="https://live.staticflickr.com/65535/54389874783_dde9e3ea44_z.jpg" width="616" height="640" alt="2025_03_16_14_07-02"/></a>

### EntraID: AWSにログインを許可するユーザー・グループの指定
左側のペインの`Users and groups`から、AWSにログインを許可させたいユーザー・グループを指定します:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54388769822/in/datetaken/" title="2025_03_16_14_17"><img src="https://live.staticflickr.com/65535/54388769822_a5723fc421_z.jpg" width="616" height="640" alt="2025_03_16_14_17"/></a>

### EntraID: Federation設定用のファイルを取得する
連携用のファイルをダウンロードします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389840509/in/datetaken/" title="2025_03_16_14_10"><img src="https://live.staticflickr.com/65535/54389840509_de751fe1aa_z.jpg" width="616" height="640" alt="2025_03_16_14_10"/></a>

### AWS: Federation設定用のファイルの読み込み
`EntraID`からダウンロードしたファイルを読み込ませます。先ほどメタデータをダウンロードしたページ下部の`IdP SAML metadata`のセクションにある`Choose file`をクリックし、`EntraID`から取得したファイルをアップロードします:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389840524/in/datetaken/" title="2025_03_16_14_11"><img src="https://live.staticflickr.com/65535/54389840524_2043b0b1c9_z.jpg" width="616" height="640" alt="2025_03_16_14_11"/></a>

ファイルを選択すると、次のようになります。`Next`ボタンをクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389840549/in/datetaken/" title="2025_03_16_14_12"><img src="https://live.staticflickr.com/65535/54389840549_0f6c5f89b8_z.jpg" width="616" height="640" alt="2025_03_16_14_12"/></a>

次の画面が表示されます。`Change Identity source`をクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389645321/in/datetaken/" title="2025_03_16_14_12-02"><img src="https://live.staticflickr.com/65535/54389645321_2f86129f4b_z.jpg" width="616" height="640" alt="2025_03_16_14_12-02"/></a>

### AWS: Automatic Provisioningの有効化
この段階では、`AWS`側にアカウントが存在しないため、ログインできません。`EntraID`側で指定されたユーザー・グループを自動的に`AWS`側のアカウントとして追加するための設定を実施します。

以下の画面が表示されていると思いますので、`Automatic Provisioning`で`Enable`ボタンをクリックします:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389645316/in/datetaken/" title="2025_03_16_14_30"><img src="https://live.staticflickr.com/65535/54389645316_8ec4d7c240_z.jpg" width="616" height="640" alt="2025_03_16_14_30"/></a>

`EntraID`側で指定してあげる必要がある`SCIM endpoint`と`Access token`が表示されます。メモしておきましょう:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389874843/in/datetaken/" title="2025_03_16_14_31"><img src="https://live.staticflickr.com/65535/54389874843_537cb2a16a_z.jpg" width="640" height="355" alt="2025_03_16_14_31"/></a>

### EntraID: Provisioningの設定
EntraID側で必要となるアカウントプロビジョニングの設定を説明します。`AWS IAM Identity Center`で表示される、`Provision User Accounts`をクリックします:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389645351/in/datetaken/" title="2025_03_16_14_32"><img src="https://live.staticflickr.com/65535/54389645351_64bd3703ee_z.jpg" width="616" height="640" alt="2025_03_16_14_32"/></a>

対象を指定します:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54390020170/in/datetaken/" title="2025_03_16_14_18"><img src="https://live.staticflickr.com/65535/54390020170_00e4995d1d_z.jpg" width="616" height="640" alt="2025_03_16_14_18"/></a>

`Provisioning Mode`を`Automatic`に指定します。
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54388769872/in/datetaken/" title="2025_03_16_14_34"><img src="https://live.staticflickr.com/65535/54388769872_f3b406d326_z.jpg" width="616" height="640" alt="2025_03_16_14_34"/></a>

### EntraID: Provisioningの実施
`AWS IAM Identity Center`の`Provisioning`をクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54388769877/in/datetaken/" title="2025_03_16_14_33"><img src="https://live.staticflickr.com/65535/54388769877_9915848c2c_z.jpg" width="616" height="640" alt="2025_03_16_14_33"/></a>

`Start Provisioning`をクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389840604/in/datetaken/" title="2025_03_16_14_36"><img src="https://live.staticflickr.com/65535/54389840604_5436548827_z.jpg" width="616" height="640" alt="2025_03_16_14_36"/></a>

しばらく経つと、以下のように表示され、プロビジョニングが完了したことがわかります:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389840644/in/datetaken/" title="2025_03_16_14_36-02"><img src="https://live.staticflickr.com/65535/54389840644_8d05af0634_z.jpg" width="616" height="640" alt="2025_03_16_14_36-02"/></a>

`AWS`側のユーザーを見ると、プロビジョニングされていることがわかります:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389840639/in/datetaken/" title="2025_03_16_14_43"><img src="https://live.staticflickr.com/65535/54389840639_1e0fe0d6d1_z.jpg" width="616" height="640" alt="2025_03_16_14_43"/></a>

### AWS: Permission sets作成
`AWS`にプロビジョニングされたユーザーに対して、権限 (= `Permission sets`)を付与します。まずは`Permission sets`を作成していきます。今回は`Administrator Access`用の`Permission sets`を作成していきます:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389645381/in/datetaken/" title="2025_03_16_14_44"><img src="https://live.staticflickr.com/65535/54389645381_fcbe5a31c7_z.jpg" width="616" height="640" alt="2025_03_16_14_44"/></a>

### AWS: プロビジョニングされたユーザー・グループへの権限割り当て
`IAM Identity Center` - `AWSOrganizations: AWS accounts`をクリックします。紐付けたい`AWS`アカウントを選択し、`Assign users or groups`ボタンをクリックします:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389874923/in/datetaken/" title="2025_03_16_14_50-03"><img src="https://live.staticflickr.com/65535/54389874923_95708776f8_z.jpg" width="616" height="640" alt="2025_03_16_14_50-03"/></a>

紐付けるユーザーやグループを指定し、`Next`ボタンをクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389874903/in/datetaken/" title="2025_03_16_14_48"><img src="https://live.staticflickr.com/65535/54389874903_816ea2e32b_z.jpg" width="616" height="640" alt="2025_03_16_14_48"/></a>

紐づける`Permission set`を指定し、`Next`ボタンをクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389645421/in/datetaken/" title="2025_03_16_14_50"><img src="https://live.staticflickr.com/65535/54389645421_da5cdb3984_z.jpg" width="616" height="640" alt="2025_03_16_14_50"/></a>

確認の画面が表示されます。`Create`ボタンをクリックします:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389874943/in/datetaken/" title="2025_03_16_14_50-02"><img src="https://live.staticflickr.com/65535/54389874943_62df1cfdbe_z.jpg" width="616" height="640" alt="2025_03_16_14_50-02"/></a>

### 動作確認
`EntraID`に表示される`User access URL`をコピーし、ブラウザで接続してみます:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389898328/in/datetaken/" title="2025_03_16_15_28"><img src="https://live.staticflickr.com/65535/54389898328_7f06366506_z.jpg" width="616" height="640" alt="2025_03_16_15_28"/></a>

アカウント選択の画面が表示され、`SSO`が機能しているように見えます:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54388793972/in/datetaken/" title="2025_03_16_15_29"><img src="https://live.staticflickr.com/65535/54388793972_84a800c418_z.jpg" width="616" height="640" alt="2025_03_16_15_29"/></a>

ログイン後、以下のように表示されれば成功です:
<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/54389668896/in/datetaken/" title="2025_03_16_15_29-02"><img src="https://live.staticflickr.com/65535/54389668896_61b222933f_z.jpg" width="616" height="640" alt="2025_03_16_15_29-02"/></a>
## References
- [AWS Single Sign\-On with Microsoft Entra ID](https://never-stop-learning.de/aws-single-sign-on-with-microsoft-entra-id/)