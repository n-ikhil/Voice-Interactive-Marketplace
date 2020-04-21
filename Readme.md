for help :read read-me file of myna

Add little discription of myna-nest .

## API endpoints

|index|url|HTTP Verb|action description|input variables|output variables|sample i/o|
|-|-|-|-|-|-|-|
|1|login/|POST| used to authorize access|username,password|result|[Link to login](#login)|
|2|register/|POST| used to register user|username,password,email etc etc>|result|[Link to register](#register)|

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

input

``` json
{
  " username ":"NIkhil",
  "Location" :"Jakarta"
}

````

output

``` json
{
  "result":true
}

```
