# fast-artistic-videos-docker

The goal of this project is to provide a docker image to run [fast-artistic-videos](https://github.com/manuelruder/fast-artistic-videos). It will give users a consistent, functional environment to build from.

[![](./demo.gif)](https://www.youtube.com/watch?v=SKql5wkWz8E&t=3m26s)

The goal is speed, so it uses flownet2, cudnn, and stnbhwd. You will need a machine with an nvidia GPU attached, as well as nvidia-docker. 

You could host anywhere once the image is build, but for convenience-sake, there are commands provided to deploy to Kubernetes Engine on Google Cloud.


## Install dependencies

[Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

[Install gcloud](https://cloud.google.com/sdk/install)

[Install node 10](https://nodejs.org/en/)

Run `npm install` to install packages from npm


## Configuration

Make a copy of `.env-template` and rename it to `.env`. There are defaults there, but you can download and self-host these files for drastic speed improvements. It can take upwards of **4 hours** to build the flownet2 image using the default host.

Run `gcloud init` to log in and configure the gcloud CLI.


## Building the images

In flownet2-docker/ run `./build.sh` to build the positlabs/flownet2 image.

In the root, run `npm run build` to build the main image. It will be tagged based on the current gcloud project. You can edit [env.js](https://github.com/positlabs/fast-artistic-videos-docker/blob/master/dev/env.js#L14) to change the tag.


## Deploy to Kubernetes Engine

`npm run gcloud:cluster:create`: create a cluster

`npm run gcloud:pool:delete-default`: delete the default (non-gpu) pool

`npm run gcloud:pool:create`: create a new pool with gpu

`npm run gcloud:cluster:drivers`: install nvidia drivers

`npm run deploy`: build and deploy the image to your cluster

## Connect to the GKE container

Connect to the container via ssh. You can get a command by viewing the [compute engine instances](https://console.cloud.google.com/compute/instances) in the cloud console. 

The container will be running in the background when deployed via npm scripts. You can connect to it and run commands internally. (This is largely for development purposes. In production, there would be a REST API or something similar - which would run the docker command.)

Some useful paths:

- `/io`: The volume for reads/writes. The `npm start` command will mount the current working directory to this volume so the container can read your input video, and save the output in the same directory.

- `/flownet2`: flownet2 installation directory

- `/fast-artistic-videos`: Slightly modified fork of [fast-artistic-videos](https://github.com/manuelruder/fast-artistic-videos). Makes the prebuilt model host configurable, and outputs to the /io directory

- `/app`: Contents of this repo. There's a test video (mov_bbb.mp4), and a CLI tool (`/app/fav`) that will become the default command for running the container.


## Run the container directly

`npm run gcloud:cluster:auth` to connect kubectl to the cluster

`kubectl get po` to find the pod id

`kucbectl exec -it <pod_id> bash` to connect to the pod


### Example

Inside the container, you can fake the container mount behavior by moving the video into the /io directory

`cp /app/mov_bbb.mp4 /io/mov_bbb.mp4`

Then you can run the command and stylize the video

`/app/fav stylize mov_bbb.mp4 checkpoint-candy-video.t7`