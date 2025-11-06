ARG DEBEZIUM_VERSION=3.3.1.Final
FROM quay.io/debezium/connect:$DEBEZIUM_VERSION
ENV KAFKA_CONNECT_JDBC_DIR=$KAFKA_CONNECT_PLUGINS_DIR/kafka-connect-jdbc

# These should point to the driver version to be used
ENV MAVEN_DEP_DESTINATION=$KAFKA_HOME/libs \
    ORACLE_JDBC_REPO="com/oracle/database/jdbc" \
    ORACLE_JDBC_GROUP="ojdbc10" \
    ORACLE_JDBC_VERSION="19.28.0.0" \
    ORACLE_JDBC_MD5=8e0c7024ed7a3b6d7bc23f49e2f6b694 \
    AWS_MSK_IAM_REPO="software/amazon/msk" \
    AWS_MSK_IAM_GROUP="aws-msk-iam-auth" \
    AWS_MSK_IAM_VERSION="2.3.4" \
    AWS_MSK_IAM_MD5=97dfc13319a8f9e6a3a83e9ee49beb1f

RUN docker-maven-download central "$ORACLE_JDBC_REPO" "$ORACLE_JDBC_GROUP" "$ORACLE_JDBC_VERSION" "$ORACLE_JDBC_MD5"
RUN docker-maven-download central "$AWS_MSK_IAM_REPO" "$AWS_MSK_IAM_GROUP" "$AWS_MSK_IAM_VERSION" "$AWS_MSK_IAM_MD5"

USER root
RUN microdnf install -y nmap-ncat && microdnf clean all

USER kafka

ENV BOOTSTRAP_SERVERS=kafka:9092
ENV GROUP_ID=corebanking-oracle-cdc-group
ENV CONFIG_STORAGE_TOPIC=corabaking_connect_configs
ENV OFFSET_STORAGE_TOPIC=corabaking_connect_offsets
ENV STATUS_STORAGE_TOPIC=corabaking_connect_statuses
ENV LD_LIBRARY_PATH=/instant_client
ENV KAFKA_DEBUG=true
ENV DEBUG_SUSPEND_FLAG=n
ENV JAVA_DEBUG_PORT=0.0.0.0:5005
