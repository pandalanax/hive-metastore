# Custom Hive Metastore with AWS SDK
FROM apache/hive:standalone-metastore-4.1.0

# The base image runs as root and switches to hive user at runtime
# We need to stay as root to modify the filesystem
USER root

# Install curl if not available and download AWS SDK bundle jar
RUN apt-get update && apt-get install -y curl && \
    curl -L -o /opt/hadoop/share/hadoop/tools/lib/aws-java-sdk-bundle-1.12.506.jar \
    https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.506/aws-java-sdk-bundle-1.12.506.jar && \
    chmod 644 /opt/hadoop/share/hadoop/tools/lib/aws-java-sdk-bundle-1.12.506.jar && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify the JAR was downloaded correctly
RUN ls -la /opt/hadoop/share/hadoop/tools/lib/aws-java-sdk-bundle-1.12.506.jar

# Add S3A configuration to Hadoop classpath
ENV HADOOP_CLASSPATH="/opt/hadoop/share/hadoop/tools/lib/*:$HADOOP_CLASSPATH"

# The original entrypoint will handle user switching
# Don't change USER here as the base image manages that
