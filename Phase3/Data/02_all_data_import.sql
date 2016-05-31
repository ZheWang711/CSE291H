set search_path to cats;

copy users from '/Users/huiyuning/Desktop/CSE291H/Phase3/Data/cats/user.txt';
copy video from '/Users/huiyuning/Desktop/CSE291H/Phase3/Data/cats/video.txt';
copy friendship from '/Users/huiyuning/Desktop/CSE291H/Phase3/Data/cats/friendship.txt';
copy like_activity from '/Users/huiyuning/Desktop/CSE291H/Phase3/Data/cats/like.txt';


set search_path to sales;

copy state from '/Users/huiyuning/Desktop/CSE291H/Phase3/Data/sales/states.txt';
copy category from '/Users/huiyuning/Desktop/CSE291H/Phase3/Data/sales/category.txt';
copy customer from '/Users/huiyuning/Desktop/CSE291H/Phase3/Data/sales/customer.txt';
copy product from '/Users/huiyuning/Desktop/CSE291H/Phase3/Data/sales/product.txt';
copy sales from '/Users/huiyuning/Desktop/CSE291H/Phase3/Data/sales/sales.txt';
