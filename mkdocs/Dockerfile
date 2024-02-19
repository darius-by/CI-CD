FROM python:3.9-slim

WORKDIR /docs

COPY requirements.txt /docs/

RUN pip install --no-cache-dir -r requirements.txt

# documentation files
COPY . /docs

EXPOSE 8000

# run mkdocs serve
CMD ["mkdocs", "serve", "-a", "0.0.0.0:8000"]

