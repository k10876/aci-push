FROM continuumio/anaconda3:latest

# Create a non-root user named 'coder' and set the home directory
RUN useradd -ms /bin/bash coder

# Install code-server
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://code-server.dev/install.sh | sh --prefix /usr/local

# Switch to 'coder' user
USER coder
WORKDIR /home/coder

# Set the working directory
WORKDIR /home/coder/

# Ensure bash is used to source conda
SHELL ["/bin/bash", "-c"]

# Initialize Conda and set IPython as the default python command
RUN echo "source /opt/conda/bin/activate" >> ~/.bashrc && \
    conda init bash && \
    conda install -y ipython && \
    ln -sf /opt/conda/bin/ipython /usr/local/bin/python

# Add watchdog script
ADD watchdog.sh /usr/local/bin/watchdog.sh
RUN chmod +x /usr/local/bin/watchdog.sh

# Start watchdog script and code-server
CMD ["sh", "-c", "/usr/local/bin/watchdog.sh & code-server --auth none --bind-addr 0.0.0.0:80"]

# Expose port 443
EXPOSE 80
