# SQL Notes

## SQL Grouping and Aggregate examples
```sql
SELECT t.id, t.transaction_type, t.amount, s.type  
FROM transactions t, special_things s 
WHERE t.special_thing_id = s.id;
```


```sql
SELECT t.transaction_type, s.type, 
COUNT(*), 
SUM(t.amount)  
FROM transactions t, special_things s 
WHERE t.special_thing_id = s.id 
GROUP BY t.transaction_type, s.type;
```

## Reset the id sequencing
This command can solve the problem where id sequence gets a bit funked up and not being able to write a record because that id already exists - run this command from inside `psql`
```sql
SELECT setval('transaction_events_id_seq', 
COALESCE((
  SELECT MAX(id)+1 
  FROM transaction_events), 1), 
false);
```

## PSQL commands / examples
`\d transaction_events`
`\l`
`\t`
`\q`

[sqlbolt.com - tutorials](https://sqlbolt.com/)

## Installing Stopping / Starting Postgres
```
brew install postgresql@9.6
brew link postgresql@9.6 --force # used to add functionality to all terminal commands
brew pin postgresql@9.6 # this locks the version so doing a brew upgrade won't break your env
brew services run postgresql@9.6
```

### If your computer was abruptly restarted
First, you have to delete the file /usr/local/var/postgres/postmaster.pid Then you can restart the service using one of the many other mentioned methods depending on your install.
https://stackoverflow.com/questions/7975556/how-to-start-postgresql-server-on-mac-os-x
```
$ brew services stop postgresql@9.6
$ mv /usr/local/var/postgresql@9.6/postmaster.pid /usr/local/var/postgresql@9.6/postmaster.pid.old
$ brew services start postgresql@9.6
```