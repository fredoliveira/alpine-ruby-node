# Alpine + Ruby + Nodejs

This is a small, alpine-based docker image with the latest ruby, the latest LTS nodejs version, and yarn. Mostly built for our own purposes at [Union](https://union.vc), but probably useful for more folks running Rails applications with Webpack.

### Installed versions

```bash
❯ docker run -ti --rm fredoliveira/alpine-ruby-node:latest cat /etc/issue
Welcome to Alpine Linux 3.11

~/code/docker/alpine-ruby-node master*
❯ docker run -ti --rm fredoliveira/alpine-ruby-node:latest ruby -v
ruby 2.6.6p146 (2020-03-31 revision 67876) [x86_64-linux-musl]

~/code/docker/alpine-ruby-node master*
❯ docker run -ti --rm fredoliveira/alpine-ruby-node:latest node -v
v12.15.0

~/code/docker/alpine-ruby-node master*
❯ docker run -ti --rm fredoliveira/alpine-ruby-node:latest yarn -v
1.19.2
```

### Size comparison

```
fredoliveira/alpine-ruby-node       latest              d24abaa50c94        43 minutes ago      61.2MB
fredoliveira/debian-ruby-node       latest              4bfee5c32d36        About an hour ago   951MB
```

This Alpine image only takes under 10% of a similar image with the same dependencies using Debian. Ideally, that keeps you final containers smaller.

### Example Dockerfile

Here is an example `Dockerfile` using this docker image, from our own Union codebase:

```
FROM fredoliveira/ruby-alpine-node:latest

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

### Credits and contributing

This work follows on the footsteps of `andrius/alpine-ruby` and `mhart/alpine` for inspiration. Credit goes to them some of the original code for the Dockerfile that generates this image.

Feel free to contribute to this work by opening a pull-request/issue if you find anything needs to change. Thank you in advance.