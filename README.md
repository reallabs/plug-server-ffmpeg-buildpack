## Heroku Buildpack for ffmpeg
Because we only use a few ffmpeg features, we need to compile our own binary for use on Heroku. This buildpack downloads the binary from our GCS bucket and updates the PATH to include the binaries.

### Creating the Dockerfiles
The binaries are generated within a docker image whose build file is included in this repo. During the image's build process it compiles the ffmpeg binaries. Once the build is done, you need to run the container and copy out the binaries. Then these binaries need to be compressed with tar and uploaded to a public GCS bucket for retrieval by the Heroku buildpack.  

To run the build process:
```
docker build --progress=plain -t ubuntu/jetfuel-ffmpeg .
```

To copy out the compiled binaries:
```
id=$(docker create ubuntu/jetfuel-ffmpeg)
docker cp $id:/root/ffmpeg-bin.tar.gz ./
docker rm -v $id
```

Then use either the Google Cloud CLI or Webapp to upload the compressed files to the URL pointed to in the `bin/compile` script in this repo. Currently that url points to the public object stored at `theplug-server-public/ffmpeg-bin.tar.gz`.

