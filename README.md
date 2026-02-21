# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

```mermaid
erDiagram
    users ||--o{ tasks : "creates"
    users ||--o{ tags : "defines"
    tasks ||--o{ tasks_tags : "has"
    tags ||--o{ tasks_tags : "belongs_to"

    users {
        integer id PK
        varchar username
        varchar email
        varchar password_digest
        integer role
        timestamp created_at
    }

    tasks {
        integer id PK
        integer user_id FK
        varchar title
        text content
        datetime start_at
        datetime end_at
        integer priority
        integer status
        timestamp created_at
    }

    tags {
        integer id PK
        integer user_id FK
        varchar name
        timestamp created_at
    }

    tasks_tags {
        integer id PK
        integer task_id FK
        integer tag_id FK
        timestamp created_at
    }
    
```

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
