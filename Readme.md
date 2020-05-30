#

## API endpoints

|index|url|HTTP Verb|action description|protocols|
|-|-|-|-|-|
|1|profiles/login/|POST| used to authorize access|[login](#login)|
|2|profiles/register/|POST| used to register user|[register](#register)|
|3|marketplace/rental/add_product/|POST| used to add an item to the rental db|[add product](#marketplace-rental-add-product)|
|5|chat/getThreadList/|GET| Used to obtain all the threads |[obtain thread list](#chat-get-thread-list)

|5|chat/getThread/{ username of reciever }|GET| Used to obtain the chat thread with the person mentioned |[obtain thread](#chat-get-thread)

|6|chat/newMessage/|POST| used to add a message |[new message](#chat-new-message)|

---

## Sample I/O's

chat assumptions


### Chat get thread list

* Output:
json List of following structure
|key|value|
|-|-|
|username|string|
|userid|int|
|thread|int|

### Chat get particular Thread

* Input: type get
|key|value|
|-|-|
|username|string|

* output:
|key|value|description|
|-|-|
|messages|list of messages|it returns list of messages, each message having following structure|

* message structure
|key|value|description|
|-|-|-|
|timestamp|datetime|the time of message following|
| message| string | The actual message|
| sender | string | sender |

### Chat new Message

* Input: type post
|key|value type|
|---|-----|
|threadId| int|
|message|string|

deduce sender using token

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