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