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