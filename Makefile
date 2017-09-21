EXCLUDES = \*~ \*.pyc .cache/\* test_\* __pycache__/\*

FUNC = salesforce_lambda

all: clean $(FUNC).zip

$(FUNC).zip:
	pip install --quiet -t deps -r requirements.txt
	(zip -q -r $(FUNC).zip salesforce_lambda --exclude $(EXCLUDES))
	(cd deps; zip -q -r ../$(FUNC).zip * --exclude $(EXCLUDES))

.PHONY: clean
clean:
	rm -f $(FUNC).zip
	rm -rf deps
	rm -rf *~
	rm -rf emulambda

.PHONY: test
test:
	nosetests --with-cov --cov salesforce_lambda

.PHONY: emulambda
emulambda:
	git clone https://github.com/fugue/emulambda.git
	pip install -e emulambda
	pip install --upgrade salesforce-analytics
	emulambda -v salesforce_lambda.lambda_handler ./salesforce_lambda/tests/mock/test-event.json

.PHONY: bandit
bandit:
	bandit -r salesforce_lambda/
