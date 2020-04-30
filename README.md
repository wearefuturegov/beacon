<p align="center">
    <a href="https://beacon-support-staging.herokuapp.com/">
        <img src="https://github.com/wearefuturegov/beacon/blob/master/app/assets/images/beacon.png?raw=true" width="350px" />               
    </a>
</p>
  
<p align="center">
    <em>Record and triage needs, get people the right support</em>         
</p>

---

![Ruby Test Env](https://github.com/wearefuturegov/beacon/workflows/Ruby%20Test%20Env/badge.svg)

🚨**This is BETA software.** Please submit issues for any bugs you find.🚨

This is a tool for local authorities and voluntary organisations to record and triage the needs of shielded people in their jurisdiction, and assign those needs to those who can meet them.

It deals in:

- 👩‍💻 **people in need**, who might be added by contact centre staff
- ✅ **needs**, which can be created under a person in need, given a need type and claimed by users
- 👩‍🔬 **users**, invited by email address whitelisting

It's a rails app backed by a postgresql database.

## Running it locally

```
git clone https://github.com/wearefuturegov/i-have-i-need
bundle install

# install javascript dependencies
yarn install

# launch postgres server via docker
docker-compose up -d

# run create databases, run migrations and seeds
rails db:setup

rails server
```

It'll be on **localhost:3000**.

You can log in using **admin@example.com**.
    
### How emails work
Emails use GovUk notify.  You can view the email text sent in the log in development, including magic sign in links

### Git Hooks
```
# to set git hooks
i-have-i-need$ git config core.hooksPath .githooks

# check for X permissions. Here is what you need:
i-have-i-need/.githooks$ chmod +x pre-commit
i-have-i-need/.githooks$ chmod +x pre-commit.d/01-rubocop
```

## Running it on the web

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](
https://heroku.com/deploy)

Suitable for 12-factor app hosting like [Heroku](http://heroku.com).

[Sendgrid](https://sendgrid.com/) delivers emails in production. You need to make sure the API key environment variable is set.

It has a `Procfile` that will automatically run pending rails migrations on every deploy, to reduce downtime.

## Roadmap

Coming soon...

## Environment variables

| Name             | Description                         |
|------------------|-------------------------------------|
| COUNCIL          | Config key for `councils.yml`       |
| NOTIFY_API_KEY   | Gov.uk Notify API key (production only)   |
| HOSTNAME         | Hostname used in outbound emails (e.g. `x.beacon.com`). Defaults to heroku app name |
| SEED_USER_EMAILS | Optional comma-separated list of emails to seed users table with |
| GA_PROPERTY_ID   | Optional Google Analytics property ID |
