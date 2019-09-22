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

### Create your Google Cloud Project

First, you need to create a Google Cloud Project and a Service Account with
the proper permissions for managing Cloud Pub/Sub resources.

The Broadway project on HexDocs has a great
[tutorial for Google Cloud Project setup](https://hexdocs.pm/broadway/google-cloud-pubsub.html#setup-cloud-pub-sub-project).

You can skip the steps about creating a topic and subscription, but be sure to
create your Service Account, bind it with the proper permissions, and create a
credentials file for authentication.

### Configure Application Credentials

With credentials in hand, we can configure our environment to authenticate with
Google. By default, this app will look for credentials in the
`GOOGLE_APPLICATION_CREDENTIALS` System environment variable. Be sure to set
the absolute path to your credentials file:

    export GOOGLE_APPLICATION_CREDENTIALS="/path/to/my/credentials.json"

### Create Resources

To use Google Cloud Pub/Sub, we need a **topic** and a **subscription**.
Messages are published to topics and received by subscriptions.

Create a topic:

    mix publisher.create test-topic
    Created topic projects/test-project/topics/test-topic

And a subscription for the topic:

    mix subscriber.create test-topic test-subscription
    Created subscription projects/test-project/subscriptions/test-subscription

> The Google Cloud Project is derived from the application credentials.

### Start listening for messages

Start a subscriber for the subscription we just created:

    mix subscriber.start test-subscription
    Listening for messages on projects/test-project/subscriptions/test-subscription - Press Ctrl+C to exit

### Publish messages

Open a new tab.  Don't forget to export your application credentials.

Publish some messages to the topic:


    mix publisher.publish test-topic
    Published message 1
    Published message 2
    Published message 3
    Published message 4
    Published message 5
    Published message 6
    Published message 7
    Published message 8
    Published message 9
    Published message 10

Switch back to the subscriber tab.  You should see output similar to:

    Received message from Cloud Pub/Sub:
      Message ID: 757042663206915
      Publish Time: 2019-09-22 19:16:25.183Z
      Attributes:
        nil

      The message data:
        "Message number 1"

    Received message from Cloud Pub/Sub:
      ...

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

    mix help <command>

## Documentation

You can build the documentation for this project by running the docs command:

    MIX_ENV=docs mix docs

The generated docs will be available at `doc/index.html`.

