# Startup

## .env variables
SERVER_PORT =

DATABASE_URL = {REQUIRED}</br>
DATABASE_USERNAME = {REQUIRED}</br>
DATABASE_PASSWORD = </br>
DATABASE_DRIVER = {REQUIRED}

KEY_NAME = </br>
CERT_PASS = </br>
USE_SSL = false </br>

ADMIN_USER = {REQUIRED}</br>
ADMIN_PASS = {REQUIRED}</br>


env example>


SERVER_PORT = 8080</br>

DATABASE_URL = jdbc:mysql://localhost:3306/mobilapp</br>
DATABASE_USERNAME = root</br>
DATABASE_PASSWORD =</br>
DATABASE_DRIVER = com.mysql.cj.jdbc.Driver</br>

KEY_NAME =</br>
CERT_PASS =</br>
USE_SSL = false</br>

ADMIN_USER = {Required}</br>
ADMIN_PASS = {Required}</br>

JWT_SECRET = {Required} 

### To generate a JWT_SECRET securely
```bash
openssl rand -base64 32
```


## properties example: 


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