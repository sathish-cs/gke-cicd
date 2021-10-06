# Base image for application
FROM python:3-alpine

# Copying requirements txt to install all dependencies
COPY requirements.txt server.py /usr/src/app/

# Change directory
WORKDIR /usr/src/app

# Install dependencies
RUN pip install -qr requirements.txt
EXPOSE 8000

# Create new user to run our application
RUN addgroup user && adduser -DH -G user user
USER user

# To start application
CMD ["python3", "./server.py"]
