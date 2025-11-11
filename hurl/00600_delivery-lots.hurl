# Feature: CRUD operations for Delivery Lots API
#
#   ----------
#   Background:
#     Given the API is available in a given host
#     And the user is authenticated


#   --------
#   Scenario: List all delivery-lots (first time)
#     When a GET request is send to "/lots"
#     Then the response status should be 200
#     And the response should be a list equal of greater than zero

GET {{ host }}/lots
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsGetList0
Prefer: example=empty
HTTP 200
[Captures]
list_count: jsonpath "$" count
[Asserts]
header "sl-violations" not exists
variable "list_count" >= 0


#   --------
#   Scenario: Create a new DeliveryLot
#     When a POST request is send to "/lots" with the following data:
#       | field        | value         |
#       | milestone_id | 1             |
#       | deliveries   | [1]           |
#       | fleet_id     | 1             |
#       | drivers      | [1]           |
#       | state        | "UNPROCESSED" |
#     Then the response status should be 200
#     And the response should contain an object that contains:
#       | field        | value             |
#       | id           | <delivery_lot_id> |
#       | milestone_id | 1                 |
#       | deliveries   | [1]               |
#       | fleet_id     | 1                 |
#       | drivers      | [1]               |
#       | state        | "UNPROCESSED"     |

POST {{ host }}/lots
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsCreate0
Prefer: example=delivery-lot-1.0
{
  "milestone_id": 1,
  "deliveries": [1],
  "fleet_id": 1,
  "drivers": [1],
  "state": "UNPROCESSED"
}
HTTP 200
[Captures]
delivery_lot_id: jsonpath "$.id"
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" isInteger
jsonpath "$.milestone_id" == 1
jsonpath "$.deliveries" count == 1
jsonpath "$.deliveries[0]" == 1
jsonpath "$.fleet_id" == 1
jsonpath "$.drivers" count == 1
jsonpath "$.drivers[0]" == 1
jsonpath "$.state" == "UNPROCESSED"


#   --------
#   Scenario: List all delivery-lots (second time)
#     When a GET request is send to "/lots"
#     Then the response status should be 200
#     And the response should have one more item
#     And the response should contain an object that contains:
#       | field        | value             |
#       | id           | <delivery_lot_id> |
#       | milestone_id | 1                 |
#       | deliveries   | [1]               |
#       | fleet_id     | 1                 |
#       | drivers      | [1]               |
#       | state        | "UNPROCESSED"     |

GET {{ host }}/lots
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsGetList1
Prefer: example=list-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count > {{ list_count }}
jsonpath "$[?(@.id == {{ delivery_lot_id }})]" count == 1
jsonpath "$[?(@.id == {{ delivery_lot_id }})].milestone_id" nth 0 == 1
jsonpath "$[?(@.id == {{ delivery_lot_id }})].deliveries" nth 0 count == 1
jsonpath "$[?(@.id == {{ delivery_lot_id }})].deliveries[0]" nth 0 == 1
jsonpath "$[?(@.id == {{ delivery_lot_id }})].fleet_id" nth 0 == 1
jsonpath "$[?(@.id == {{ delivery_lot_id }})].drivers" nth 0 count == 1
jsonpath "$[?(@.id == {{ delivery_lot_id }})].drivers[0]" nth 0 == 1
jsonpath "$[?(@.id == {{ delivery_lot_id }})].state" nth 0 == "UNPROCESSED"


#   --------
#   Scenario: View recently created delivery-lots
#     Given a delivery-lots has been created
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a GET request is sent to "/lots/<delivery_lot_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field        | value             |
#       | id           | <delivery_lot_id> |
#       | milestone_id | 1                 |
#       | deliveries   | [1]               |
#       | fleet_id     | 1                 |
#       | drivers      | [1]               |
#       | state        | "UNPROCESSED"     |

