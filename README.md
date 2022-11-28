# Alpine + Ruby + Nodejs

This is a small, alpine-based docker image with the latest ruby, the latest LTS nodejs version, and yarn. Mostly built for our own purposes at [Union](https://union.vc), but probably useful for more folks running Rails applications with Webpack.

### Installed versions

| Image tag | Alpine | Ruby      | Node     | Yarn    |
| --------- | ------ | --------- | -------- | ------- |
| 3.17.0    | 3.17.0 | 3.1.2-r1  | v18.12.1 | 1.22.19 |
| 3.15.0    | 3.15.0 | 3.0.3p157 | v16.13.1 | 1.22.17 |
| 3.12.7    | 3.12.7 | 2.7.3p183 | v12.22.1 | 1.22.4  |
| 3.12.3    | 3.12.3 | 2.7.1p83  | v12.18.4 | 1.22.4  |
| 3.12.0    | 3.12.0 | 2.7.1p83  | v12.18.3 | 1.22.4  |
| 3.11.6    | 3.11.6 | 2.6.6p146 | v12.15.0 | 1.19.2  |

### Size comparison

```
fredoliveira/alpine-ruby-node       3.12.7         63.9MB
fredoliveira/alpine-ruby-node       3.12.3         63.1MB
fredoliveira/alpine-ruby-node       3.12.0         63.9MB
fredoliveira/alpine-ruby-node       3.11.6         61.2MB
fredoliveira/debian-ruby-node       latest         951MB
```

This Alpine image only takes under 10% of a similar image with the same dependencies using Debian. Ideally, that helps keep you final containers smaller.

### Snyk scan results

```
Testing fredoliveira/alpine-ruby-node:3.15.0...

Organization:      fredoliveira
Package manager:   apk
Project name:      docker-image|fredoliveira/alpine-ruby-node
Docker image:      fredoliveira/alpine-ruby-node:3.15.0
Platform:          linux/amd64
Base image:        alpine:3.15.0
Licenses:          enabled

✔ Tested 37 dependencies for known issues, no vulnerable paths found.
```

### Security considerations

Because of the nature of Docker and how it works, the security of your resulting containers hinges on the security of all the layers that are used to build it. As such, your security depends on the security of _this_ particular image, and the security of this image depends on Alpine, which it builds on top of. In building `alpine-ruby-node`, I have made sure to only add to Alpine, the bare minimum set of packages a regular Ruby developer would use, and no more.

While addressing the full spectrum of things that go into hardening Docker and containers in general is out of scope for this particular document, I would recommend following at least a core set of best practices while using this (or any) docker image:

- Whitelist and use only the images you need
- Run a vulnerability scan on your final images, perhaps as part of your build process
  - AWS's [ECR](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html) includes [free scanning of pushed images](https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning.html)
- Try to run the latest possible base image that works for you

### Example Dockerfile

Here is an example `Dockerfile` using this docker image, from our own Union codebase:

```
FROM fredoliveira/ruby-alpine-node:3.12.3

# Install extra dependencies for Union
RUN apk update \
    && apk add git \
        ruby-dev \
        build-base \
        ruby-nokogiri \
        libxml2-dev \
        libxslt-dev \
        postgresql-libs \
        postgresql-dev \
        imagemagick6 \
        imagemagick6-c++ \
        imagemagick6-dev \
        imagemagick6-libs

# Install bundler
RUN gem install bundler

# Create a directory for our application
# and set it as the working directory
WORKDIR /union

# Install the necessary gems
COPY Gemfile* ./
RUN bundle install

# Install yarn packages
COPY package.json yarn.lock ./
RUN yarn install --pure-lockfile

# Now that gems are installed, change to app folder and copy other files
COPY . .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

```

### Building instructions

To build these images locally:

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t fredoliveira/alpine-ruby-node:latest -t fredoliveira/alpine-ruby-node:3.17.0 --push .
```

### Credits and contributing

This work follows on the footsteps of `andrius/alpine-ruby` and `mhart/alpine` for inspiration. Credit goes to them some of the original code for the Dockerfile that generates this image.

Feel free to contribute to this work by opening a pull-request/issue if you find anything needs to change. Thank you in advance.
