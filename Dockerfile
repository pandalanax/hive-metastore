# Multi-stage build to download the JAR first
FROM curlimages/curl:latest AS downloader
WORKDIR /tmp
RUN curl -L -o aws-java-sdk-bundle-1.12.506.jar \
    https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.506/aws-java-sdk-bundle-1.12.506.jar

# Use the original Hive image
FROM apache/hive:standalone-metastore-4.1.0

# Copy the downloaded JAR from the downloader stage
COPY --from=downloader /tmp/aws-java-sdk-bundle-1.12.506.jar /opt/hadoop/share/hadoop/tools/lib/

# Set proper permissions and verify
RUN chmod 644 /opt/hadoop/share/hadoop/tools/lib/aws-java-sdk-bundle-1.12.506.jar && \
    ls -la /opt/hadoop/share/hadoop/tools/lib/aws-java-sdk-bundle-1.12.506.jar

# Add to Hadoop classpath
ENV HADOOP_CLASSPATH="/opt/hadoop/share/hadoop/tools/lib/*:$HADOOP_CLASSPATH"
