curl http://localhost:8585/ping

curl -X POST http://localhost:8585/tables -d '{"name":"users"}'
curl -X GET http://localhost:8585/tables
curl -X GET http://localhost:8585/tables/users
curl -X POST http://localhost:8585/tables/users/properties -d '{"name":"username","transient":false,"dataType":"string"}'
curl http://localhost:8585/tables/users/properties
curl http://localhost:8585/tables/users/properties/username

curl -X PUT http://localhost:8585/tables/users/objects/john/events/2012-01-20T00:00:00Z -d '{"data":{"username":"johnny1000"}}'
curl http://localhost:8585/tables/users/objects/john/events
curl -X GET http://localhost:8585/tables/users/stats

gharchive
=========
curl -X GET http://localhost:8585/tables/gharchive
curl -X GET http://localhost:8585/tables/gharchive/stats
curl http://localhost:8585/tables/gharchive/objects/DavidAntaramian/events
