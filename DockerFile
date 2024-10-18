FROM ghcr.io/coder/coder:latest

# Install Anaconda
ENV PATH /opt/conda/bin:$PATH
RUN wget https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-x86_64.sh -O ~/anaconda.sh && \
    bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    /opt/conda/bin/conda clean -tipsy

# Set the working directory
WORKDIR /home/coder/project

# Ensure bash is used to source conda
SHELL ["/bin/bash", "-c"]

# Create and activate a new conda environment, install IPython
RUN conda create --name ipython-default python=3.8 && conda clean -a && \
    echo "source activate ipython-default" >> ~/.bashrc && \
    /opt/conda/bin/conda init bash && \
    conda activate myenv && \
    conda install -y ipython && \
    ln -sf /opt/conda/envs/myenv/bin/ipython /usr/local/bin/python

# Add watchdog script
ADD watchdog.sh /usr/local/bin/watchdog.sh
RUN chmod +x /usr/local/bin/watchdog.sh

# Start watchdog script in the background and code-server
CMD ["sh", "-c", "/usr/local/bin/watchdog.sh & code-server --auth none --bind-addr 0.0.0.0:443"]

# Expose port 443
EXPOSE 443
