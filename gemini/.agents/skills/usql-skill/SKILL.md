# USQL Skill

Universal command-line interface for SQL databases.

## Description
Manage and query multiple SQL databases (PostgreSQL, MySQL, SQLite, Oracle, etc.) using `usql`.

## Commands

### Execute SQL
Run SQL command or internal usql command.
`usql [flags] [DSN] -c "QUERY"`

### Execute File
Run commands from SQL file.
`usql [flags] [DSN] -f PATH/TO/FILE`

### Common Flags
- `-J`, `--json`: Output as JSON.
- `-C`, `--csv`: Output as CSV.
- `-q`, `--quiet`: No noise, only output.
- `-o`, `--out`: Save result to file.

## DSN Examples
- **SQLite**: `sqlite:/path/to/db.sqlite`
- **Postgres**: `postgres://user:pass@localhost/db`
- **MySQL**: `mysql://user:pass@tcp(localhost:3306)/db`

## Workflow
1. Use `usql` to verify connection.
2. Run queries with `-c` for results.
3. Use output flags (`-J`, `-C`) for data processing.
