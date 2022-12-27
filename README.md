# mariadb

[mariadb]() - is a database

## Create the PMA User

```
CREATE USER 'pmadmin'@'localhost' IDENTIFIED BY '{GENERATE UNIQUE PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'pmadmin'@'localhost' WITH GRANT OPTION;
```

