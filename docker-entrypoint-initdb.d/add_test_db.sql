CREATE USER test_local_user with password 'password';
CREATE DATABASE "i_have_i_need_test";
GRANT ALL PRIVILEGES ON DATABASE "i_have_i_need_test" TO test_local_user;