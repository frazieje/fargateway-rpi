#!/bin/bash

curl -X PUT http://127.0.0.1:5984/_users

curl -X PUT http://127.0.0.1:5984/_replicator

curl -X PUT http://127.0.0.1:5984/_global_changes

curl -X PUT http://127.0.0.1:5984/admins

curl -H "Content-Type: application/json" \
     -d "{\"language\":\"javascript\",\"views\":{\"by_email\":{\"map\":\"function (doc) {\n  emit(doc.email); \n}\"}}}" \
     -X PUT http://127.0.0.1:5984/admins/_design/docs

curl -X PUT http://127.0.0.1:5984/users

curl -H "Content-Type: application/json" \
     -d @usersview.json \
     -X PUT http://127.0.0.1:5984/users/_design/docs
