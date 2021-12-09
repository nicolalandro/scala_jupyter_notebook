FROM ubuntu

# Install coq and python
RUN apt-get update && apt-get install -y coq coqide python3-dev python3
RUN apt-get update && apt-get install -y python3-pip

# Install java
RUN apt-get update && apt-get install -y openjdk-11-jdk

# Install scala
RUN apt-get update && apt-get install -y curl
RUN curl -fLo coursier https://git.io/coursier-cli && chmod +x coursier && ./coursier

# Install Jupyter
RUN pip3 install --no-cache notebook jupyterlab jupyter coq-jupyter rise jupyter_nbextensions_configurator jupyter_contrib_nbextensions sos sos-notebook sos-r

# Configure jupyter plugin for install extension
RUN jupyter contrib nbextension install --user
RUN jupyter nbextensions_configurator enable --user
RUN jupyter-nbextension install rise --py --sys-prefix

# Configure coq (proof assistant)
RUN python3 -m coq_jupyter.install

# Configure sos (for multi lenguage into a notebook)
RUN python3 -m sos_notebook.install

# Instruction for mybinder notebook
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}
