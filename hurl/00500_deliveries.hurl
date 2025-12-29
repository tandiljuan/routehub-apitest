# Feature: CRUD operations for Deliveries API
#
#   ----------
#   Background:
#     Given the API is available in a given host
#     And the user is authenticated
#     And the milestone #1 is created with the following data:
#       | field    | value               |
#       | name     | "Main Depot"        |
#       | location | "37.7749,-122.4194" |
#       | category | "DEPOT"             |

POST {{ host }}/milestones
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: milestonesCRUD
x-fake-step: milestonesCreate0
Prefer: example=milestone-1.0
{
  "name": "Main Depot",
  "location": "37.7749,-122.4194",
  "category": "DEPOT"
}
HTTP 201
[Captures]
milestone01_id: jsonpath "$.id"


#   --------
#   Scenario: List all deliveries (first time)
#     When a GET request is send to "/deliveries"
#     Then the response status should be 200
#     And the response should be a list equal of greater than zero

GET {{ host }}/deliveries
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesGetList0
Prefer: example=empty
HTTP 200
[Captures]
list_count: jsonpath "$" count
[Asserts]
header "sl-violations" not exists
variable "list_count" >= 0


#   --------
#   Scenario: Create a new Delivery
#     When a POST request is send to "/deliveries" with the following data:
#       | field           | value                        |
#       | method          | "DELIVERY"                   |
#       | milestone_id    | "{{ milestone01_id }}"       |
#       | destination     | "37.7749,-122.4194"          |
#       | schedules       | ["DTSTART:20240704T120000Z"] |
#       | width           | 10                           |
#       | height          | 20                           |
#       | depth           | 30                           |
#       | length_unit     | "CENTIMETER"                 |
#       | volume          | 6000                         |
#       | volume_unit     | "CUBIC_CENTIMETER"           |
#       | weight          | 1000                         |
#       | weight_unit     | "GRAMS"                      |
#       | packaging       | "BOX"                        |
#       | handling        | ["FRAGILE"]                  |
#       | value_cents     | 10000                        |
#       | value_currency  | "USD"                        |
#       | extra           | {"note":"custom"}            |
#     Then the response status should be 200
#     And the response should contain the created delivery details

POST {{ host }}/deliveries
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesCreate0
Prefer: example=delivery-1.0
{
  "method": "DELIVERY",
  "milestone_id": "{{ milestone01_id }}",
  "destination": "37.7749,-122.4194",
  "schedules": ["DTSTART:20240704T120000Z"],
  "width": 10,
  "height": 20,
  "depth": 30,
  "length_unit": "CENTIMETER",
  "volume": 6000,
  "volume_unit": "CUBIC_CENTIMETER",
  "weight": 1000,
  "weight_unit": "GRAMS",
  "packaging": "BOX",
  "handling": ["FRAGILE"],
  "value_cents": 10000,
  "value_currency": "USD",
  "extra": {"note":"custom"}
}
HTTP 201
[Captures]
delivery_id: jsonpath "$.id"
[Asserts]
header "sl-violations" not exists
header "location" exists
jsonpath "$.id" isString
jsonpath "$.method" == "DELIVERY"
jsonpath "$.milestone.id" == "{{ milestone01_id }}"
jsonpath "$.destination" == "37.7749,-122.4194"
jsonpath "$.schedules" count == 1
jsonpath "$.schedules[0]" == "DTSTART:20240704T120000Z"
jsonpath "$.width" == 10
jsonpath "$.height" == 20
jsonpath "$.depth" == 30
jsonpath "$.length_unit" == "CENTIMETER"
jsonpath "$.volume" == 6000
jsonpath "$.volume_unit" == "CUBIC_CENTIMETER"
jsonpath "$.weight" == 1000
jsonpath "$.weight_unit" == "GRAMS"
jsonpath "$.packaging" == "BOX"
jsonpath "$.handling" count == 1
jsonpath "$.handling[0]" == "FRAGILE"
jsonpath "$.value_cents" == 10000
jsonpath "$.value_currency" == "USD"
jsonpath "$.extra.note" == "custom"


