## Reasons for Supabase Usage ![supabase](image.png)

**Open-Source Nature**
Supabase being open-source, you are not bound to any particular vendor (Zero lock-ins). You have the freedom to host it in your own cloud or even run it locally.

**SQL querying**
PostgreSQL allows you to interact with your data using SQL, a widely adopted query language known for its flexibility and expressive power. This enables developers to leverage their existing SQL knowledge and skills seamlessly.

**Pricing Model**
Supabase charges solely based on the amount of data stored.

**Self-hosting**
With supabase u can use
Supabase Cloud: Fully managed service
Docker: deploy to your own infrastructure.

**Performance Advantage**
Supabase is quite fast through its read and write operations u can check benchamarks [here](https://github.com/supabase/benchmarks) ⚡️

**Real-time**
Supabase provides a globally distributed cluster of Realtime servers that enable the following functionality:

- Broadcast: Send ephemeral messages from client to clients with low latency.
- Presence: Track and synchronize shared state between clients.
- Postgres Changes: Listen to Postgres database changes and send them to authorized clients.

**AI & Vectors**
You can develop AI applications using Postgres and pgvector. For [more](https://supabase.com/docs/guides/ai) .

**Authentification & Authorization**
Supabase provides easy authentification and authorization
You can authenticate your users in several ways:

- Email & password.
- Magic links (one-click logins).
- Social providers.
- Phone logins.

**User Management**
Supabase provides multiple endpoints to authenticate and manage your users:

- Sign up
- Sign in with password
- Sign in with passwordless / one-time password (OTP)
- Sign in with OAuth
- Sign out

## Supabase

**1.Supabase-Cli**
**Installation**

Kindly check [here](https://github.com/supabase/cli)
<br>
**Run the CLI**

```bash
supabase help
```

Or using npx:

```bash
npx supabase help
```

## Connecting the database

Make sure u have login if not use this

```bash
supabase login
```

<details>
<summary>Sample output</summary>

```sh
You can generate an access token from https://supabase.com/dashboard/account/tokens
Enter your access token: sbp_****************************************
Finished supabase login.
```

</details>

<br/>

then u link your online supabase with the local development project using:

```sh
supabase link --project-ref ********************
```
[how to link](https://supabase.com/docs/reference/cli/supabase-link)
<details>
<summary>Sample output</summary>

```sh
Enter your database password (or leave blank to skip): ********
Finished supabase link.
```

</details>
<br />
**Initializing**

```sh
supabase init
```

[details](https://supabase.com/docs/reference/cli/supabase-init)

<br/>

then start the database

```sh
supabase start
```

[details](https://supabase.com/docs/reference/cli/supabase-start)


Manage database migrations

```sh
supabase migration
```
CI/CD for releasing to production:
```sh
supabase db push
```
Generate types for
```sh
supabase gen types typescript --local
```
Stop all containers
```sh
supabase stop
```

***setup cli on github actions***
<br/>
This action sets up the Supabase CLI, supabase, on GitHub's hosted Actions runners.

This action can be run on ubuntu-latest, windows-latest, and macos-latest GitHub Actions runners, and will install and expose a specified version of the supabase CLI on the runner environment.

u can see the actions usage [here](https://github.com/marketplace/actions/supabase-cli-action)

***Generate types using GitHub Actions***
<br/>
End-to-end type safety across client, server, and database.

U can check here the usage [here](https://supabase.com/docs/guides/cli/github-action/generating-types)