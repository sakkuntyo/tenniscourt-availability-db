# required args
- PG_MAJOR=18
- PGDATA=/var/lib/postgresql/18/docker
- POSTGRES_PASSWORD=<password>
- POSTGRES_USER=<user id>
- POSTGRES_DB=<database name>

# table schema

refs [init](./init/01_schema.sql)

# sample app

- https://github.com/sakkuntyo/ace-tenniscourt-logger
- https://github.com/sakkuntyo/ichikawa-tenniscourt-logger
