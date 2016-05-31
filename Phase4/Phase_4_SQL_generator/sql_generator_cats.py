#!/usr/bin/env python
# Author: Junbo Ke
# Date: May 24 2016


from ConfigParser import ConfigParser
import random
import string
import numpy as np
import datetime

class SQLGenerator(object):

    def __init__(self):
        config = ConfigParser()
        config.read('params_cats.cfg')
        self.user_num = int(config.get('Generator', 'user_num'))
        self.video_num = int(config.get('Generator', 'video_num'))
        self.like_num = int(config.get('Generator', 'like_num'))
        self.friend_num = min(int(config.get('Generator', 'friend_num')), self.user_num-1)
        self.query_num = int(config.get('Generator', 'query_num'))
        self.letters = string.ascii_lowercase
        self.template = "insert into like_activity select {0}, {1}, '{2}' where not exists (select 1 from like_activity where user_id={0} and video_id={1});"

    def gen_query(self):
        get_valid_id = np.vectorize(lambda x: min(self.video_num-1, x))
        video_ids = map(str, get_valid_id(np.random.zipf(2.0, self.query_num)-1))
        user_ids = map(str, np.random.randint(self.user_num, size=self.query_num))
        video_ids, user_ids = zip(*set(zip(video_ids, user_ids)))
        now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        maxseconds = 86400*365*10
        convert = np.vectorize(np.timedelta64)
        times = map(lambda x: '{0.year}-{0.month}-{0.day} {0.hour}:{0.minute}:{0.second}'.format(x), (np.datetime64(now)-convert(np.random.randint(maxseconds, size=len(user_ids)), 's')).astype(datetime.datetime))
        with open('cats_query.sql', 'w') as fo:
            fo.write('\n'.join(map(lambda x: self.template.format(*x), zip(user_ids, video_ids, times))))
            fo.write('\n')
        return

if __name__ == '__main__':
    generator = SQLGenerator()
    generator.gen_query()