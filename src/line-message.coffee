# Description
#   Send line message via hubot
#
# Configuration:
#   X_LINE_CHANNELID - Your line bot's channel id
#   X_LINE_CHANNELSECRET - Your line bot's channel secret
#   X_LINE_TRUSTED_USER_WITH_ACL - Your line bot's mid
#   LINE_USERS - Comma seperated dictionary for your line users, format: "<username1>: <line_mid1>, <username2>: <line_mid2>, ..."
#
# Commands:
#   hubot line send <user> <message> - Send line message to user
#   hubot line broadcast <message> - Send line message to all line users
#   hubot line list users - List all available line users
#
# Author:
#   Asoul <azx754@gmail.com>

module.exports = (robot) ->

  getLineUsers = (msg) ->
    users = process.env.LINE_USERS
    if !users
      msg.send "You must set the environment variable: LINE_USERS"
      return {}

    users.split(",").map((token) ->
      [name, user_id] = token.split(":")
    ).reduce((obj, pair) ->
      obj[pair[0].trim()] = pair[1].trim()
      obj
    , {})

  sendLineMessage = (msg, user, message) ->

    X_LINE_CHANNELID = process.env.X_LINE_CHANNELID
    X_LINE_CHANNELSECRET = process.env.X_LINE_CHANNELSECRET
    X_LINE_TRUSTED_USER_WITH_ACL = process.env.X_LINE_TRUSTED_USER_WITH_ACL
    users = process.env.LINE_USERS

    if !X_LINE_CHANNELID || !X_LINE_CHANNELSECRET || !X_LINE_TRUSTED_USER_WITH_ACL || !users
      return msg.send "You must set the following environment variables: X_LINE_CHANNELID, X_LINE_CHANNELSECRET, X_LINE_TRUSTED_USER_WITH_ACL, LINE_USERS"

    users = getLineUsers(msg)

    if user not of users
      return msg.send "user '#{user}' is not in available users"

    header =
      "Content-Type": "application/json; charser=UTF-8"
      "X-Line-ChannelID": X_LINE_CHANNELID
      "X-Line-ChannelSecret": X_LINE_CHANNELSECRET
      "X-Line-Trusted-User-With-ACL": X_LINE_TRUSTED_USER_WITH_ACL

    payload =
      "to": [users[user]]
      "toChannel": 1383378250
      "eventType": "138311608800106203"
      "content":
        "contentType": 1
        "toType": 1
        "text": message

    lineUrl = "https://trialbot-api.line.me/v1/events"

    robot.http("#{lineUrl}")
      .headers(header)
      .post(JSON.stringify(payload)) (err, res, body) ->
        if err
          return msg.send "Ran into some trouble: #{err}"

  robot.respond /line send (\w+)\s(.*)/, (msg) ->
    sendLineMessage msg, msg.match[1], msg.match[2]
    msg.send "Ok! send '#{msg.match[2]}' to '#{msg.match[1]}'"

  robot.respond /line broadcast (.*)/, (msg) ->
    users = getLineUsers(msg)
    for user of users
      sendLineMessage msg, user, msg.match[1]
    msg.send "Ok! broadcast '#{msg.match[1]}'"

  robot.respond /line list users/, (msg) ->
    users = getLineUsers(msg)
    text = "Total #{Object.keys(users).length} users:"
    for user of users
      text += "\n    #{user}"

    msg.send text
