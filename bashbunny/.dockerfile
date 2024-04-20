FROM python:3.10
COPY . /usr/bin
RUN pip install -r /usr/bin/bashbunny/requirements.txt
RUN bash /usr/bin/bashbunny/setup.sh