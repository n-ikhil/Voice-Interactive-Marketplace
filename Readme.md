#

## API endpoints

|index|url|HTTP Verb|action description|protocols|
|-|-|-|-|-|
|1|profiles/login/|POST| used to authorize access|[login](#login)|
|2|profiles/register/|POST| used to register user|[register](#register)|
|3|marketplace/rental/add_product/|POST| used to add an item to the rental db|[add product](#marketplace-rental-add-product)|

---

## Sample I/O's

---

### Register

* Input:

|key|value type|required|
|---|----------|--------|
|user|email string|:heavy_check_mark:|
|password|string|:heavy_check_mark: |
|location| string|:white_check_mark:|
|language|string|:white_check_mark:|
|contact|string|:white_check_mark:|

* Output:

|key|value|
|---|-----|
|result|bool|
|info|string|

---

### Login

* Input:

|key|value type|required|
|---|----------|--------|
|user|email string|:heavy_check_mark:|
|password|string|:heavy_check_mark:|

* Output

|key|value|
|---|-----|
|result|bool|
|info|string|