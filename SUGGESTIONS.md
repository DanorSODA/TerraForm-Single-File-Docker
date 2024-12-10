# Suggestions

### Project
- Docker-compose.yaml is not required - terraform was suppose to be the substitude

### README
Good work, yet has unnessesary and not useful information: KISS - Keep It Simple Stupid: 
- What's the name of the project
- What it does?
- How to start it ?
- Where are docs ?

### INSTALL SCRIPT
- There is not safe header on shell script
- Mixing `sh` with `bash`: choose one syntax and follow through
- If you request to use root, don't use sudo or vice versa
- When installing packages verify that you are using correct sources - docker.io is old version and is not suggested to use even by the ubuntu maintainers
- Docker-compose is not in use anymore - docker plugin compose is the substitude AKA docker compose


### TERRAFORM

- Lock file should NOT be in repository
- 
