# memo
## Requirement
- Node v4.1.x
- npm 3.7.x
- mongoDB

## Installation

```
$ npm install
```

## Start
Start mongoDB

```
$ mongod --fork --logpath ./log/mongo.log --port 27017 --dbpath ./db/mongo
```

Start server

```
$ npm start
```

# API Document
## End Point
`/api/v1`

in local: `localhost:3000/api/v1`

## Route
- `GET /memo`
- `POST /memo`
- `PUT /memo/:memoId`
- `DELETE /memo/:memoId`

### `GET /memo`
Get all memo which is not deleted. Sorted by `updated` DESC.

#### Example
**Request**

```
GET /api/v1/memo
```

**Response**

```json
{
  "status": 200,
  "result": {
    "memos": [
      {
        "id": "7f986bea-5997-4f2d-90cb-e1f5da1e29e0",
        "title": "test post",
        "body": "this is a content for memo.\n\n Thanks.",
        "author": "Sasakky",
        "editor": "Sasakky",
        "created": 1461216860,
        "updated": 1461216860
      }
    ]
  }
}
```

### `POST /memo`
Create a new memo.

**Body(JSON)**
- title (string)
- body (string)
- author (string)

#### Example
**Request**

```
POST /api/v1/memo
```

Body

```json
{
    "title": "test post",
    "body": "this is a content for memo.\n\n Thanks.",
    "author": "Sasakky"
}
```

**Response**

```json
{
  "status": 201,
  "result": {
    "memo": {
      "id": "7f986bea-5997-4f2d-90cb-e1f5da1e29e0",
      "title": "test post",
      "body": "this is a content for memo.\n\n Thanks.",
      "author": "Sasakky",
      "editor": "Sasakky",
      "created": 1461216860,
      "updated": 1461216860
    }
  }
}
```

### `PUT /memo/:memoId`
Update the memo by id.

**Body(JSON)**
- title (string)
- body (string)
- editor (string)

#### Example
**Request**

```
POST /api/v1/memo/7f986bea-5997-4f2d-90cb-e1f5da1e29e0
```

Body

```json
{
    "title": "test post is edited",
    "body": "this is a content for memo.\n\n Thanks.",
    "editor": "Jin Sasaki"
}
```

**Response**

```json
{
  "status": 200,
  "result": {
    "memo": {
      "id": "7f986bea-5997-4f2d-90cb-e1f5da1e29e0",
      "title": "test post is edited",
      "body": "this is a content for memo.\n\n Thanks.",
      "author": "Sasakky",
      "editor": "Jin Sasaki",
      "created": 1461216860,
      "updated": 1461216890
    }
  }
}
```

### `DELETE /memo`
Delete the memo by id.

#### Example
**Request**

```
DELETE /api/v1/memo/7f986bea-5997-4f2d-90cb-e1f5da1e29e0
```

**Response**

```json
{
  "status": 204,
  "result": {}
  }
}
```
