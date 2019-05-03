#docker-compose
version: '2'

services:
  dynamo:
    image: "cnadiminti/dynamodb-local"
    ports:
      - "8000:8000"
  db:
    image: 'postgres:10.3'
    volumes:
      - 'db:/var/lib/postgresql/data'
    env_file:
      - '.env'

  backend:
    build: ./wizzbook_backend
    ports:
      - '3000:3000'
    volumes:
      - './wizzbook_backend:/app'
    env_file:
      - '.env'
    links:
      - "dynamo:dynamo"
    depends_on:
      - 'db'
      - 'dynamo'



  frontend:
    build: ./wizzbook_frontend
    command: 'ng serve --host 0.0.0.0 --port 4000'
    ports:
      - '4000:4000'
    volumes:
      - './wizzbook_frontend:/app'      

volumes:
  db:



# Dynamo db
1. https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GettingStarted.Ruby.01.html
--> Instead of local host as endpoint we can set dynamo as end point, hwich is the service name in docker( for setup)  <--
2. https://blog.faodailtechnology.com/step-by-step-guide-to-using-dynamodb-with-rails-application-i-a676cb9ba4df