## InstrumentalD Agent

If you are on Heroku Postgres, you *must* append `?sslmode=require` to the end of your PostgreSQL urls.

Additionally, the redis key must *not* have `redis://` prepended to it.
