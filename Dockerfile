FROM python:3.8.5
COPY ./ ./
RUN pip install -r requirements.txt
CMD [ "python", "web_server/server.py" ]