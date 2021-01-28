FROM python:3.8.5
COPY web_server /web_server
WORKDIR /web_server
RUN pip install -r requirements.txt
CMD [ "python", "server.py" ]