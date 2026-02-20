# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

Table tags {
  id integer [primary key]
  user_id integer [not null]
  name varchar [not null]
  created_at timestamp
}

Table tasks_tags {
  id integer [primary key]
  tag_id integer [not null]
  task_id integer [not null]
  created_at timestamp
}

Table users {
  id integer [primary key]
  username varchar
  email varchar [unique]
  password_digest varchar
  role integer [default: 0, note:'0:一般, 1:管理者']
  created_at timestamp
}

Table tasks {
  id integer [primary key]
  title varchar [not null]
  content text [note: 'Content of the task']
  start_at datetime
  end_at datetime
  priority integer [default: 5, note: '1: 高, 5: 低']
  user_id integer [not null]
  status integer [note:'0: 待處理, 1: 進行中, 2: 已完成']
  created_at timestamp
}

Ref: users.id < tasks.user_id 

Ref tasks_tags: tasks.id < tasks_tags.task_id

Ref tags_tasks: tags.id < tasks_tags.tag_id

Ref: users.id < tags.user_id

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
