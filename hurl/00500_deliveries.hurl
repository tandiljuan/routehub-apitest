# Feature: CRUD operations for Deliveries API
#
#   ----------
#   Background:
#     Given the API is available in a given host
#     And the user is authenticated


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
#       | delivery_method | "DELIVERY"                   |
#       | milestone_id    | 1                            |
#       | destination     | "37.7749,-122.4194"          |
#       | schedule        | ["DTSTART:20240704T120000Z"] |
#       | width           | 10                           |
#       | height          | 20                           |
#       | depth           | 30                           |
#       | length_unit     | "CENTIMETER"                 |
#       | volume          | 6000                         |
#       | volume_unit     | "CUBIC_CENTIMETER"           |
#       | weight          | 1000                         |
#       | weight_unit     | "GRAMS"                      |
#     Then the response status should be 200
#     And the response should contain the created delivery details

POST {{ host }}/deliveries
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesCreate0
Prefer: example=delivery-1.0
{
  "delivery_method": "DELIVERY",
  "milestone_id": 1,
  "destination": "37.7749,-122.4194",
  "schedule": ["DTSTART:20240704T120000Z"],
  "width": 10,
  "height": 20,
  "depth": 30,
  "length_unit": "CENTIMETER",
  "volume": 6000,
  "volume_unit": "CUBIC_CENTIMETER",
  "weight": 1000,
  "weight_unit": "GRAMS"
}
HTTP 200
[Captures]
delivery_id: jsonpath "$.id"
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" isInteger
jsonpath "$.delivery_method" == "DELIVERY"
jsonpath "$.milestone_id" == 1
jsonpath "$.destination" == "37.7749,-122.4194"
jsonpath "$.schedule" count == 1
jsonpath "$.schedule[0]" == "DTSTART:20240704T120000Z"
jsonpath "$.width" == 10
jsonpath "$.height" == 20
jsonpath "$.depth" == 30
jsonpath "$.length_unit" == "CENTIMETER"
jsonpath "$.volume" == 6000
jsonpath "$.volume_unit" == "CUBIC_CENTIMETER"
jsonpath "$.weight" == 1000
jsonpath "$.weight_unit" == "GRAMS"


#   --------
#   Scenario: List all deliveries (second time)
#     When a GET request is send to "/deliveries"
#     Then the response status should be 200
#     And the response should have one more item
#     And the response should contain an object that contains:
#       | field           | value                        |
#       | id              | <delivery_id>                |
#       | delivery_method | "DELIVERY"                   |
#       | milestone_id    | 1                            |
#       | destination     | "37.7749,-122.4194"          |
#       | schedule        | ["DTSTART:20240704T120000Z"] |
#       | width           | 10                           |
#       | height          | 20                           |
#       | depth           | 30                           |
#       | length_unit     | "CENTIMETER"                 |
#       | volume          | 6000                         |
#       | volume_unit     | "CUBIC_CENTIMETER"           |
#       | weight          | 1000                         |
#       | weight_unit     | "GRAMS"                      |

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
jsonpath "$[?(@.id == {{ delivery_id }})]" count == 1
jsonpath "$[?(@.id == {{ delivery_id }})].delivery_method" nth 0 == "DELIVERY"
jsonpath "$[?(@.id == {{ delivery_id }})].milestone_id" nth 0 == 1
jsonpath "$[?(@.id == {{ delivery_id }})].destination" nth 0 == "37.7749,-122.4194"
jsonpath "$[?(@.id == {{ delivery_id }})].schedule" nth 0 count == 1
jsonpath "$[?(@.id == {{ delivery_id }})].schedule[0]" nth 0 == "DTSTART:20240704T120000Z"
jsonpath "$[?(@.id == {{ delivery_id }})].width" nth 0 == 10
jsonpath "$[?(@.id == {{ delivery_id }})].height" nth 0 == 20
jsonpath "$[?(@.id == {{ delivery_id }})].depth" nth 0 == 30
jsonpath "$[?(@.id == {{ delivery_id }})].length_unit" nth 0 == "CENTIMETER"
jsonpath "$[?(@.id == {{ delivery_id }})].volume" nth 0 == 6000
jsonpath "$[?(@.id == {{ delivery_id }})].volume_unit" nth 0 == "CUBIC_CENTIMETER"
jsonpath "$[?(@.id == {{ delivery_id }})].weight" nth 0 == 1000
jsonpath "$[?(@.id == {{ delivery_id }})].weight_unit" nth 0 == "GRAMS"


