# Custom PostgreSQL with TimescaleDB, pgvector, and pgvectorscale
# Based on pgvector image with timescaledb and vectorscale added
ARG PG_VERSION=17
FROM pgvector/pgvector:pg${PG_VERSION}

ARG PG_VERSION=17

# Install timescaledb, postgis, and pgvectorscale
RUN apt-get update && apt-get install -y \
    gnupg \
    lsb-release \
    wget \
    curl \
    ca-certificates \
    unzip \
    && echo "deb https://packagecloud.io/timescale/timescaledb/debian/ $(lsb_release -c -s) main" > /etc/apt/sources.list.d/timescaledb.list \
    && wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | apt-key add - \
    && apt-get update \
    && apt-get install -y \
        timescaledb-2-postgresql-${PG_VERSION} \
        postgresql-${PG_VERSION}-postgis-3 \
        postgresql-${PG_VERSION}-postgis-3-scripts \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install pgvectorscale from Timescale
# pgvectorscale provides optimized vector indexing (DiskANN algorithm)
RUN curl -sL https://github.com/timescale/pgvectorscale/releases/download/0.9.0/pgvectorscale-0.9.0-pg${PG_VERSION}-arm64.zip -o /tmp/pgvectorscale.zip \
    && cd /tmp && unzip pgvectorscale.zip \
    && dpkg -i pgvectorscale-postgresql-${PG_VERSION}_0.9.0-Linux_arm64.deb \
    && rm -rf /tmp/pgvectorscale*

# Configure PostgreSQL for TimescaleDB
# - shared_preload_libraries: load timescaledb extension
# - max_worker_processes: allow enough background workers (default 8 is too low)
# - timescaledb.max_background_workers: workers for TimescaleDB jobs
RUN echo "shared_preload_libraries = 'timescaledb'" >> /usr/share/postgresql/postgresql.conf.sample \
    && echo "max_worker_processes = 64" >> /usr/share/postgresql/postgresql.conf.sample \
    && echo "timescaledb.max_background_workers = 32" >> /usr/share/postgresql/postgresql.conf.sample
