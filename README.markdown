# Slack Reconciler [![Build Status](https://travis-ci.org/Reliefwatch/slack-reconciler.svg?branch=master)](https://travis-ci.org/Reliefwatch/slack-reconciler) [![Code Climate](https://codeclimate.com/repos/56a7ad12d3a95a003b006119/badges/e2c052cda7f175255e34/gpa.svg)](https://codeclimate.com/repos/56a7ad12d3a95a003b006119/feed) [![Test Coverage](https://codeclimate.com/repos/56a7ad12d3a95a003b006119/badges/e2c052cda7f175255e34/coverage.svg)](https://codeclimate.com/repos/56a7ad12d3a95a003b006119/coverage)

Bridge webservices. Connect Webhooks. Format output. Send the result to slack :tada:

It's set up right now to bridge github pull-request and issue notifications and send a notification when a label is added (a feature that slack doesn't support).

This uses the [slack-notifier gem](https://github.com/stevenosloan/slack-notifier) and [sinatra](http://www.sinatrarb.com/)

### github supported actions

  - labeling and unlabeling pull requests and issues
  - Wiki updates


---------

## Deploying

Deploy this to heroku (for free) with [![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

When you're deploying to heroku there will be a field to put in your slack url (as an environmental variable). Put your slack url in there.

After you've deployed, you can find the find the url of the deployment (henceforth `reconciler_url`) in the Heroku settings panel.

To add github actions:

1. Go to the settings page for the github repository you want notifications from
2. Go the webhooks section
3. Add a new webhook
4. Set the url to `{{reconciler_url}}/github`

You can check the "include all push events", or, if you want to be more selective, pick and choose.

If you're being choosey and want to be notified of label updates on pull requests, make sure you select the label check. Ditto for issues and wiki updates.

--------

## Contributing

It would be great to add more services!

Submit a pull request.

## Testing

run `bundle exec guard` to get continuous testing.

Slack Reconciler uses `ruby-2.2.2`
