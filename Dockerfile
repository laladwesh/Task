FROM arcadedata/arcadedb:latest

# Set environment variables
ENV ARCADEDB_SERVER_NAME=arcadedb-server
ENV ARCADEDB_SERVER_ROOT_PASSWORD=arcadedb
ENV ARCADEDB_SERVER_HTTP_PORT=2480
ENV ARCADEDB_SERVER_BINARY_PORT=2424

# Expose ports
# 2480: HTTP/REST API and Studio
# 2424: Binary protocol
EXPOSE 2480 2424

# Create volume for data persistence
VOLUME /home/arcadedb/data

# Default command (runs ArcadeDB server)
CMD ["java", "-Xmx2G", "-Xms512M", "-jar", "/home/arcadedb/arcadedb-server.jar"]
