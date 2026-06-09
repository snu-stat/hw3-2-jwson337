FROM ghcr.io/snu-stat/hw3-2-jwson337:dd0c61fc1e961f8f9d3cffb644ce4b6ab603910e

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER=${NB_USER}
ENV NB_UID=${NB_UID}
ENV HOME=/home/${NB_USER}

USER root
COPY . ${HOME}
RUN chown -R ${NB_UID}:users ${HOME}

USER ${NB_USER}
WORKDIR ${HOME}

ENTRYPOINT []
