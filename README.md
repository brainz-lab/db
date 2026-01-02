# Brainz Lab Database

Custom PostgreSQL image with TimescaleDB and pgvector extensions pre-installed.

## Extensions

- **PostgreSQL 17** - Latest stable release
- **TimescaleDB 2** - Time-series data support with hypertables
- **pgvector** - Vector similarity search for AI/ML embeddings

## Usage

### Docker Hub

```bash
docker pull brainzllc/db:latest
docker run -d \
  --name brainzlab-db \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  brainzllc/db:latest
```

### Docker Compose

```yaml
services:
  db:
    image: brainzllc/db:latest
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    command:
      postgres
      -c shared_preload_libraries=timescaledb
      -c timescaledb.telemetry_level=off

volumes:
  pgdata:
```

## Building Locally

```bash
docker build -t brainzllc/db:latest .
```

## Enabling Extensions

After connecting to your database:

```sql
-- Enable TimescaleDB
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- Enable pgvector
CREATE EXTENSION IF NOT EXISTS vector;
```

## License

MIT
