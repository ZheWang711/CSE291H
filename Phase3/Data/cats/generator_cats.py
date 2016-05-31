#!/usr/bin/env python
# Author; Junbo Ke
# Date: 04/21/2016

from ConfigParser import ConfigParser
import random
import string
import numpy as np
import datetime


class Generator(object):

    def __init__(self):
        config = ConfigParser()
        config.read('params_cats.cfg')
        self.user_num = int(config.get('Generator', 'user_num'))
        self.video_num = int(config.get('Generator', 'video_num'))
        self.like_num = int(config.get('Generator', 'like_num'))
        self.friend_num = min(int(config.get('Generator', 'friend_num')), self.user_num-1)
        self.letters = string.ascii_lowercase

    def fake_email(self):
        return ''.join(random.choice(self.letters) for _ in xrange(random.randint(6,10)))+'@'+''.join(random.choice(self.letters) for _ in xrange(random.randint(3,5)))+'.com'

    def gen_users(self):
        lowercase = string.ascii_lowercase
        uppercase = string.ascii_uppercase
        with open('user.txt', 'w') as fo:
            fo.write('\n'.join(['\t'.join([str(i), random.choice(uppercase)+''.join([random.choice(lowercase) for _ in xrange(random.randint(3,5))]), self.fake_email()]) for i in xrange(self.user_num)]))
        return

    def gen_videos(self):
        lowercase = string.ascii_lowercase
        uppercase = string.ascii_uppercase
        with open('video.txt', 'w') as fo:
            fo.write('\n'.join(['\t'.join([str(i), random.choice(uppercase)+''.join([random.choice(lowercase) for _ in xrange(random.randint(5,10))])]) for i in xrange(self.video_num)]))
        return

    def gen_likes(self):
        get_valid_id = np.vectorize(lambda x: min(self.video_num-1, x))
        video_ids = map(str, get_valid_id(np.random.zipf(2.0, self.like_num)-1))
        user_ids = map(str, np.random.randint(self.user_num, size=self.like_num))
        video_ids, user_ids = zip(*set(zip(video_ids, user_ids)))
        now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        maxseconds = 86400*365*10
        convert = np.vectorize(np.timedelta64)
        times = map(lambda x: '{0.year}-{0.month}-{0.day} {0.hour}:{0.minute}:{0.second}'.format(x), (np.datetime64(now)-convert(np.random.randint(maxseconds, size=self.like_num), 's')).astype(datetime.datetime))
        with open('like.txt', 'w') as fo:
            fo.write('\n'.join(map(lambda x: '\t'.join(x), zip(user_ids, video_ids, times))))
        return

    def gen_friendship(self):
        half_friendship = list(set(reduce(lambda a,b: a+b, [[(str(i), str(random.randint(i+1, self.user_num-1))) for _ in xrange(random.randint(0, self.friend_num))] for i in xrange(self.user_num-1)])))
        friendship = half_friendship+map(lambda a: (a[1],a[0]), half_friendship)
        with open('friendship.txt', 'w') as fo:
            fo.write('\n'.join(map(lambda x: '\t'.join(x), friendship)))
        return

if __name__ == '__main__':
    generator = Generator()
    generator.gen_users()
    generator.gen_videos()
    generator.gen_friendship()
    generator.gen_likes()