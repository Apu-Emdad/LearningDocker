# Docker

## Introduction

[Cheat Sheet](https://find-saminravi99.notion.site/Docker-Cheat-Sheet-10dc48b8ac8c80b79f73ece2abfc6841)

[Bind Mount, Dev Container & Ts Node Dev Cheat Sheet:](https://find-saminravi99.notion.site/Bind-Mount-Dev-Container-Ts-Node-Dev-Cheat-Sheet-117c48b8ac8c804aabb5ed0f09bc69a9?pvs=41)

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

**Generic command:**

```
docker run -p <host-port>:<container-port> --rm -it --name <container-name> <image-name>:<tag>
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
docker container prune
```

### Attach or Detach container

**Attach Mode:**
In attach mode, the container runs in the foreground, and your terminal is connected directly to the container’s input/output. You see live logs and can interact with it. Pressing `Ctrl+C` usually stops the container.

**Detach Mode:**
In detach mode, the container runs in the background. Your terminal is not connected to it, so you don’t see its output. The container keeps running until you manually stop it. Use `docker logs` or `docker attach` to view or interact later.

- `docker run` runs the container in attached mode by default, to run in detached mode `docker run -d <image-name or image-id>`

- `docker start` runs the container in detached mode by default, to run in attached mode `docker start -a <container-id or name>`

## Docker Hub

Docker Hub is a **cloud-based Docker image registry** used to **store, share, and distribute** images.

### Push an image to Docker Hub

**Log in** (if not already):

```
docker login
```

**Push the image**:

```
docker push <username>/<repository>:<tag>
```

### Pull the image from Docker Hub

```
docker pull <username>/<repository>:<tag>
```

### Run the image from Docker Hub

```
docker run -p <host_port>:<container_port> <username>/<repository>:<tag>
```

> Docker will **automatically pull the image** if it’s not available locally.

## Volume

A Docker volume is **a storage location** used to **save data outside a container’s filesystem**, so the data **persists even if the container is deleted or recreated**.
To create a **named volume**:

```
docker volume create my_volume
```

To use it in a container:

```
docker run -v my_volume:/app/data my_image
```

If `my_volume` doesn’t already exist, Docker will **automatically create it** when you run that command.

To remove a volume:

```
docker volume rm my_volume
```

To remove all unused volumes:

```
docker volume prune
```

## Bind Volume

A **bind volume** (or **bind mount**) directly connects a **host machine folder** to a **container folder**.

Example:

```
docker run -v /host/path:/container/path my_image
```

Changes made in either location instantly appear in the other. It’s useful for **development** or **sharing files** between host and container.

**Syntax**

```
docker run -p 5000:5000 --name ts-container -w //app -v ts-docker-logs://app/logs -v "//$(pwd)"://app/ -v //app/node_modules --rm ts-docker
```

Here’s the breakdown of your command:

```
docker run \
  -p 5000:5000 \                     # Maps host port 5000 to container port 5000
  --name ts-container \              # Names the container "ts-container"
  -w //app \                         # Sets the working directory inside container to /app
  -v ts-docker-logs://app/logs \     # Mounts a named volume "ts-docker-logs" to /app/logs
  -v "//$(pwd)"://app/ \             # Mounts the current host directory to /app inside container
  -v //app/node_modules \            # Creates an anonymous volume for /app/node_modules (so host files don’t overwrite it)
  --rm \                             # Automatically removes container when it stops
  ts-docker                          # Image name to run
```

**Brief Esxplanation:**
Let me explain those parts more clearly:

1. **`-w //app`**

   - `-w` sets the **working directory** inside the container.
   - Here, it’s set to `/app` (note: `//app` is just Docker’s way of interpreting `/app` on Windows).
   - This means any command you run inside the container will start from `/app`.

2. **`-v ts-docker-logs://app/logs`**

   - This is a **named volume**.
   - Docker stores logs from `/app/logs` in a persistent volume called `ts-docker-logs`.
   - Even if you delete the container, the logs stay in this volume.

3. **`-v "//$(pwd)"://app/`**

   - This is a **bind mount**.
   - `$(pwd)` gets your **current host directory**.
   - It is mounted to `/app` in the container, so **all your project files on the host are available inside the container**.
   - Changes on the host immediately appear in the container and vice versa.

4. **`-v //app/node_modules`**

   - This creates an **anonymous volume** for `/app/node_modules`.
   - Purpose: avoid overwriting `node_modules` installed inside the container with the host’s folder (which may be empty).
   - Keeps container dependencies isolated.

**note/ Rule of thumb**:
step 2 and 4 will be excuted before step 3.

> **Deeper (more specific) path wins, regardless of CLI order.**

## Run container with env

```bash
docker run --name my-container --env-file ./myenv.env -d image_name:tag
```
