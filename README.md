## Overview
This is a stateless Rails API server for Campfire and responsible for serving data to web clients/mobile (future).  Users authenticate through their Google API accounts usinga custom authentication system using JSON Web Tokens (JWT).  This server uses rack-cor middleware for handling cross-origin resource sharing.  It is currently deployed on Heroku at https://obscure-citadel-9804.herokuapp.com/

## Installation
- Run `bundle install` to install gems
- Run `rake db:migrate` to run all database migrations
- Add your secrets & other necessary data in `config/application.yml` 
- Run `rails server` to start the server

## Database
There are currently three models: User, CalendarList, Calendar
When a user first signs into Campfire, we fetch their calendar info from Google.  From early tests, I found that this fetch was incredibly slow.  This server caches the response from Google (currently only +- 6 months of events).  Though we can probably fetch this info from Google every time or say cache it on the client, this data is also useful to have on the server.  We also store a Google API sync token, meaning the calendar data can be updated periodically.

## Authentication
Surprisingly enough, I could not find a good existing solution for having OAuth authentication on stateless Rails API servers!  I spent a good amount of my time implementing the authentication strategy from scratch (with a help of a few guides listed in comments throughout the code).  For OAuth, I chose the hybrid server-side OAuth authentication code flow (https://developers.google.com/identity/sign-in/web/server-side-flow) for its security advantages over pure server-side/client-side flows.

After some research, I settled with using JSON Web Tokens on a non-secret user identifier to use as an API key.  This has several advantages.  The JWT is signed by a server-side secret, and requests cannot be forged without them meaning they should be secure (famous last words!).  The JWT itself does not contain any secrets (it is a signature, not a encryption), meaning compromise of it will not expose any private information.  We pass the JWT to the client when the user logs in, and use it to authenticate any API requests.

The server acts as a proxy to Google's Calendar API.  A user's access token is never exposed to the client. 

## Next Steps
- I hope to add real-time updates using some fancy middleware such as Faye (https://github.com/jamesotron/faye-rails).  Much of the existing code was completed with this in mind — now just need to hook up the right parts.

- I hope to also use the sync_token we store when fetching a user's data.  It currently does nothing, but I intended to use it both for fetching real-time updates and periodically updating user data.

- I usually follow TDD passionately (especially for Ruby code), but this time, I was severely limited by time and had volatile specifications.  So I'm hoping to write some tests before I implement anything else.
