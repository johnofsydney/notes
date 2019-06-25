# Git and Bash Notes

## Git Diff
to manually git diff, eg -
`git diff -C -M <LATEST COMMIT ID> <EARLIER COMMIT ID> -- "package-lock.json"`

## Git config
`git config --global core.editor "code --wait"`
`git config --global -e`

## cURL

### Testing an API using cURL

- Make a test.json file, eg -

```js
{
  "name": "TEST HOOK1",
  "address": "https://www.your-server.com/foo/bar",
  "authentication_username": null,
  "authentication_password": null,
  "mode": "Production",
  "events": "foo,bar,bundy",
  "is_active": true
}
```

Then send a `cURL` command thusly:
`curl https://server.co/v1.0/path -d @test.json -u TEST:TEST`
Where
`-d` tells it we’re sending data (like a form post)
`@` tells it we’re using data from a file, not the command line
`-u` tells it we’re sending `username:password`, in this case `TEST:TEST`
