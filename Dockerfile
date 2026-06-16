FROM alpine:3.19

# Install required tools
RUN apk add --no-cache \
    bash \
    curl \
    git \
    openjdk17-jdk

# Install Semgrep (SAST)
RUN pip3 install semgrep

# Install OWASP Dependency-Check
RUN wget -q https://github.com/jeremylong/DependencyCheck/releases/download/v8.0.0/dependency-check-8.0.0-release.zip && \
    unzip -q dependency-check-8.0.0-release.zip && \
    mv dependency-check /opt/dependency-check && \
    rm dependency-check-8.0.0-release.zip

# Install TruffleHog (Secrets)
RUN wget -q https://github.com/trufflesecurity/trufflehog/releases/download/v3.65.1/trufflehog_3.65.1_linux_amd64.tar.gz && \
    tar -xzf trufflehog_3.65.1_linux_amd64.tar.gz && \
    mv trufflehog /usr/local/bin/ && \
    rm trufflehog_3.65.1_linux_amd64.tar.gz

# Set working directory
WORKDIR /workspace

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
