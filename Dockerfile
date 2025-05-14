FROM eclipse-temurin:11-jre-alpine

WORKDIR /druid

ENV DRUID_VERSION=0.20.2
ENV DRUID_ARCHIVE=apache-druid-${DRUID_VERSION}-bin.tar.gz
ENV DRUID_DIR=/druid/apache-druid-${DRUID_VERSION}
ENV APACHE_MIRROR=https://archive.apache.org/dist/druid

# Descarga y extracción de Druid
RUN wget --output-document=$DRUID_ARCHIVE $APACHE_MIRROR/$DRUID_VERSION/$DRUID_ARCHIVE \
    && tar -xzf $DRUID_ARCHIVE \
    && rm $DRUID_ARCHIVE

# Instalación de dependencias
RUN apk update && \
    apk add --no-cache bash curl dos2unix

# Limpieza de archivos no necesarios
RUN rm -rf $DRUID_DIR/extensions $DRUID_DIR/hadoop-dependencies $DRUID_DIR/quickstart

# Crear usuario sin privilegios
RUN addgroup -S druid && adduser -S druid -G druid

# Crear carpeta de datos y ajustar permisos
RUN mkdir -p /data && chown -R druid /druid /data

# Cambiar a usuario no root
USER druid

# Copiar archivos necesarios
COPY --chown=druid:druid ./run.sh $DRUID_DIR/run.sh
COPY --chown=druid:druid ./log4j2.properties $DRUID_DIR/log4j2.properties
COPY --chown=druid:druid ./rows.json /data/rows.json
COPY --chown=druid:druid ./task.json /data/task.json
COPY --chown=druid:druid ./ingest.sh $DRUID_DIR/ingest.sh
COPY --chown=druid:druid ./start.sh /druid/start.sh

# Convertir EOL a formato Unix
RUN dos2unix $DRUID_DIR/*.sh /druid/start.sh

# Crear carpeta temporal
RUN mkdir -p $DRUID_DIR/var/tmp

# Configuración de entorno
ENV LOG4J_PROPERTIES_FILE=${DRUID_DIR}/log4j2.properties
ENV ENABLE_JAVASCRIPT=true
ENV START_MIDDLE_MANAGER=true

# Exponer puertos
EXPOSE 8081 8082 8083 8888 8091

# Usar script de inicio
ENTRYPOINT ["bash", "/druid/start.sh"]
