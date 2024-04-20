# Use an official Python runtime as a parent image
FROM python:3.10

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make the bashbunny script executable
RUN chmod +x /app/bashbunny

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Run setup.sh to configure the environment
RUN bash /app/setup.sh

# Define environment variable
ENV PATH="/app:$PATH"

# Run bashbunny when the container launches
CMD ["setup.sh"]