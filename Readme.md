for help :read read-me file of myna

Add little discription of myna-nest .

## API endpoints

|index|url|HTTP Verb|action description|input variables|output variables|sample i/o|
|-|-|-|-|-|-|-|
|1|login/|POST| used to authorize access|username,password|result|[Link](#login)|

### Sample I/O's

### Login

input

``` json
{
  "username": "John@g.com",
  "password": "<encrypted-pass>",
}

```

output

``` json
{
  "Result":true
}

```

#### Register
