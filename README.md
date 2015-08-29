# Parsing your humans.txt into JSON

## <http://humans.herokuapp.com/>

## GET /:host?use_ssl=true

- **host** A host (domain) with a humans.txt
- **use_ssl (Optional)** Set to true if your domain requires HTTPS

## Examples

```sh
curl https://humans.herokuapp.com/c7.se | jq .
```

```sh
curl https://humans.herokuapp.com/humanstxt.org | jq .
```

```sh
curl https://humans.herokuapp.com/cheddarapp.com?use_ssl=true | jq .
```
