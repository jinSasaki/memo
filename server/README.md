# memo-server
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

```sh
$ mongod --fork --logpath ./log/mongo.log --port 27017 --dbpath ./db/mongo
```

Start server

```sh
$ npm start
```

# API Document
## End Point
`/api/v1`

in local: `localhost:3000/api/v1`

## Request Header

Header          | Description                                   | Example                                | Requirement
--------------- | --------------------------------------------- | -------------------------------------- | -----------
`X-App-Token`   | Accept only authenticated application access. | `4F4A4A9D-D116-4DF3-8FB6-48F792F88EC8` | required
`X-Platform`    | Platform.                                     | `ios`                                  | optional
`X-App-Version` | Application Version.                          | `1.0.0`                                | optional

### `X-App-Token`
- jinSasaki/Memo/ios: `F6FAC3AE-0A00-4724-982C-0B0B5F0C00FA`

## Error Response
- error (Object)
  - code (int)
  - message (string)

**Status Code**

Status Code | Description
----------- | -----------------------------------------------------------------------------------------------------------------
400         | Bad Request. May be request has invalid parameters or something wrong.
401         | Unauthorized.
404         | Not Found. URL is not found. However return 400 if the request to PUT and DELETE has not found memo by `:memoId`.
409         | Conflicts data.

**Response**

```json
// 400
{
  "error": {
    "code": 400,
    "message": "INVALID_PARAMETER"
  }
}
```

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
// 200
{
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
```

### `POST /memo`
Create a new memo.

**Request Body(JSON)**
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
// 201
{
  "id": "7f986bea-5997-4f2d-90cb-e1f5da1e29e0",
  "title": "test post",
  "body": "this is a content for memo.\n\n Thanks.",
  "author": "Sasakky",
  "editor": "Sasakky",
  "created": 1461216860,
  "updated": 1461216860
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
// 200
{
    "title": "test post is edited",
    "body": "this is a content for memo.\n\n Thanks.",
    "editor": "Jin Sasaki"
}
```

**Response**

```json
{
  "id": "7f986bea-5997-4f2d-90cb-e1f5da1e29e0",
  "title": "test post is edited",
  "body": "this is a content for memo.\n\n Thanks.",
  "author": "Sasakky",
  "editor": "Jin Sasaki",
  "created": 1461216860,
  "updated": 1461216890
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
// 204
{}
```
