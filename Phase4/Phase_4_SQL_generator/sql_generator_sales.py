#!/usr/bin/env python
# Author; Junbo Ke
# Date: 05/24/2016

from ConfigParser import ConfigParser
import random
import string
import math
import numpy as np

class SQLGenerator(object):

    def __init__(self):
        config = ConfigParser()
        config.read('params_sales.cfg')
        self.customer_num = int(config.get('Generator', 'customer_num'))
        self.product_num = int(config.get('Generator', 'product_num'))
        self.category_num = int(config.get('Generator', 'category_num'))
        self.sales_num = int(config.get('Generator', 'sales_num'))
        self.max_price = float(config.get('Generator', 'max_price'))
        self.query_num = int(config.get('Generator', 'query_num'))
        self.template = "insert into sales_inserted (product_id, customer_id, quantity, price_paid) values ({}, {}, {}, {});"

    def gen_query(self):
        sales_list = map(lambda x: (str(x[1][0]), str(random.randint(0, self.customer_num-1)), str(x[1][1]), str(random.uniform(0.5, 1)*x[1][1]*np.random.randint(0, int(self.max_price)))), enumerate([(random.randint(0, self.product_num-1), random.randint(1, 1000)) for _ in xrange(self.query_num)]))
        with open('sales_query.sql', 'w') as fo:
            fo.write('\n'.join(map(lambda x: self.template.format(*x),sales_list)))
            fo.write('\n')
        return

if __name__ == '__main__':
    generator = SQLGenerator()
    generator.gen_query()
