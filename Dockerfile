FROM ruby:3.4.5

# Install node for asset building
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Create and switch to a user called app
RUN useradd -ms /bin/bash app

WORKDIR /home/app

ENV RAILS_ENV="production" 
ENV SERVER_PORT="3000"
ENV DATABASE_URL=postgres://user:password@db:5432/development_db

# Copy across dependencies and install them
COPY Gemfile /home/app/
COPY Gemfile.lock /home/app
RUN bundle install
COPY . /home/app
RUN chown -R app:app /home/app
USER app
CMD ["bundle","exec","rackup"]