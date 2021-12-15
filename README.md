# 概要
sinatraを使用して簡易なメモアプリを作成しました。

# DBのセットアップ手順
Postgre SQLがすでにインストールされていることを前提とする。

①psqlにログインする

`psql -U <ユーザ名>`

②以下のコマンドでmemosというDBを作成する

`CREATE DATABASE memos`

③memosデータベースに接続する

`psql -U <ユーザ名> -d <データベース名>`

④データテーブルを作成する

`CREATE TABLE memos_data (id TEXT, title TEXT, content TEXT)`

# 環境変数の設定と利用方法
DBに接続するためのユーザ名やパスワードを環境変数として設定しておく

①Gemfileに以下を追加する

`gem 'dotenv'`

②.envファイルを作成し、.gitignoreに追加する


③.envファイルに以下のように変数を宣言する

`DB_USER = "DBを作成した時のユーザ名"`
`DB_PASSWORD = "DBを作成した時のパスワード"`

④main.rbファイルで環境変数を利用する

`Dotenv.load`
`PG.connect(host: 'localhost', user: ENV['DB_USER'], password: ENV['DB_PASSWORD'], dbname: 'memos')`

# アプリケーション実行手順
①`git clone`でリポジトリをローカルにクローンする

`git clone https://github.com/machida-being/Fjord_memo_app`

②クローンしたリポジトリに移動する

`cd Fjord_memo_app`

③`bundle install`で必要なgemをインストールする 

`bundle install`

④環境変数と利用方法の項目を実行する


⑤`main.rb`を以下のコマンドで実行する 

`bundle exec ruby main.rb`

⑥`http://localhost:4567/memos`にアクセスする <br>
