# I have/I need platform

🚨This is **PRE-ALPHA** and not yet ready for use 🚨

This is a platform for local authorities and voluntary organisations to manage demand and supply of community services during the coronavirus pandemic.

It's a rails app backed by a postgresql database.

## Configuration

Coming soon...

## Running it locally

1. Clone the repository:

    ```bash
    git clone https://github.com/wearefuturegov/i-have-i-need
    ```
1. Install Rails dependencies:

    ```bash
    bundle install
    ```

1. Install JavaScript dependencies:

    ```bash
    yarn install
    ```

1. Start PostgresQL Docker image via `docker-compose`:

    ```bash
    docker-compose up -d
    ```

1. Setup the database:

    ```bash
    rails db:setup
    ```

1. Follow [auth0 setup instructions](#auth0-setup-instructions)

1. Copy `.env.sample` to `.env` and fill in the details

    ```bash
    cp .env.sample .env
    # modify .env in a text editor
    ```

1. Start the Rails server:

    ```bash
    rails server
    ```

## Running it on the web

Coming soon...

## Roadmap

Coming soon...

## Environment Variables

| Name          | Description              |
|---------------|--------------------------|
| SMTP_DOMAIN   | HELO domain              |
| SMTP_ADDRESS  | Address for SMTP server  |
| SMTP_USERNAME | Username for SMTP server |
| SMTP_PASSWORD | Password for SMTP server |
| SMTP_PORT     | Port for SMTP server     |
| AUTH0_CLIENT_ID | |
| AUTH0_CLIENT_SECRET | |
| AUTH0_DOMAIN | |

## MailDev
When running in development mode, emails are sent to maildev, running via docker-compose

Visit http://localhost:1080/ to view sent emails

## Auth0 setup instructions
1. Create an account at [Auth0](https://auth0.com)

2. Create an application within your dashboard
* Select "Regular web application"

3. Go to the Settings tab of your application
* Copy your Domain, Client ID, and Client Secret to your `.env` file as per above
* Enter a callback URL of `http://localhost:3000/auth/auth0/callback`
* Enter a logout URL of `http://localhost:3000`
* Press Save Changes

4. Go to the Connections tab of your application
* Enable Passwordless -> Email and disable the other options

5. On the left menu, select Connections -> Passwordless

6. Enable Email

7. Click on Email to open a dialogue box
* Scroll to the bottom of the dialogue box and activate the Disable Sign Ups option
* Press Save

8. On the left menu, select APIs

9. Select Auth0 Management API

10. Select the Machine to Machine Applications tab
* Find the application you just created and set its toggle to Authorised
* Enable the following scopes: `read:users`, `update:users`, `delete:users`, `create:users`, create:user_tickets`
* Press Update