#   --------
#   Scenario: List all deliveries (second time)
#     When a GET request is send to "/deliveries"
#     Then the response status should be 200
#     And the response should have one more item
#     And the response should contain an object that contains:
#       | field           | value                         |
#       | id              | <delivery_id>                 |
#       | method          | "DELIVERY"                    |
#       | milestone       | {"id":"{{ milestone01_id }}"} |
#       | destination     | "37.7749,-122.4194"           |
#       | schedules       | ["DTSTART:20240704T120000Z"]  |
#       | width           | 10                            |
#       | height          | 20                            |
#       | depth           | 30                            |
#       | length_unit     | "CENTIMETER"                  |
#       | volume          | 6000                          |
#       | volume_unit     | "CUBIC_CENTIMETER"            |
#       | weight          | 1000                          |
#       | weight_unit     | "GRAMS"                       |
#       | packaging       | "BOX"                         |
#       | handling        | ["FRAGILE"]                   |
#       | value_cents     | 10000                         |
#       | value_currency  | "USD"                         |
#       | extra           | {"note":"custom"}             |

GET {{ host }}/deliveries
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesGetList1
Prefer: example=list-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count > {{ list_count }}
jsonpath "$[?(@.id == '{{ delivery_id }}')]" count == 1
jsonpath "$[?(@.id == '{{ delivery_id }}')].method" nth 0  == "DELIVERY"
jsonpath "$[?(@.id == '{{ delivery_id }}')].milestone.id" nth 0  == "{{ milestone01_id }}"
jsonpath "$[?(@.id == '{{ delivery_id }}')].destination" nth 0  == "37.7749,-122.4194"
jsonpath "$[?(@.id == '{{ delivery_id }}')].schedules" nth 0  count == 1
jsonpath "$[?(@.id == '{{ delivery_id }}')].schedules[0]" nth 0  == "DTSTART:20240704T120000Z"
jsonpath "$[?(@.id == '{{ delivery_id }}')].width" nth 0  == 10
jsonpath "$[?(@.id == '{{ delivery_id }}')].height" nth 0  == 20
jsonpath "$[?(@.id == '{{ delivery_id }}')].depth" nth 0  == 30
jsonpath "$[?(@.id == '{{ delivery_id }}')].length_unit" nth 0  == "CENTIMETER"
jsonpath "$[?(@.id == '{{ delivery_id }}')].volume" nth 0  == 6000
jsonpath "$[?(@.id == '{{ delivery_id }}')].volume_unit" nth 0  == "CUBIC_CENTIMETER"
jsonpath "$[?(@.id == '{{ delivery_id }}')].weight" nth 0  == 1000
jsonpath "$[?(@.id == '{{ delivery_id }}')].weight_unit" nth 0  == "GRAMS"
jsonpath "$[?(@.id == '{{ delivery_id }}')].packaging" nth 0  == "BOX"
jsonpath "$[?(@.id == '{{ delivery_id }}')].handling" nth 0  count == 1
jsonpath "$[?(@.id == '{{ delivery_id }}')].handling[0]" nth 0  == "FRAGILE"
jsonpath "$[?(@.id == '{{ delivery_id }}')].value_cents" nth 0  == 10000
jsonpath "$[?(@.id == '{{ delivery_id }}')].value_currency" nth 0  == "USD"
jsonpath "$[?(@.id == '{{ delivery_id }}')].extra.note" nth 0  == "custom"


#   --------
#   Scenario: View recently created delivery
#     Given a delivery has been created
#     And the delivery's ID is stored as <delivery_id>
#     When a GET request is sent to "/deliveries/<delivery_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field           | value                         |
#       | id              | <delivery_id>                 |
#       | method          | "DELIVERY"                    |
#       | milestone       | {"id":"{{ milestone01_id }}"} |
#       | destination     | "37.7749,-122.4194"           |
#       | schedules       | ["DTSTART:20240704T120000Z"]  |
#       | width           | 10                            |
#       | height          | 20                            |
#       | depth           | 30                            |
#       | length_unit     | "CENTIMETER"                  |
#       | volume          | 6000                          |
#       | volume_unit     | "CUBIC_CENTIMETER"            |
#       | weight          | 1000                          |
#       | weight_unit     | "GRAMS"                       |
#       | packaging       | "BOX"                         |
#       | handling        | ["FRAGILE"]                   |
#       | value_cents     | 10000                         |
#       | value_currency  | "USD"                         |
#       | extra           | {"note":"custom"}             |

