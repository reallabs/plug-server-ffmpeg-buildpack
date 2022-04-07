## Heroku Buildpack for ffmpeg
Because we only use a few ffmpeg features, we need to compile our own binary for use on Heroku. This buildpack downloads the binary from our GCS bucket and updates the PATH to include the binaries.

### Creating the Dockerfiles
The binaries are generated within a docker image whose build file is included in this repo. During the image's build process it compiles the ffmpeg binaries. Once the build is done, you need to run the container and copy out the binaries. Then these binaries need to be compressed with tar and uploaded to a public GCS bucket for retrieval by the Heroku buildpack.  


