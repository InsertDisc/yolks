FROM ghcr.io/parkervcp/yolks:wine_latest

# Switch to root for package installation
USER root

# Install Microsoft package repository for .NET (Debian 12)
RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb \
    -O /tmp/packages-microsoft-prod.deb \
    && dpkg -i /tmp/packages-microsoft-prod.deb \
    && rm /tmp/packages-microsoft-prod.deb

# Install .NET runtimes and utilities
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        unzip \
        dotnet-sdk-6.0 \
        aspnetcore-runtime-6.0 \
        dotnet-sdk-3.1 \
        aspnetcore-runtime-3.1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Return to container user for runtime
USER container

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

WORKDIR /home/container

# Entrypoint
COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
