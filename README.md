# hubot-line-message

Send line message via hubot

```
You >> hubot line Boss Our office is on fire!!!
hubot >> Ok! send 'Our office is on fire!!!' to 'Boss'

```

```
You >> hubot list line users
hubot >> Total 5 line users:
           Boss
           Monkey
           Dog
           Pig
           Chicken
```

```
You >> hubot line broadcast Alert, boss is angry
hubot >> Ok! broadcast 'Alert, boss is angry'
```

See [`src/line-message.coffee`](src/line-message.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-line-message --save`

Then add **hubot-line-message** to your `external-scripts.json`:

```json
[
  "hubot-line-message"
]
```

## Configuration

- X_LINE_CHANNELID - Your line bot's channel id
- X_LINE_CHANNELSECRET - Your line bot's channel secret
- X_LINE_TRUSTED_USER_WITH_ACL - Your line bot's mid
- LINE_USERS - Comma seperated dictionary for your line users, format: "<username1>: <line_mid1>, <username2>: <line_mid2>, ..."

### Step by step to get Line mid

1. In [LINE Developers](https://developers.line.me/restful-api/api-reference) page, clicking `Issue` button on the right side of `Issuing access tokens for testing`

2. Copy `curl -v -H "Authorization ...`, paste in terminal

3. Get your `mid` field in respond payload

## Commands:
- `hubot line send <user> <message> - Send line message to user`
- `hubot line broadcast <message> - Send line message to all line users`
- `hubot line list users - List all available line users`
