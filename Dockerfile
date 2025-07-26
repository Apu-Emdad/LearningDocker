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