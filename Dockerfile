# FROM alpine
FROM python:3.10
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
EXPOSE 5000
CMD ["python", "app.py"]
# CMD ["echo", "Hello from my DevOps CI/CD project folder."]
