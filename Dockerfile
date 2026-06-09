# 1. 기반 이미지 설정
FROM rocker/tidyverse:4.4.0

# 2. 시스템 의존성 설치
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    git \
    imagemagick \
    libmagick++-dev \
    libzmq3-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. Miniconda 설치
ENV CONDA_DIR=/opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p ${CONDA_DIR} && \
    rm /tmp/miniconda.sh

# 4. Conda 경로 설정 및 환경 생성
ENV PATH=${CONDA_DIR}/bin:${PATH}

RUN conda create -n r-reticulate --override-channels -c conda-forge -y \
    python=3.10 \
    pyarrow \
    numpy \
    pandas \
    matplotlib \
    polars \
    plotnine \
    statsmodels \
    scipy \
    patsy \
    notebook \
    jupyterlab \
    jupyter_client \
    ipykernel \
    && conda clean -afy

# r-reticulate 환경을 기본 Python/Jupyter 환경으로 사용
ENV PATH=/opt/conda/envs/r-reticulate/bin:/opt/conda/bin:${PATH}
ENV RETICULATE_PYTHON=/opt/conda/envs/r-reticulate/bin/python
ENV MPLBACKEND=Agg

# 5. R 패키지 설치 및 R kernel 등록
RUN R -e "install.packages(c('reticulate', 'remotes', 'IRkernel', 'NHANES', 'MASS', 'broom', 'Lahman'), repos = 'https://cloud.r-project.org')" && \
    R -e "IRkernel::installspec(user = FALSE)"

# 6. Binder용 jovyan 유저 생성
ENV NB_USER=jovyan
ENV NB_UID=1000
ENV HOME=/home/${NB_USER}

RUN usermod -l ${NB_USER} rstudio && \
    usermod -d ${HOME} -m ${NB_USER} && \
    usermod -a -G users ${NB_USER} && \
    chown -R ${NB_USER}:users /opt/conda ${HOME}

USER ${NB_USER}
WORKDIR ${HOME}

# Binder/Jupyter가 사용할 수 있는 기본 포트
EXPOSE 8888
