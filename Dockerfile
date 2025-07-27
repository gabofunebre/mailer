FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    msmtp msmtp-mta ca-certificates && \
    apt-get clean

WORKDIR /app

COPY msmtprc /etc/msmtprc
RUN chmod 600 /etc/msmtprc

COPY app.py .
RUN pip install Flask

EXPOSE 3322
CMD ["flask", "run", "--host=0.0.0.0", "--port=3322"]