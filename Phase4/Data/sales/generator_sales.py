#!/usr/bin/env python
# Author: Junbo Ke
# Date: 04/20/2016

from ConfigParser import ConfigParser
import random
import string
import math
import numpy as np
import bisect

class Generator(object):

    def __init__(self):
        config = ConfigParser()
        config.read('params_sales.cfg')
        self.customer_num = int(config.get('Generator', 'customer_num'))
        self.product_num = int(config.get('Generator', 'product_num'))
        self.category_num = int(config.get('Generator', 'category_num'))
        self.sales_num = int(config.get('Generator', 'sales_num'))
        self.max_price = float(config.get('Generator', 'max_price'))
        with open('population.txt') as fo:
            population = np.array(map(float, fo.readlines()))

        population = population/np.sum(population)
        self.helper = np.cumsum(population)

    def gen_customers(self):
        lowercase = string.ascii_lowercase
        uppercase = string.ascii_uppercase
        with open('customer.txt', 'w') as fo:
            fo.write('\n'.join(['\t'.join([str(i), random.choice(uppercase)+''.join([random.choice(lowercase) for _ in xrange(3)]), str(bisect.bisect_right(self.helper, random.random()))]) for i in xrange(self.customer_num)]))
        return

    def gen_category(self):
        lowercase = string.ascii_lowercase
        uppercase = string.ascii_uppercase
        with open('category.txt', 'w') as fo:
            fo.write('\n'.join(['\t'.join([str(i), random.choice(uppercase)+''.join([random.choice(lowercase) for _ in xrange(random.randint(2,4))]), ''.join([random.choice(lowercase) for _ in xrange(random.randint(10,30))])]) for i in xrange(self.category_num)]))
        return

    def gen_product(self):
        lowercase = string.ascii_lowercase
        uppercase = string.ascii_uppercase
        product_list = [[str(i), random.choice(uppercase)+''.join([random.choice(lowercase) for _ in xrange(random.randint(3,9))]), str(min(max(random.gauss(self.max_price/50, math.sqrt(self.max_price)), 1.0), self.max_price)),str(random.randint(0, self.category_num-1))] for i in xrange(self.product_num)]
        self.price_list = [float(p[2]) for p in product_list]
        with open('product.txt', 'w') as fo:
            fo.write('\n'.join(map(lambda x: '\t'.join(x), product_list)))
        return

    def gen_sales(self):
        sales_list = map(lambda x: '\t'.join([str(x[0]), str(x[1][0]), str(random.randint(0, self.customer_num-1)), str(x[1][1]), str(random.uniform(0.5, 1)*x[1][1]*self.price_list[x[1][0]])]), enumerate([(random.randint(0, self.product_num-1), random.randint(1, 1000)) for _ in xrange(self.sales_num)]))
        with open('sales.txt', 'w') as fo:
            fo.write('\n'.join(sales_list))
        return


if __name__=='__main__':
    generator = Generator()
    generator.gen_category()
    generator.gen_customers()
    generator.gen_product()
    generator.gen_sales()
