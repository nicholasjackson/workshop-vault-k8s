FROM ghcr.io/jumppad-labs/vscode:vscode-v0.6.1

# Install Vault CLI
RUN curl -fsSL https://releases.hashicorp.com/vault/1.18.3/vault_1.18.3_linux_amd64.zip -o /tmp/vault.zip && \
    unzip /tmp/vault.zip -d /usr/local/bin && \
    rm /tmp/vault.zip && \
    chmod +x /usr/local/bin/vault

# Install kubectl
RUN curl -fsSLo /usr/local/bin/kubectl "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x /usr/local/bin/kubectl