.PHONY: setup-venv setup clean-pyc clean-test test mypy lint docs check

setup-venv:
		python -m venv .venv && . .venv/bin/activate
		pip install --upgrade pip
		pip install -r requirements.dev
		pip install -r requirements.prod

setup:
		DOCKER_BUILDKIT=1 docker build -t dev -f Dockerfile .

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f  {} +
	find . -name '__pycache__' -exec rm -rf {} +

clean-test:
		rm -f .coverage
		rm -f .coverage.*
		find . -name '.pytest_cache' -exec rm -rf {} +

clean: clean-pyc clean-test
		find . -name '.my_cache' -exec rm -rf {} +
		rm -rf logs/

test: clean
		. .venv/bin/activate && py.test tests --cov=src --cov-report=term-missing --cov-fail-under=95

mypy:
		. .venv/bin/activate && mypy src

lint:
		. .venv/bin/activate && pylint src -j 4 --reports=y

checks: test lint mypy