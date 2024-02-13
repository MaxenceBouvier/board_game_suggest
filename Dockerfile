# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.10-slim

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
RUN pip install --upgrade pip
COPY requirements.txt .
RUN python -m pip install -r requirements.txt

WORKDIR /app
COPY . /app

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

# Deal with pre-commit
# More information  https://stackoverflow.com/questions/68754821/how-to-pre-install-pre-commit-into-hooks-into-docker
COPY .pre-commit-config.yaml .
# RUN pre-commit install

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["python", "src/app/app.py"]

