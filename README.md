# MakeWaves
[![Build Status](https://travis-ci.com/jhu-oose/2016-group-14.svg?token=bmLYk7qT55SdLzMGtbFG&branch=master)](https://travis-ci.com/jhu-oose/2016-group-14)

A hosted version of the app can be found [here](http://makewavesmusic.herokuapp.com/).


A guide for running the most recent prototype is as follows:

Either get the most recent git repo if it is already on your machine
```console
$ git pull
```

or get a copy of the repo
```console
$ git clone https://github.com/jhu-oose/2016-group-14.git
```

Navigate to the this directory
```console
$ cd makewaves/
```

Ensure that you have ruby 2.3.1 and rails 4.2.0 or greater installed

Download redis from [https://redis.io/download](https://redis.io/download) or install it from Homebrew.

Start redis server in a terminal tab
```console
$ redis-server
```

Download all required ruby gems
```console
$ bundle install --without production
```

Enter the following
```console
$ rake db:migrate RAILS_ENV=development
```

Launch the server
```console
$ rails server
```

Navigate to [http://localhost:3000](http://localhost:3000) on your browser to see the application

NOTE: If resetting the rails database with
```console
$ rake db:reset
```
you will also need to reset the redis database, as it will refer to nonexistent songs and cause an error.
This can be done by opening a new terminal and opening the redis command line:
```console
$ redis-cli
```

And then flushing the database with the following:
```console
> FlushAll
```
