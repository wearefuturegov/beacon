# 🔥 Beacon

🚨This is **BETA** software and may be buggy 🚨

This is a tool for local authorities and voluntary organisations to record and triage the needs of vulnerable people in their jurisdiction, and assign those needs to those who can meet them.

It deals in:

- 👩‍💻 **people in need**, who might be added by contact centre staff
- ✅ **tasks/needs**, which can be created under a person in need, given a need type and claimed by users
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
When running in development mode, [emails](https://guides.rubyonrails.org/action_mailer_basics.html) are sent to [maildev](https://www.npmjs.com/package/maildev), running via `docker-compose`.

Visit **localhost:1080** to view sent emails.

## Running it on the web

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](
https://heroku.com/deploy)

Suitable for 12-factor app hosting like [Heroku](http://heroku.com).

[Sendgrid](https://sendgrid.com/) delivers emails in production. You need to make sure the API key environment variable is set.

## Roadmap

Coming soon...

## Environment variables

| Name             | Description                         |
|------------------|-------------------------------------|
| SMTP_DOMAIN      | HELO domain                         |
| SMTP_ADDRESS     | Address for SMTP server             |
| SMTP_USERNAME    | Username for SMTP server            |
| SMTP_PASSWORD    | Password for SMTP server            |
| SMTP_PORT        | Port for SMTP server                |
| COUNCIL          | Config key for `councils.yml`       |
| SENDGRID_API_KEY | Sendgrid API key (production only   |
| MAILER_URL       | Default URL for action mailer       |
