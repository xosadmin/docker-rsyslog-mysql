# Docker-rsyslog-mysql
  
A container of Rsyslog that save data to MySQL/MariaDB.  
  
## Usage
  
Before run this docker, a Mysql/MariaDB database is required. The ``db.sql`` in the repository could be used to structure the table.  
  
To run the docker image from Docker Hub, using following command:  
``
docker run -d --name rsyslog-mysql \
  --restart=always \
  -e MYSQL_HOST="mariadb_host" \
  -e MYSQL_DBNAME="syslog" \
  -e MYSQL_USER="rsyslog_user" \
  -e MYSQL_PASSWORD="password" \
  -p 514:514/udp -p 514:514/tcp xosadmin/rsyslog-mysql
``  
  
Note: MYSQL login credentials are required.  
  
