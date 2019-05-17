## SQL Grouping and Aggregate examples
```
SELECT t.id, t.transaction_type, t.amount, cc.card_type  FROM transactions t, tokenized_credit_cards cc WHERE t.tokenized_credit_card_id = cc.id;
```


```
SELECT t.transaction_type, cc.card_type, COUNT(*), SUM(t.amount)  FROM transactions t, tokenized_credit_cards cc WHERE t.tokenized_credit_card_id = cc.id GROUP BY t.transaction_type, cc.card_type;
```

## Reset the id sequencing
This command can solve the problem where id sequence gets a bit funked up and not being able to write a record because that id already exists - run this command from inside `psql`
`select setval('transaction_events_id_seq', COALESCE((SELECT MAX(id)+1 FROM transaction_events), 1), false);`

## PSQL commands / examples
`\d transaction_events`