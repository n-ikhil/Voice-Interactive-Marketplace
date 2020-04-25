## API endpoints

|index|url|HTTP Verb|action description|protocols|
|-|-|-|-|-|-|-|
|1|profiles/login/|POST| used to authorize access|[login](#login)|
|2|profiles/register/|POST| used to register user|result|[register](#register)|
|3|marketplace/rental/add_product/|POST| used to add an item to the rental db|[add product](#marketplace-rental-add-product)|

---

1. Sample I/O's

..* Register

Input:

|key|value type|required|
|---|----------|--------|
|user|email string|&#9745;|
|password|string|:heavy_check_mark: |
|location| string|&#9744;|
|language|string|[]|
|contact|string|[]|

Output:

|key|value|
|---|-----|
|result|bool|
|info|string|


..* Login

Input:

|key|value type|required|
|---|----------|--------|
|user|email string|- [x]|
|password|string|- [x]|

* Output

|key|value|
|---|-----|
|result|bool|
|info|string|