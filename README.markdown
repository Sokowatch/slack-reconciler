# Slack Reconciler [![Build Status](https://travis-ci.org/Reliefwatch/slack-reconciler.svg?branch=master)](https://travis-ci.org/Reliefwatch/slack-reconciler) [![Code Climate](https://codeclimate.com/repos/56a7ad12d3a95a003b006119/badges/e2c052cda7f175255e34/gpa.svg)](https://codeclimate.com/repos/56a7ad12d3a95a003b006119/feed) [![Test Coverage](https://codeclimate.com/repos/56a7ad12d3a95a003b006119/badges/e2c052cda7f175255e34/coverage.svg)](https://codeclimate.com/repos/56a7ad12d3a95a003b006119/coverage)

Bridge webservices. Connect Webhooks. Format output. Send the result to slack :tada:

It's set up right now to passthrough github pull-request and issue notifications, find the label actions, and format the response to send it back.

---------

## Deploying

Deploy this to heroku with [![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

When you're deploying to heroku there will be a field to put in your slack url (as an environmental variable). Put your slack url in there.

After you've deployed, take the Heroku URL from the settings and add it to Github Webhooks to get mentions for labelling.

--------

## Testing

run `be guard` to get continuous testing

Slack Reconciler uses `ruby-2.2.2`