#   --------
#   Scenario: View recently created delivery
#     Given a delivery has been created
#     And the delivery's ID is stored as <delivery_id>
#     When a GET request is sent to "/deliveries/<delivery_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field           | value                        |
#       | id              | <delivery_id>                |
#       | delivery_method | "DELIVERY"                   |
#       | milestone_id    | 1                            |
#       | destination     | "37.7749,-122.4194"          |
#       | schedule        | ["DTSTART:20240704T120000Z"] |
#       | width           | 10                           |
#       | height          | 20                           |
#       | depth           | 30                           |
#       | length_unit     | "CENTIMETER"                 |
#       | volume          | 6000                         |
#       | volume_unit     | "CUBIC_CENTIMETER"           |
#       | weight          | 1000                         |
#       | weight_unit     | "GRAMS"                      |

GET {{ host }}/deliveries/{{ delivery_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesGetDelivery0
Prefer: example=delivery-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == {{ delivery_id }}
jsonpath "$.delivery_method" == "DELIVERY"
jsonpath "$.milestone_id" == 1
jsonpath "$.destination" == "37.7749,-122.4194"
jsonpath "$.schedule" count == 1
jsonpath "$.schedule[0]" == "DTSTART:20240704T120000Z"
jsonpath "$.width" == 10
jsonpath "$.height" == 20
jsonpath "$.depth" == 30
jsonpath "$.length_unit" == "CENTIMETER"
jsonpath "$.volume" == 6000
jsonpath "$.volume_unit" == "CUBIC_CENTIMETER"
jsonpath "$.weight" == 1000
jsonpath "$.weight_unit" == "GRAMS"


#   --------
#   Scenario: Update an existing delivery
#     Given a delivery exist
#     And the delivery's ID is stored as <delivery_id>
#     When a PATCH request is sent to "/deliveries/<delivery_id>" with the following data:
#       | field           | value                        |
#       | width           | 15                           |
#       | height          | 25                           |
#       | depth           | 35                           |
#       | volume          | 6500                         |
#       | weight          | 1500                         |
#     Then the response status should be 200
#     And the response should contain:
#       | field           | value                        |
#       | id              | <delivery_id>                |
#       | delivery_method | "DELIVERY"                   |
#       | milestone_id    | 1                            |
#       | destination     | "37.7749,-122.4194"          |
#       | schedule        | ["DTSTART:20240704T120000Z"] |
#       | width           | 15                           |
#       | height          | 25                           |
#       | depth           | 35                           |
#       | length_unit     | "CENTIMETER"                 |
#       | volume          | 6500                         |
#       | volume_unit     | "CUBIC_CENTIMETER"           |
#       | weight          | 1500                         |
#       | weight_unit     | "GRAMS"                      |

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
jsonpath "$.id" == {{ delivery_id }}
jsonpath "$.delivery_method" == "DELIVERY"
jsonpath "$.milestone_id" == 1
jsonpath "$.destination" == "37.7749,-122.4194"
jsonpath "$.schedule" count == 1
jsonpath "$.schedule[0]" == "DTSTART:20240704T120000Z"
jsonpath "$.width" == 15
jsonpath "$.height" == 25
jsonpath "$.depth" == 35
jsonpath "$.length_unit" == "CENTIMETER"
jsonpath "$.volume" == 6500
jsonpath "$.volume_unit" == "CUBIC_CENTIMETER"
jsonpath "$.weight" == 1500
jsonpath "$.weight_unit" == "GRAMS"


#   --------
#   Scenario: List all deliveries (third time)
#     When a GET request is send to "/deliveries"
#     Then the response status should be 200
#     And the response should contain an object that contains:
#       | field           | value                        |
#       | id              | <delivery_id>                |
#       | delivery_method | "DELIVERY"                   |
#       | milestone_id    | 1                            |
#       | destination     | "37.7749,-122.4194"          |
#       | schedule        | ["DTSTART:20240704T120000Z"] |
#       | width           | 15                           |
#       | height          | 25                           |
#       | depth           | 35                           |
#       | length_unit     | "CENTIMETER"                 |
#       | volume          | 6500                         |
#       | volume_unit     | "CUBIC_CENTIMETER"           |
#       | weight          | 1500                         |
#       | weight_unit     | "GRAMS"                      |

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
jsonpath "$[?(@.id == {{ delivery_id }})]" count == 1
jsonpath "$[?(@.id == {{ delivery_id }})].delivery_method" nth 0 == "DELIVERY"
jsonpath "$[?(@.id == {{ delivery_id }})].milestone_id" nth 0 == 1
jsonpath "$[?(@.id == {{ delivery_id }})].destination" nth 0 == "37.7749,-122.4194"
jsonpath "$[?(@.id == {{ delivery_id }})].schedule" nth 0 count == 1
jsonpath "$[?(@.id == {{ delivery_id }})].schedule[0]" nth 0 == "DTSTART:20240704T120000Z"
jsonpath "$[?(@.id == {{ delivery_id }})].width" nth 0 == 15
jsonpath "$[?(@.id == {{ delivery_id }})].height" nth 0 == 25
jsonpath "$[?(@.id == {{ delivery_id }})].depth" nth 0 == 35
jsonpath "$[?(@.id == {{ delivery_id }})].length_unit" nth 0 == "CENTIMETER"
jsonpath "$[?(@.id == {{ delivery_id }})].volume" nth 0 == 6500
jsonpath "$[?(@.id == {{ delivery_id }})].volume_unit" nth 0 == "CUBIC_CENTIMETER"
jsonpath "$[?(@.id == {{ delivery_id }})].weight" nth 0 == 1500
jsonpath "$[?(@.id == {{ delivery_id }})].weight_unit" nth 0 == "GRAMS"


#   --------
#   Scenario: View recently updated delivery
#     Given a delivery has been updated
#     And the delivery's ID is stored as <delivery_id>
#     When a GET request is sent to "/deliveries/<delivery_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field           | value                        |
#       | id              | <delivery_id>                |
#       | delivery_method | "DELIVERY"                   |
#       | milestone_id    | 1                            |
#       | destination     | "37.7749,-122.4194"          |
#       | schedule        | ["DTSTART:20240704T120000Z"] |
#       | width           | 15                           |
#       | height          | 25                           |
#       | depth           | 35                           |
#       | length_unit     | "CENTIMETER"                 |
#       | volume          | 6500                         |
#       | volume_unit     | "CUBIC_CENTIMETER"           |
#       | weight          | 1500                         |
#       | weight_unit     | "GRAMS"                      |

GET {{ host }}/deliveries/{{ delivery_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesGetDelivery1
Prefer: example=delivery-1.1
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == {{ delivery_id }}
jsonpath "$.delivery_method" == "DELIVERY"
jsonpath "$.milestone_id" == 1
jsonpath "$.destination" == "37.7749,-122.4194"
jsonpath "$.schedule" count == 1
jsonpath "$.schedule[0]" == "DTSTART:20240704T120000Z"
jsonpath "$.width" == 15
jsonpath "$.height" == 25
jsonpath "$.depth" == 35
jsonpath "$.length_unit" == "CENTIMETER"
jsonpath "$.volume" == 6500
jsonpath "$.volume_unit" == "CUBIC_CENTIMETER"
jsonpath "$.weight" == 1500
jsonpath "$.weight_unit" == "GRAMS"


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
jsonpath "$[?(@.id == {{ delivery_id }})]" count == 0


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
