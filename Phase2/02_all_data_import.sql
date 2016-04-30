set search_path to cats;

copy users from '/Users/huiyuning/Desktop/CSE291H/Phase2/Phase1_solution/cats/user.txt';
copy video from '/Users/huiyuning/Desktop/CSE291H/Phase2/Phase1_solution/cats/video.txt';
copy friendship from '/Users/huiyuning/Desktop/CSE291H/Phase2/Phase1_solution/cats/friendship.txt';
copy like_activity from '/Users/huiyuning/Desktop/CSE291H/Phase2/Phase1_solution/cats/like.txt';


set search_path to sales;

copy state from '/Users/huiyuning/Desktop/CSE291H/Phase2/Phase1_solution/sales/states.txt';
copy category from '/Users/huiyuning/Desktop/CSE291H/Phase2/Phase1_solution/sales/category.txt';
copy customer from '/Users/huiyuning/Desktop/CSE291H/Phase2/Phase1_solution/sales/customer.txt';
copy product from '/Users/huiyuning/Desktop/CSE291H/Phase2/Phase1_solution/sales/product.txt';
copy sales from '/Users/huiyuning/Desktop/CSE291H/Phase2/Phase1_solution/sales/sales.txt';
