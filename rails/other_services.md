# Other Services (used on rails)

## Elastic Search

Stores index data in JSON format on a separate server / port that can be accessed from the main rails project to provide fast search results.
https://iridakos.com/tutorials/2017/12/03/elasticsearch-and-rails-tutorial.html
You can customise which fields to search and do things like _apply :english_ to deal with plurals, conjugations etc.

Have used the gem `pg_search` in the past. This uses PostGres's own full text search. (PgSearch builds named scopes that take advantage of PostgreSQL's full text search.) So why would you use an alternative?


#### Pragmatic advantages to Postgres
- Reuse an existing service that you're already running instead of setting up and maintaining (or paying for) something else.
- Far superior to the fantastically slow SQL LIKE operator.
- Less hassle keeping data in sync since it's all in the same database — no application-level integration with some external data service API.

#### Advantages to Solr (or ElasticSearch)
- Scale your indexing and search load separately from your regular database load.
- - More flexible term analysis for things like accent normalizing, linguistic stemming, N-grams, markup removal… Other cool features like spellcheck, "rich content" (e.g., PDF and Word) extraction…
- - Solr/Lucene can do everything on the Postgres full-text search TODO list just fine.
- Much better and faster term relevancy ranking, efficiently customizable at search time.
- Probably faster search performance for common terms or complicated queries.
- Probably more efficient indexing performance than Postgres.
- Better tolerance for change in your data model by decoupling indexing from your primary data store

_Joel says_ 
_"elastic search requires a second server just to handle the search which is why i don't like people to use it in project week, because twice the deployment but it's probably more efficient or whatever"_