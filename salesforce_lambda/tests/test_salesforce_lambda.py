""" Test template to test against the SalesForceAnalytics library
Nothing Fancy
"""

import unittest
import json
import os
from salesforce_lambda import lambda_handler

dir_path = os.path.dirname(os.path.realpath(__file__))

with open(dir_path+"/mock/test-event.json", 'r') as f:
    tickets = f.read()
tickets = json.loads(tickets)

class TestSalesForceAnalytics(unittest.TestCase):
    def setUp(self):
        results = lambda_handler(tickets, 'foo')
        self.payload = results

    def test_sample_tickets(self):
        self.assertEqual(3182, len(tickets['payload']))
        self.assertIsInstance(tickets['payload'], list)
        self.assertIsInstance(tickets['payload'][0], dict)

    def test_payload(self):
        self.assertEqual(self.payload.keys(), ['count', 'trend', 'mtc'])