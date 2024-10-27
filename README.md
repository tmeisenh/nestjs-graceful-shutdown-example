# nestjs graceful shutdown

The nestjs documentation is absolute trash for a variety of reasons one being basic things aren't setup by default and the examples are poor.

This is a complete example of how to setup a nestjs project to run in k8s, aws, or whereever Docker containers are run that can respond to kill signals and gracefully exit.

1. Build the image
   `docker build -t nestjs-shutdown-example --no-cache .`
1. Run the image
   `docker run --name nestjs-shutdown-example --publish 3000:3000 nestjs-shutdown-example`
1. kill the image
   `docker kill --signal=SIGTERM nestjs-shutdown-example`

Verify that nestjs-shutdown-example exited cleanly

Key take-aways

1. Delete the run:prod in package.json, you won't be using that npm script. If your container's CMD is the npm script npm will get the kill signals and it will exit causing bizarre logs and a non-zero exit code. You don't want that.
1. In your `Dockerfile` you want your CMD to be `CMD [ "node", "dist/main.js" ]`
1. The npm package `nestjs-graceful-shutdown` provides a nice mechanism to have one place for all your shutdown hook code. But again it relies on the previous two points to actually work.
