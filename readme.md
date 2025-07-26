# Docker

## Introduction

[Cheat Sheet](https://find-saminravi99.notion.site/Docker-Cheat-Sheet-10dc48b8ac8c80b79f73ece2abfc6841)

### Image

A Docker **image** is a lightweight, standalone, and read-only package that contains everything needed to run a piece of software—code, runtime, libraries, and settings. You can think of it as a snapshot or blueprint.

### Container

A **container** is a runnable instance of an image. It is isolated, runs the application, and can be started, stopped, moved, or deleted. Containers use the image as a base and add a writable layer on top for execution.

### Dockerfile

A **Dockerfile** is a text file that contains a list of instructions for Docker to build an image.&#xA;It tells Docker **how to set up the environment** and **run the application**.

```
# Use the official Node.js version 20 image as the base
FROM node:20

# Set the working directory inside the container to /app
WORKDIR /app

# Copy only package.json to the container
COPY package.json .

# Install dependencies listed in package.json
RUN npm install

# Copy all remaining project files into the container
COPY . .

# Inform Docker that the app uses port 5000
EXPOSE 5000

# Set the default command to run the app in development mode
CMD ["npm", "run", "dev"]

```

Commands run during the build phase (when you run `docker build`): `FROM` `WORKDIR` `COPY` `RUN`
The `Expose` and `CMD` commands work on container. The other commands are run during the build process.

Commands that apply during the container run phase (when you run `docker run` or `docker-compose up`): `EXPOSE` `CMD`

### Build your first image and run an instance (container)

From your root folder

```
docker build -t my-node-app .
```

Get your image id

```
docker images
```

run the image in a container

```
docker run -p 5000:5000 <image-id>
```

or

```
docker run -p 5000:5000 my-node-app
```

or

Efficeient method:To automatically remove the container after it stops

```
docker run -p 5000:5000 --rm my-node-app
```

## Manage images and containers

### Create a Docker image with a tag

Use the `-t` flag with `docker build` to name and tag your image:

```
docker build -t my-node-app:v1 .
```

---

**Breakdown:**

- `my-node-app` → image name
- `v1` → tag (version label)
- `.` → build context (current directory)

You can also tag it for Docker Hub like:

```
docker build -t username/my-node-app:v1 .
```

### List all images

```
docker images
```

---

### Delete an image

```
docker rmi <image-id or image-name>
```

> Use `docker images` to get the image ID or name.

### Delete all imgaes at once

```
docker image prune -a
```

---

### Create and run a container

Use `docker run` to create and start a container from an image:

```
docker run -p 5000:5000 --name my-container my-node-app:v1
```

**Breakdown:**

- `-p 5000:5000` → Maps host port 5000 to container port 5000
- `--name my-container` → Assigns a name to the container
- `my-node-app:v1` → Image name with tag to run the container from
- `docker run -p 5000:5000 --rm --name my-container my-node-app:v1` → Automatically removes the container once it stops

This command both **creates** and **runs** the container.

### List all containers (running only)

```
docker ps
```

### List all containers (including stopped)

```
docker ps -a
```

### Run (start) an existing (stopped) container

```
docker start <container-id or name>
```

> Use `docker ps -a` to find the ID or name of stopped containers.

### Stop a running container

```
docker stop <container-id or name>
```

### Delete a container

```
docker rm <container-id or name>
```

### Force delete a running container

```
docker rm -f <container-id or name>
```

### Delete all containers at once

```
docker container purne
```

### Attach or Deatach container

- `docker run` runs the container in attached mode by default, to run in detached mode `docker run -d <image-name or image-id>`

- `docker start` runs the container in detached mode by default, to run in attached mode `docker start -a <container-id or name>`

## Docker Hub

Docker Hub is a **cloud-based Docker image registry** used to **store, share, and distribute** images.

📤 Push an image to Docker Hub

**Log in** (if not already):

```
docker login
```

**Push the image**:

```
docker push apuemdad04/my-node-app:v1
```

### Pull the image from Docker Hub

```
docker pull apuemdad04/my-node-app:v1
```

### Run the image from Docker Hub

```
docker run -p 5000:5000 apuemdad04/my-node-app:v1
```

> Docker will **automatically pull the image** if it’s not available locally.