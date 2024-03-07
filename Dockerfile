FROM  python:3.9.16
RUN  pip install django==3.2
COPY . .
RUN python manage.py migrate
cmd ["python","manage.py","runserver","0.0.0.0:8002"]

