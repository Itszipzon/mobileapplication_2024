# Startup

## .env variables
```ini
SERVER_PORT =

DATABASE_URL = {REQUIRED}
DATABASE_USERNAME = {REQUIRED}
DATABASE_PASSWORD =
DATABASE_DRIVER = {REQUIRED}

KEY_NAME = {Required if USE_SSL is true}
CERT_PASS = {Required if USE_SSL is true}
USE_SSL = false

ADMIN_USER = {REQUIRED}
ADMIN_PASS = {REQUIRED}

JWT_SECRET = {Required}
```

### env example>

```ini
SERVER_PORT = 8080

DATABASE_URL = jdbc:mysql://localhost:3306/mobilapp
DATABASE_USERNAME = root
DATABASE_PASSWORD =
DATABASE_DRIVER = com.mysql.cj.jdbc.Driver

KEY_NAME = {Required if USE_SSL is true}
CERT_PASS = {Required if USE_SSL is true}
USE_SSL = false

ADMIN_USER = You create a username
ADMIN_PASS = You create a password

JWT_SECRET = {Required} 
```
### To generate a JWT_SECRET securely
```bash
openssl rand -base64 32
```


## properties example: 

```ini
spring.servlet.multipart.max-file-size=4MB
spring.servlet.multipart.max-request-size=4MB
server.error.include-message=always
server.port=${SERVER_PORT}

spring.datasource.url=${DATABASE_URL}
spring.datasource.username=${DATABASE_USERNAME}
spring.datasource.password=${DATABASE_PASSWORD}
spring.datasource.driver-class-name=${DATABASE_DRIVER}

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

spring.config.import=optional:file:.env[.properties]

server.ssl.certificate=${KEY_NAME}
server.ssl.certificate-private-key=${CERT_PASS}
server.ssl.enabled=${USE_SSL}

spring.security.user.name=${ADMIN_USER}
spring.security.user.password=${ADMIN_PASS}

spring.jpa.open-in-view=false

spring.output.ansi.enabled=always

jwt.secret=${JWT_SECRET}
```