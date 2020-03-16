FROM ubuntu:bionic
LABEL maintainer="Bahram Maravandi"

# Prevent dpkg errors
ENV TERM=xterm-256color

# ansible pip packages
ENV pip_packages "ansible pyopenssl"

# Set mirrors to DE
RUN sed -i "s/http:\/\/archive./http:\/\/de.archive./g" /etc/apt/sources.list

# Install Ansible
RUN apt-get update -qy && \
    apt-get install -qy software-properties-common python3-setuptools wget && \
    wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && rm get-pip.py

# Install Ansible using python3 interpreter
RUN pip install $pip_packages

# Copy baked in playbooks
COPY ansible /ansible

# Add volume for Ansible playbooks
VOLUME /ansible
WORKDIR /ansible

# Entrypoint
ENTRYPOINT ["ansible-playbook"]
CMD ["site.yml"]