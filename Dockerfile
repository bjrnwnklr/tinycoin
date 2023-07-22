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
    

# Set environment variables
# MINER_ADDRESS is set from the command line or docker-compose
ENV HOST="0.0.0.0"
ENV PORT=5000
ENV PEERS="localhost:${PORT}"


# Start the app
CMD ["python3", "app.py"]

EXPOSE ${PORT}
