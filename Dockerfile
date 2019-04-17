# Use the barebones version of Ruby 2.2.3.
FROM ruby:2.5.3

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Wilson Varghese <varghesewilson16@gmail.com>

# Install dependencies:
#   - build-essential: To ensure certain gems can be compiled
#   - nodejs: Compile assets
#   - libpq-dev: Communicate with postgres through the postgres gem
#   - postgresql-client-9.4: In case you want to talk directly to postgres
RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client --fix-missing --no-install-recommends
# Set an environment variable to store where the app is installed to inside
# of the Docker image.
# ENV INSTALL_PATH /drkiq
RUN mkdir /app

# This sets the context of where commands will be ran in and is documented
# on Docker's website extensively.
WORKDIR /app

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
ADD Gemfile /app/Gemfile

ADD Gemfile.lock /app/Gemfile.lock
RUN gem install bundler -v 1.17.3 && bundle install

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY . /app
EXPOSE 3000
# Provide dummy data to Rails so it can pre-compile assets.
CMD ["rails", "server", "-b", "0.0.0.0"]