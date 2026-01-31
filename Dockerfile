# Custom PostgreSQL with TimescaleDB and pgvector
# Based on pgvector image with timescaledb added
ARG PG_VERSION=18
FROM pgvector/pgvector:pg${PG_VERSION}

ARG PG_VERSION=18

# Install timescaledb and postgis
RUN apt-get update && apt-get install -y \
    gnupg \
    lsb-release \
    wget \
    && echo "deb https://packagecloud.io/timescale/timescaledb/debian/ $(lsb_release -c -s) main" > /etc/apt/sources.list.d/timescaledb.list \
    && wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | apt-key add - \
    && apt-get update \
    && apt-get install -y \
        timescaledb-2-postgresql-${PG_VERSION} \
        postgresql-${PG_VERSION}-postgis-3 \
        postgresql-${PG_VERSION}-postgis-3-scripts \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure PostgreSQL for TimescaleDB
# - shared_preload_libraries: load timescaledb extension
# - max_worker_processes: allow enough background workers (default 8 is too low)
# - timescaledb.max_background_workers: workers for TimescaleDB jobs
RUN echo "shared_preload_libraries = 'timescaledb'" >> /usr/share/postgresql/postgresql.conf.sample \
    && echo "max_worker_processes = 64" >> /usr/share/postgresql/postgresql.conf.sample \
    && echo "timescaledb.max_background_workers = 32" >> /usr/share/postgresql/postgresql.conf.sample
