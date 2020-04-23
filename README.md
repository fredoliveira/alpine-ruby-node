# Alpine + Ruby + Nodejs

This is a small, alpine-based docker image with the latest ruby, the latest LTS nodejs version, and yarn. Mostly built for our own purposes at [Union](https://union.vc), but probably useful for more folks running Rails applications with Webpack.

### Example Dockerfile 

Here is an example `Dockerfile` using this docker image, from our own Union codebase:

```
FROM fredoliveira/unionbase:latest

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
