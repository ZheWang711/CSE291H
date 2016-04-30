set search_path to cats;

CREATE TABLE users(
user_id serial PRIMARY KEY,
username varchar(30),
facebook varchar(100)
);
CREATE TABLE video(
video_id serial PRIMARY KEY,
video_name varchar(50)
);
CREATE TABLE like_activity(
user_id integer REFERENCES users(user_id),
video_id integer REFERENCES video(video_id),
like_time timestamp,
PRIMARY KEY (user_id, video_id)
);
CREATE TABLE watch_activity(
watch_activity_id serial PRIMARY KEY,
user_id integer REFERENCES users(user_id),
video_id integer REFERENCES video(video_id),
watch_time timestamp
);
CREATE TABLE video_suggestion(
user_id integer REFERENCES users(user_id),
videos varchar(255),
login_time timestamp
);
CREATE TABLE friendship(
user1 integer REFERENCES users(user_id),
user2 integer REFERENCES users(user_id),
PRIMARY KEY(user1, user2)
);

set search_path to sales;

CREATE TABLE state(
state_id integer PRIMARY KEY,
state_name varchar(31) NOT NULL
);
CREATE TABLE category(
category_id integer PRIMARY KEY,
category_name varchar(255) NOT NULL,
description text
);
CREATE TABLE customer(
customer_id integer PRIMARY KEY,
customer_name varchar(255) NOT NULL,
state_id integer REFERENCES state(state_id)
);
CREATE TABLE product(
product_id integer PRIMARY KEY,
product_name varchar(255) NOT NULL,
price numeric,
category_id integer REFERENCES category(category_id)
);
CREATE TABLE sales(
sales_id integer PRIMARY KEY,
product_id integer REFERENCES product(product_id),
customer_id integer REFERENCES customer(customer_id),
quantity integer NOT NULL,
price_paid numeric NOT NULL
);

