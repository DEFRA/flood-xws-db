FROM postgis/postgis
ENV PATH=${PATH}:/scripts
COPY scripts/populate-db /docker-entrypoint-initdb.d/populate-db.sh
WORKDIR /db-init-scripts
COPY area/flood-areas/faa.sql .
COPY area/flood-areas/fwa.sql .
COPY scripts/before.sql .
COPY scripts/after.sql .
COPY contact/scripts ./contact
COPY area/scripts ./area
COPY alert/scripts ./alert
COPY notification/scripts ./notification
