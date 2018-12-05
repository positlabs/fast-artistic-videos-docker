# fast-artistic-videos-docker

The goal of this project is to provide a docker image to run [fast-artistic-videos](https://github.com/manuelruder/fast-artistic-videos). It will give users a consistent (working) environment to build from.

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

In the root, run `npm run build` to build the main image. It will be tagged based on the current gcloud project.






