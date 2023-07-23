# Docker image for tinycoin, Bjoern Winkler fork
# Python 3.11 version

FROM python:3.11-slim-bookworm

# Set the working directory to /app
WORKDIR /home/tinycoin

# Copy over requirements and install them
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt 

# Copy over the source files
COPY src/ .
RUN chmod +x start.sh
    
# Start the app
ENTRYPOINT [ "/home/tinycoin/start.sh" ]