GET {{ host }}/lots/{{ delivery_lot_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsGetDeliveryLot0
Prefer: example=delivery-lot-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == {{ delivery_lot_id }}
jsonpath "$.milestone_id" == 1
jsonpath "$.deliveries" count == 1
jsonpath "$.deliveries[0]" == 1
jsonpath "$.fleet_id" == 1
jsonpath "$.drivers" count == 1
jsonpath "$.drivers[0]" == 1
jsonpath "$.state" == "UNPROCESSED"


#   --------
#   Scenario: Update an existing delivery-lots
#     Given a delivery-lots exist
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a PATCH request is sent to "/lots/<delivery_lot_id>" with the following data:
#       | field        | value  |
#       | deliveries   | [1, 2] |
#     Then the response status should be 200
#     And the response should contain:
#       | field        | value             |
#       | id           | <delivery_lot_id> |
#       | milestone_id | 1                 |
#       | deliveries   | [1, 2]            |
#       | fleet_id     | 1                 |
#       | drivers      | [1]               |
#       | state        | "UNPROCESSED"     |

PATCH {{ host }}/lots/{{ delivery_lot_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsUpdateDeliveryLot0
Prefer: example=delivery-lot-1.1
{
  "deliveries": [1, 2]
}
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == {{ delivery_lot_id }}
jsonpath "$.milestone_id" == 1
jsonpath "$.deliveries" count == 2
jsonpath "$.deliveries[0]" == 1
jsonpath "$.deliveries[1]" == 2
jsonpath "$.fleet_id" == 1
jsonpath "$.drivers" count == 1
jsonpath "$.drivers[0]" == 1
jsonpath "$.state" == "UNPROCESSED"


#   --------
#   Scenario: List all delivery-lots (third time)
#     When a GET request is send to "/lots"
#     Then the response status should be 200
#     And the response should contain an object that contains:
#       | field        | value             |
#       | id           | <delivery_lot_id> |
#       | milestone_id | 1                 |
#       | deliveries   | [1, 2]            |
#       | fleet_id     | 1                 |
#       | drivers      | [1]               |
#       | state        | "UNPROCESSED"     |

GET {{ host }}/lots
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsGetList2
Prefer: example=list-1.1
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count > {{ list_count }}
jsonpath "$[?(@.id == {{ delivery_lot_id }})]" count == 1
jsonpath "$[?(@.id == {{ delivery_lot_id }})].milestone_id" nth 0 == 1
jsonpath "$[?(@.id == {{ delivery_lot_id }})].deliveries" nth 0 count == 2
jsonpath "$[?(@.id == {{ delivery_lot_id }})].deliveries[0]" nth 0 == 1
jsonpath "$[?(@.id == {{ delivery_lot_id }})].deliveries[1]" nth 0 == 2
jsonpath "$[?(@.id == {{ delivery_lot_id }})].fleet_id" nth 0 == 1
jsonpath "$[?(@.id == {{ delivery_lot_id }})].drivers" nth 0 count == 1
jsonpath "$[?(@.id == {{ delivery_lot_id }})].drivers[0]" nth 0 == 1
jsonpath "$[?(@.id == {{ delivery_lot_id }})].state" nth 0 == "UNPROCESSED"


#   --------
#   Scenario: View recently updated delivery-lots
#     Given a delivery-lots has been updated
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a GET request is sent to "/lots/<delivery_lot_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field        | value             |
#       | id           | <delivery_lot_id> |
#       | milestone_id | 1                 |
#       | deliveries   | [1, 2]            |
#       | fleet_id     | 1                 |
#       | drivers      | [1]               |
#       | state        | "UNPROCESSED"     |

GET {{ host }}/lots/{{ delivery_lot_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsGetDeliveryLot1
Prefer: example=delivery-lot-1.1
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == {{ delivery_lot_id }}
jsonpath "$.milestone_id" == 1
jsonpath "$.deliveries" count == 2
jsonpath "$.deliveries[0]" == 1
jsonpath "$.deliveries[1]" == 2
jsonpath "$.fleet_id" == 1
jsonpath "$.drivers" count == 1
jsonpath "$.drivers[0]" == 1
jsonpath "$.state" == "UNPROCESSED"


#   --------
#   Scenario: Generate/Update delivery plan for existing delivery lot
#     Given a delivery-lots exists
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a POST request is sent to "/lots/<delivery_lot_id>/plan"
#     Then the response status should be 200

POST {{ host }}/lots/{{ delivery_lot_id }}/plan
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsUpdatePlan0
HTTP 200

#   --------
#   Scenario: Get delivery plan for existing delivery lot
#     Given a delivery-lots exists
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a GET request is sent to "/lots/<delivery_lot_id>/plan"
#     Then the response status should be 200
#     And the response should contain the delivery plan

GET {{ host }}/lots/{{ delivery_lot_id }}/plan
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsGetPlan0
Prefer: example=delivery-plan-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.delivery_lot_id" == {{ delivery_lot_id }}
jsonpath "$.delivery_paths" count == 1
jsonpath "$.delivery_paths[0].milestone_id" == 1
jsonpath "$.delivery_paths[0].vehicle_id" == 1
jsonpath "$.delivery_paths[0].driver_id" == 1
jsonpath "$.delivery_paths[0].delivery_units" count == 2
jsonpath "$.delivery_paths[0].delivery_units[0]" == 1
jsonpath "$.delivery_paths[0].delivery_units[1]" == 2


#   --------
#   Scenario: Delete a DeliveryLot
#     Given a delivery-lots exist
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a DELETE request is sent to "/lots/<delivery_lot_id>"
#     Then the response status should be 200

DELETE {{ host }}/lots/{{ delivery_lot_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsDeleteDeliveryLot0
HTTP 200


#   --------
#   Scenario: List all delivery-lots (fourth time)
#     Given a delivery-lot has been deleted
#     And the delivery-lot's ID was stored as <delivery_lot_id>
#     When a GET request is send to "/lots"
#     Then the response status should be 200
#     And the response should have one less item
#     And the delivery-lot with ID <delivery_lot_id> does not appear in the response

GET {{ host }}/lots
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsGetList0
Prefer: example=empty
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count == {{ list_count }}
jsonpath "$[?(@.id == {{ delivery_lot_id }})]" count == 0


#   --------
#   Scenario: View recently deleted delivery-lots
#     Given a delivery-lots has been deleted
#     And the delivery-lots's ID was stored as <delivery_lot_id>
#     When a GET request is sent to "/lots/<delivery_lot_id>"
#     Then the response status should be 404

GET {{ host }}/lots/{{ delivery_lot_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsGetDeliveryLot2
Prefer: code=404
HTTP 404
