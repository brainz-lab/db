# Custom PostgreSQL with TimescaleDB and pgvector
# Based on pgvector image with timescaledb added
FROM pgvector/pgvector:pg17

# Install timescaledb
RUN apt-get update && apt-get install -y \
    gnupg \
    lsb-release \
    wget \
    && echo "deb https://packagecloud.io/timescale/timescaledb/debian/ $(lsb_release -c -s) main" > /etc/apt/sources.list.d/timescaledb.list \
    && wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | apt-key add - \
    && apt-get update \
    && apt-get install -y timescaledb-2-postgresql-17 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure timescaledb to be preloaded
RUN echo "shared_preload_libraries = 'timescaledb'" >> /usr/share/postgresql/postgresql.conf.sample
