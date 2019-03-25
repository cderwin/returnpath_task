FROM python:alpine

RUN pip install pipenv

WORKDIR /src
COPY . .

RUN pipenv install --deploy --skip-lock --system

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
