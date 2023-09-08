FROM nvcr.io/nvidia/rapidsai/rapidsai-core:22.08-cuda11.0-runtime-ubuntu20.04-py3.9

#Install CUDA toolkit 11.0
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
    mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    wget https://developer.download.nvidia.com/compute/cuda/11.2.0/local_installers/cuda-repo-ubuntu2004-11-2-local_11.2.0-460.27.04-1_amd64.deb && \
    dpkg -i cuda-repo-ubuntu2004-11-2-local_11.2.0-460.27.04-1_amd64.deb && \
    apt-key add /var/cuda-repo-ubuntu2004-11-2-local/7fa2af80.pub && \
    apt-get update && \
    apt-get -y install cuda

RUN apt install -y wget git python3 vim gcc g++ make

RUN pip uninstall -y cupy && pip install cupy-cuda112

#Build and install CUDA-aware OpenMPI
RUN wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.gz && \
    tar -xzf openmpi-4.1.4.tar.gz && \
    cd openmpi-4.1.4 && \
    ./configure --with-cuda=/usr/local/cuda/ --prefix=/opt/openmpi-4.1.4 && \
    make all install
ENV PATH=/opt/openmpi-4.1.4/bin/:$PATH
ENV LD_LIBRARY_PATH=/opt/openmpi-4.1.4/lib:$LD_LIBRARY_PATH

RUN pip install genepattern-python mpi4py h5py fastcluster fastdist
