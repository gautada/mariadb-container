# mariadb

[MariaDB](https://mariadb.org) is the successor to MySQL that turns data into structured information in a wide array of applications, ranging from banking to websites. Originally designed as enhanced, drop-in replacement for MySQL, MariaDB is used because it is fast, scalable and robust, with a rich ecosystem of storage engines, plugins and many other tools make it very versatile for a wide variety of use cases.

MariaDB is developed as open source software and as a relational database it provides an SQL interface for accessing data. The latest versions of MariaDB also include GIS and JSON features.

This container uses [phpMyAdmin](https://www.phpmyadmin.net) for management; which is a free software tool written in PHP, intended to handle the administration of MySQL over the Web. phpMyAdmin supports a wide range of operations on MySQL and MariaDB. Frequently used operations (managing databases, tables, columns, relations, indexes, users, permissions, etc) can be performed via the user interface, while you still have the ability to directly execute any SQL statement.    

## Create the PMA User


# {Title - Name of the container}

{Abstract

[Upstream Name](URL to upstream project) ... Lift the purpose of the project from the upstream website.

Add a second paragraph about the container and what the job it is hired to do.
}

## Features

- {List specific features that are considered important}

### Feature Detail

{ Provide specific details regarding the feature }

## Development

## Testing

## Deploy

## Architecture

### Context

{![Context Diagram(Link to image)}

### Container

{![Container Diagram(Link to image)}

### Components

{![Component Diagram(Link to image)}

## Administration

### Issues

The official to list is kept in a [GitHub Issue List](https://github.com/gautada/mariadb-container/issues)

- [2022-12-28: Release Checklist](https://github.com/gautada/mariadb-container/issues/4)

## Notes

- Create a the super user in PMA for administration

```
CREATE USER 'pmadmin'@'localhost' IDENTIFIED BY '{GENERATE UNIQUE PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'pmadmin'@'localhost' WITH GRANT OPTION;
```

- Generate the PMA secret for cookies `echo $RANDOM | shasum5.34 | head -c 32 ; echo ;`




