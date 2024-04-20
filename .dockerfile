FROM python:3.10
COPY . /usr/bin
RUN pip install -r /usr/bin/requirements.txt