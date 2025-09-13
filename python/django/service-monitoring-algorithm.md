# サービスの自動再起動

## アルゴリズム 

### 0. 初期状態

STATUS=STARTING
STARTING_AT=<現在時刻>
RESTARTING_SERVICE=

### 1.チェック

以下を収集
- Exitになっているコンテナ
- Consumer登録が解除されているCeleryコンテナ

ここで、何も検出されなければ
STATUS=RUNNING
STARTING_AT=
RESTARTING_SERVICE=
にする。

### 2.再起動方法の決定

以下いずれかの場合
- 1で2つ以上再起動を必要としているコンテナがある場合
- 再起動を必要としているコンテナが他から依存されているコンテナの場合
→ 全体再起動へ

STARTING_ATから10分以上経過している場合
→ STATUS=ERRORとして全体再起動へ

他から依存されていないコンテナが1つだけ再起動を必要としている場合
→ 単体再起動へ

### 3. 全体再起動

STATUS=STARTINGの場合は処理をスキップ。

状態を以下の通り更新
STATUS=STARTING
STARTING_AT=<日時>
RESTARTING_SERVICE=

全体再起動コマンドを実行。

### 4. 単体再起動

STATUS=STARTING または
RESTARTING_SERVICE=再起動しようとしているサービス
の場合は処理をスキップ。

状態を以下の通り更新
RESTARTING_SERVICE=<コンテナ名>
STARTING_AT=<日時>

単体再起動コマンドを実行

## こういう場合どうなる?

全体再起動をしても、1のチェックで何か検出され続ける場合。
→ 10分おきに再起動される

