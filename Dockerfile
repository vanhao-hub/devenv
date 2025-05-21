# Khai báo biến đầu vào
ARG BASE_IMAGE

# Dùng biến đã khai báo
FROM ${BASE_IMAGE}
# Tránh interactive prompt khi install
ENV DEBIAN_FRONTEND=noninteractive

# Build arguments for user identity
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USERNAME=yocto

ARG DEV_PACKAGES

# Cài toolchain nếu URL được cung cấp
ARG TOOLCHAIN_URL
ARG TOOLCHAIN_DIR
RUN apt-get update && apt-get install -y ${DEV_PACKAGES} && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/* 

ENV PATH="${TOOLCHAIN_DIR}/bin:$PATH"

# Tạo user 'yocto' không phải root
# Create non-root user
RUN groupadd -g ${GROUP_ID} ${USERNAME} && \
    useradd -m -u ${USER_ID} -g ${GROUP_ID} -s /bin/bash ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to user
USER ${USERNAME}
WORKDIR /home/${USERNAME}
