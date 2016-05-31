set search_path to cats;

CREATE INDEX like_video_id
  ON cats.like_activity
  USING hash
  (video_id);

set search_path to sales;

CREATE INDEX sales_customer_id
  ON sales.sales
  USING hash
  (customer_id);

CREATE INDEX sales_product_customer_id
  ON sales.sales
  USING btree
  (product_id, customer_id);