GET {{ host }}/deliveries/{{ delivery_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesGetDelivery0
Prefer: example=delivery-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == "{{ delivery_id }}"
jsonpath "$.method" == "DELIVERY"
jsonpath "$.milestone.id" == "{{ milestone01_id }}"
jsonpath "$.destination" == "37.7749,-122.4194"
jsonpath "$.schedules" count == 1
jsonpath "$.schedules[0]" == "DTSTART:20240704T120000Z"
jsonpath "$.width" == 10
jsonpath "$.height" == 20
jsonpath "$.depth" == 30
jsonpath "$.length_unit" == "CENTIMETER"
jsonpath "$.volume" == 6000
jsonpath "$.volume_unit" == "CUBIC_CENTIMETER"
jsonpath "$.weight" == 1000
jsonpath "$.weight_unit" == "GRAMS"
jsonpath "$.packaging" == "BOX"
jsonpath "$.handling" count == 1
jsonpath "$.handling[0]" == "FRAGILE"
jsonpath "$.value_cents" == 10000
jsonpath "$.value_currency" == "USD"
jsonpath "$.extra.note" == "custom"


#   --------
#   Scenario: Update an existing delivery
#     Given a delivery exist
#     And the delivery's ID is stored as <delivery_id>
#     When a PATCH request is sent to "/deliveries/<delivery_id>" with the following data:
#       | field           | value                         |
#       | width           | 15                            |
#       | height          | 25                            |
#       | depth           | 35                            |
#       | volume          | 6500                          |
#       | weight          | 1500                          |
#     Then the response status should be 200
#     And the response should contain:
#       | field           | value                         |
#       | id              | <delivery_id>                 |
#       | method          | "DELIVERY"                    |
#       | milestone       | {"id":"{{ milestone01_id }}"} |
#       | destination     | "37.7749,-122.4194"           |
#       | schedules       | ["DTSTART:20240704T120000Z"]  |
#       | width           | 15                            |
#       | height          | 25                            |
#       | depth           | 35                            |
#       | length_unit     | "CENTIMETER"                  |
#       | volume          | 6500                          |
#       | volume_unit     | "CUBIC_CENTIMETER"            |
#       | weight          | 1500                          |
#       | weight_unit     | "GRAMS"                       |
#       | packaging       | "BOX"                         |
#       | handling        | ["FRAGILE"]                   |
#       | value_cents     | 10000                         |
#       | value_currency  | "USD"                         |
#       | extra           | {"note":"custom"}             |

PATCH {{ host }}/deliveries/{{ delivery_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesUpdateDelivery0
Prefer: example=delivery-1.1
{
  "width": 15,
  "height": 25,
  "depth": 35,
  "volume": 6500,
  "weight": 1500
}
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == "{{ delivery_id }}"
jsonpath "$.method" == "DELIVERY"
jsonpath "$.milestone.id" == "{{ milestone01_id }}"
jsonpath "$.destination" == "37.7749,-122.4194"
jsonpath "$.schedules" count == 1
jsonpath "$.schedules[0]" == "DTSTART:20240704T120000Z"
jsonpath "$.width" == 15
jsonpath "$.height" == 25
jsonpath "$.depth" == 35
jsonpath "$.length_unit" == "CENTIMETER"
jsonpath "$.volume" == 6500
jsonpath "$.volume_unit" == "CUBIC_CENTIMETER"
jsonpath "$.weight" == 1500
jsonpath "$.weight_unit" == "GRAMS"
jsonpath "$.packaging" == "BOX"
jsonpath "$.handling" count == 1
jsonpath "$.handling[0]" == "FRAGILE"
jsonpath "$.value_cents" == 10000
jsonpath "$.value_currency" == "USD"
jsonpath "$.extra.note" == "custom"


#   --------
#   Scenario: List all deliveries (third time)
#     When a GET request is send to "/deliveries"
#     Then the response status should be 200
#     And the response should contain an object that contains:
#       | field           | value                         |
#       | id              | <delivery_id>                 |
#       | method          | "DELIVERY"                    |
#       | milestone       | {"id":"{{ milestone01_id }}"} |
#       | destination     | "37.7749,-122.4194"           |
#       | schedules       | ["DTSTART:20240704T120000Z"]  |
#       | width           | 15                            |
#       | height          | 25                            |
#       | depth           | 35                            |
#       | length_unit     | "CENTIMETER"                  |
#       | volume          | 6500                          |
#       | volume_unit     | "CUBIC_CENTIMETER"            |
#       | weight          | 1500                          |
#       | weight_unit     | "GRAMS"                       |
#       | packaging       | "BOX"                         |
#       | handling        | ["FRAGILE"]                   |
#       | value_cents     | 10000                         |
#       | value_currency  | "USD"                         |
#       | extra           | {"note":"custom"}             |

GET {{ host }}/deliveries
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesGetList2
Prefer: example=list-1.1
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count > {{ list_count }}
jsonpath "$[?(@.id == '{{ delivery_id }}')]" count == 1
jsonpath "$[?(@.id == '{{ delivery_id }}')].method" nth 0  == "DELIVERY"
jsonpath "$[?(@.id == '{{ delivery_id }}')].milestone.id" nth 0  == "{{ milestone01_id }}"
jsonpath "$[?(@.id == '{{ delivery_id }}')].destination" nth 0  == "37.7749,-122.4194"
jsonpath "$[?(@.id == '{{ delivery_id }}')].schedules" nth 0  count == 1
jsonpath "$[?(@.id == '{{ delivery_id }}')].schedules[0]" nth 0  == "DTSTART:20240704T120000Z"
jsonpath "$[?(@.id == '{{ delivery_id }}')].width" nth 0  == 15
jsonpath "$[?(@.id == '{{ delivery_id }}')].height" nth 0  == 25
jsonpath "$[?(@.id == '{{ delivery_id }}')].depth" nth 0  == 35
jsonpath "$[?(@.id == '{{ delivery_id }}')].length_unit" nth 0  == "CENTIMETER"
jsonpath "$[?(@.id == '{{ delivery_id }}')].volume" nth 0  == 6500
jsonpath "$[?(@.id == '{{ delivery_id }}')].volume_unit" nth 0  == "CUBIC_CENTIMETER"
jsonpath "$[?(@.id == '{{ delivery_id }}')].weight" nth 0  == 1500
jsonpath "$[?(@.id == '{{ delivery_id }}')].weight_unit" nth 0  == "GRAMS"
jsonpath "$[?(@.id == '{{ delivery_id }}')].packaging" nth 0  == "BOX"
jsonpath "$[?(@.id == '{{ delivery_id }}')].handling" nth 0  count == 1
jsonpath "$[?(@.id == '{{ delivery_id }}')].handling[0]" nth 0  == "FRAGILE"
jsonpath "$[?(@.id == '{{ delivery_id }}')].value_cents" nth 0  == 10000
jsonpath "$[?(@.id == '{{ delivery_id }}')].value_currency" nth 0  == "USD"
jsonpath "$[?(@.id == '{{ delivery_id }}')].extra.note" nth 0  == "custom"


#   --------
#   Scenario: View recently updated delivery
#     Given a delivery has been updated
#     And the delivery's ID is stored as <delivery_id>
#     When a GET request is sent to "/deliveries/<delivery_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field           | value                         |
#       | id              | <delivery_id>                 |
#       | method          | "DELIVERY"                    |
#       | milestone       | {"id":"{{ milestone01_id }}"} |
#       | destination     | "37.7749,-122.4194"           |
#       | schedules       | ["DTSTART:20240704T120000Z"]  |
#       | width           | 15                            |
#       | height          | 25                            |
#       | depth           | 35                            |
#       | length_unit     | "CENTIMETER"                  |
#       | volume          | 6500                          |
#       | volume_unit     | "CUBIC_CENTIMETER"            |
#       | weight          | 1500                          |
#       | weight_unit     | "GRAMS"                       |
#       | packaging       | "BOX"                         |
#       | handling        | ["FRAGILE"]                   |
#       | value_cents     | 10000                         |
#       | value_currency  | "USD"                         |
#       | extra           | {"note":"custom"}             |

GET {{ host }}/deliveries/{{ delivery_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesGetDelivery1
Prefer: example=delivery-1.1
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == "{{ delivery_id }}"
jsonpath "$.method" == "DELIVERY"
jsonpath "$.milestone.id" == "{{ milestone01_id }}"
jsonpath "$.destination" == "37.7749,-122.4194"
jsonpath "$.schedules" count == 1
jsonpath "$.schedules[0]" == "DTSTART:20240704T120000Z"
jsonpath "$.width" == 15
jsonpath "$.height" == 25
jsonpath "$.depth" == 35
jsonpath "$.length_unit" == "CENTIMETER"
jsonpath "$.volume" == 6500
jsonpath "$.volume_unit" == "CUBIC_CENTIMETER"
jsonpath "$.weight" == 1500
jsonpath "$.weight_unit" == "GRAMS"
jsonpath "$.packaging" == "BOX"
jsonpath "$.handling" count == 1
jsonpath "$.handling[0]" == "FRAGILE"
jsonpath "$.value_cents" == 10000
jsonpath "$.value_currency" == "USD"
jsonpath "$.extra.note" == "custom"


#   --------
#   Scenario: Delete a Delivery
#     Given a delivery exist
#     And the delivery's ID is stored as <delivery_id>
#     When a DELETE request is sent to "/deliveries/<delivery_id>"
#     Then the response status should be 200

DELETE {{ host }}/deliveries/{{ delivery_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesDeleteDelivery0
HTTP 200


#   --------
#   Scenario: List all deliveries (fourth time)
#     Given a delivery has been deleted
#     And the delivery's ID was stored as <delivery_id>
#     When a GET request is send to "/deliveries"
#     Then the response status should be 200
#     And the response should have one less item
#     And the delivery with ID <delivery_id> does not appear in the response

GET {{ host }}/deliveries
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesGetList0
Prefer: example=empty
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count == {{ list_count }}
jsonpath "$[?(@.id == '{{ delivery_id }}')]" count == 0


#   --------
#   Scenario: View recently deleted delivery
#     Given a delivery has been deleted
#     And the delivery's ID was stored as <delivery_id>
#     When a GET request is sent to "/deliveries/<delivery_id>"
#     Then the response status should be 404

GET {{ host }}/deliveries/{{ delivery_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesGetDelivery2
Prefer: code=404
HTTP 404


#   --------
#   Scenario: Create deliveries in bulk
#     Given a a list of deliveries
#     When a POST request is send to "/deliveries/bulk" with a list that contains the following data:
#       | ----------------- Delivery 01 ---------------- |
#       | field           | value                        |
#       | milestone_id    | "{{ milestone01_id }}"       |
#       | destination     | "37.7749,-122.4194"          |
#       | ----------------- Delivery 02 ---------------- |
#       | field           | value                        |
#       | milestone_id    | "{{ milestone01_id }}"       |
#       | destination     | "37.7749,-122.4194"          |
#       | ----------------- Delivery 03 ---------------- |
#       | field           | value                        |
#       | milestone_id    | "{{ milestone01_id }}"       |
#       | destination     | "37.7749,-122.4194"          |
#     Then the response status should be 200
#     And the response should contain a list with the IDs of the created deliveries

POST {{ host }}/deliveries/bulk
authorization: Bearer {{ auth }}
Accept: application/json
[
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "37.7749,-122.4194"
  },
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "37.7749,-122.4194"
  },
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "37.7749,-122.4194"
  }
]
HTTP 200
[Captures]
delivery01_id: jsonpath "$[0]"
delivery02_id: jsonpath "$[1]"
delivery03_id: jsonpath "$[2]"
[Asserts]
header "sl-violations" not exists
jsonpath "$[0]" isString
jsonpath "$[1]" isString
jsonpath "$[2]" isString


#   --------
#   Scenario: Delete bulk created deliveries
#     Given the deliveries created in bulk
#     And the delivery's ID is stored as <deliveryNN_id>
#     When a DELETE request is sent to "/deliveries/<deliveryNN_id>"
#     Then the response status should be 200

DELETE {{ host }}/deliveries/{{ delivery01_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/deliveries/{{ delivery02_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/deliveries/{{ delivery03_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200


#   --------
#   Delete Milestone #1

DELETE {{ host }}/milestones/{{ milestone01_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200
