This Elixir app contains samples for working with Google Cloud Pub/Sub.

## Installation

First, clone this repository:

```sh
git clone https://github.com/mcrumm/cloud_pubsub_samples.git
cd cloud_pubsub_samples
```

Next, install and compile the app:

```sh
mix do deps.get, compile
```

Now you're ready to setup your Google Cloud Project!

## Getting Started

**TODO**

## Commands

The following commands are made available as Mix tasks:

    mix publisher.create           # Creates a Cloud Pub/Sub topic
    mix publisher.delete           # Deletes a Cloud Pub/Sub topic
    mix publisher.list             # Lists Cloud Pub/Sub topics for the current project
    mix publisher.publish          # Publishes messages to a Cloud Pub/Sub topic
    mix subscriber.create          # Creates a subscription for a Cloud Pub/Sub topic
    mix subscriber.delete          # Deletes a subscription for a Cloud Pub/Sub topic
    mix subscriber.list_in_project # Lists Cloud Pub/Sub subscriptions for the current project
    mix subscriber.list_in_topic   # Lists Cloud Pub/Sub subscriptions for a topic
    mix subscriber.start           # Listens for messages on a Cloud Pub/Sub subscription

To learn more about a given command and its arguments, run:

```sh
mix help <command>
```

## Documentation

You can build the documentation for this project by running the docs command:

```sh
MIX_ENV=docs mix docs
```

The generated docs will be available at `doc/index.html`.

