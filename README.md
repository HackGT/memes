# Memes
## Introduction
Welcome to tech team! This is a quick introduction to [Beehive](https://github.com/hackgt/biodomes), our custom infrastructure automation system. By the end of this tutorial, you'll have your very own website hosted on our cluster to showcase your memes to the world!

 Let's get started!

## Step 1, Branching
Make a branch of this code named with your first name. 

On the command line, this can be done with the `git branch` command. For example, I would run `git branch ehsan`. Then, checkout your new branch with `git checkout <branchname>`.

## Step 2, Add the Content
Add any memes you want to host on the site to your branch. Then, create an `index.html` file and embed your memes/styling. This `index.html` will be loaded when users visit the root path of your site.

## Step 3, Docker!
[Docker](docker.com) is a container system for our applications. Each Docker container can be thought of as a lightweight virtual machine, which comes with the application and all it's dependencies built in.
### Building
 Docker containers must first be built. The build process is where we specify how to run our application and tell Docker what dependencies to include. At the root directory of each of our repositories is a `Dockerfile`, which uses Docker-specific scripting lanaguage to define how the Docker container is built. For this tutorial, we'll keep it simple.

Create a `Dockerfile` with the following contents and commit to your branch:
 ```
 FROM hackgt/nginx
 COPY . /usr/share/nginx/html/
 ```
The first line tells us to inherit a pre-built container called `nginx`. The rest of our Docker commands will run ontop of this pre-built container. The `nginx` container is a web server that simply serves anything located in `/usr/share/nginx/html/` on port `80`. So, the second line tells Docker to copy all of our files (meme images and `index.html`) from our _local machine_ into `/usr/share/nginx/html/` in the _virtual container_. 

## Step 4, deployment.yaml
At the root of each of our applications there's a `deployment.yaml`. This contains options related to deployment into our cluster. For now, we only need to specify that our application will be listening on port `80`, since that's what the `nginx` image we inherited from above uses.

Created a file called `deployment.yaml` with the follow contents and commit it to your branch:
```yaml
target_port: 80 
```

## Step 5, Deployment
That's all you need to build an application in our cluster! Let's discuss deployment.


[Beehive](https://github.com/hackgt/biodomes) is our repository for managing deployments of our applications. Each `yaml` file in the repository corresponds to an application hosted on a subdomain of `hack.gt`. For example, `registration.yaml` specifies the file to be hosted on `registration.hack.gt` and `dev/registration.yaml` specifies the application hosted on `registration.dev.hack.gt`. 

To deploy your application, created a `yaml` file with your name in the `memes/` folder. This will be deployed to `<yourname>.memes.hack.gt`. In the yaml file, we simply specify the git url and branch of our application.

Create the file `memes/<yourname>.yaml` with the following content:
```yaml
 git:
    remote: https://github.com/HackGT/memes.git
    branch: <branch_you_made_earlier>
```

Once you push this file to the `Beehive` repository, `Beehive` will immediately begin deploying your website. In a few minutes, you should see it live at `yourname.memes.hack.gt`!

