# Feature: CRUD operations for Fleets API
#
#   ----------
#   Background:
#     Given the API is available in a given host
#     And the user is authenticated


#   --------
#   Scenario: List all fleets (first time)
#     When a GET request is send to "/fleets"
#     Then the response status should be 200
#     And the response should be a list equal of greater than zero

GET {{ host }}/fleets
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: fleetsCRUD
x-fake-step: fleetsGetList0
Prefer: example=empty
HTTP 200
[Captures]
list_count: jsonpath "$" count
[Asserts]
header "sl-violations" not exists
variable "list_count" >= 0


#   --------
#   Scenario: Create a new Fleet
#     When a POST request is send to "/fleets" with the following data:
#       | field            | value                           |
#       | name             | "my-fleet"                      |
#       | vehicles         | [{"vehicle_id":1,"quantity":2}] |
#     Then the response status should be 200
#     And the response should contain an object that contains:
#       | field            | value                           |
#       | id               | <fleet_id>                      |
#       | name             | "my-fleet"                      |
#       | vehicles         | [{"vehicle_id":1,"quantity":2}] |

POST {{ host }}/fleets
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: fleetsCRUD
x-fake-step: fleetsCreate0
Prefer: example=fleet-1.0
{
  "name": "my-fleet",
  "vehicles": [{"vehicle_id":1,"quantity":2}]
}
HTTP 200
[Captures]
fleet_id: jsonpath "$.id"
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" isInteger
jsonpath "$.name" == "my-fleet"
jsonpath "$.vehicles" count == 1
jsonpath "$.vehicles[0].vehicle_id" == 1
jsonpath "$.vehicles[0].quantity" == 2


#   --------
#   Scenario: List all fleets (second time)
#     When a GET request is send to "/fleets"
#     Then the response status should be 200
#     And the response should have one more item
#     And the response should contain an object that contains:
#       | field            | value                           |
#       | id               | <fleet_id>                      |
#       | name             | "my-fleet"                      |
#       | vehicles         | [{"vehicle_id":1,"quantity":2}] |

GET {{ host }}/fleets
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: fleetsCRUD
x-fake-step: fleetsGetList1
Prefer: example=list-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count > {{ list_count }}
jsonpath "$[?(@.id == {{ fleet_id }})]" count == 1
jsonpath "$[?(@.id == {{ fleet_id }})].name" nth 0 == "my-fleet"
jsonpath "$[?(@.id == {{ fleet_id }})].vehicles" nth 0 count == 1
jsonpath "$[?(@.id == {{ fleet_id }})].vehicles[0].vehicle_id" nth 0 == 1
jsonpath "$[?(@.id == {{ fleet_id }})].vehicles[0].quantity" nth 0 == 2


#   --------
#   Scenario: View recently created fleet
#     Given a fleet has been created
#     And the fleet's ID is stored as <fleet_id>
#     When a GET request is sent to "/fleets/<fleet_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field            | value                           |
#       | id               | <fleet_id>                      |
#       | name             | "my-fleet"                      |
#       | vehicles         | [{"vehicle_id":1,"quantity":2}] |

GET {{ host }}/fleets/{{ fleet_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: fleetsCRUD
x-fake-step: fleetsGetFleet0
Prefer: example=fleet-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == {{ fleet_id }}
jsonpath "$.name" == "my-fleet"
jsonpath "$.vehicles" count == 1
jsonpath "$.vehicles[0].vehicle_id" == 1
jsonpath "$.vehicles[0].quantity" == 2


#   --------
#   Scenario: Update an existing fleet
#     Given a fleet exist
#     And the fleet's ID is stored as <fleet_id>
#     When a PATCH request is sent to "/fleets/<fleet_id>" with the following data:
#       | field            | value                           |
#       | name             | "my-fleet-update"               |
#       | vehicles         | [{"vehicle_id":2,"quantity":3}] |
#     Then the response status should be 200
#     And the response should contain:
#       | field            | value                           |
#       | id               | <fleet_id>                      |
#       | name             | "my-fleet-update"               |
#       | vehicles         | [{"vehicle_id":2,"quantity":3}] |

PATCH {{ host }}/fleets/{{ fleet_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: fleetsCRUD
x-fake-step: fleetsUpdateFleet0
Prefer: example=fleet-1.1
{
  "name": "my-fleet-update",
  "vehicles": [{"vehicle_id":2,"quantity":3}]
}
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == {{ fleet_id }}
jsonpath "$.name" == "my-fleet-update"
jsonpath "$.vehicles" count == 1
jsonpath "$.vehicles[0].vehicle_id" == 2
jsonpath "$.vehicles[0].quantity" == 3


#   --------
#   Scenario: List all fleets (third time)
#     When a GET request is send to "/fleets"
#     Then the response status should be 200
#     And the response should contain an object that contains:
#       | field            | value                           |
#       | id               | <fleet_id>                      |
#       | name             | "my-fleet-update"               |
#       | vehicles         | [{"vehicle_id":2,"quantity":3}] |

GET {{ host }}/fleets
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: fleetsCRUD
x-fake-step: fleetsGetList2
Prefer: example=list-1.1
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count > {{ list_count }}
jsonpath "$[?(@.id == {{ fleet_id }})]" count == 1
jsonpath "$[?(@.id == {{ fleet_id }})].name" nth 0 == "my-fleet-update"
jsonpath "$[?(@.id == {{ fleet_id }})].vehicles" nth 0 count == 1
jsonpath "$[?(@.id == {{ fleet_id }})].vehicles[0].vehicle_id" nth 0 == 2
jsonpath "$[?(@.id == {{ fleet_id }})].vehicles[0].quantity" nth 0 == 3


#   --------
#   Scenario: View recently updated fleet
#     Given a fleet has been updated
#     And the fleet's ID is stored as <fleet_id>
#     When a GET request is sent to "/fleets/<fleet_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field            | value                           |
#       | id               | <fleet_id>                      |
#       | name             | "my-fleet-update"               |
#       | vehicles         | [{"vehicle_id":2,"quantity":3}] |

GET {{ host }}/fleets/{{ fleet_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: fleetsCRUD
x-fake-step: fleetsGetFleet1
Prefer: example=fleet-1.1
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == {{ fleet_id }}
jsonpath "$.name" == "my-fleet-update"
jsonpath "$.vehicles" count == 1
jsonpath "$.vehicles[0].vehicle_id" == 2
jsonpath "$.vehicles[0].quantity" == 3


#   --------
#   Scenario: Delete a Fleet
#     Given a fleet exist
#     And the fleet's ID is stored as <fleet_id>
#     When a DELETE request is sent to "/fleets/<fleet_id>"
#     Then the response status should be 200

DELETE {{ host }}/fleets/{{ fleet_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: fleetsCRUD
x-fake-step: fleetsDeleteFleet0
HTTP 200


#   --------
#   Scenario: List all fleets (fourth time)
#     Given a fleet has been deleted
#     And the fleet's ID was stored as <fleet_id>
#     When a GET request is send to "/fleets"
#     Then the response status should be 200
#     And the response should have one less item
#     And the fleet with ID <fleet_id> does not appear in the response

GET {{ host }}/fleets
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: fleetsCRUD
x-fake-step: fleetsGetList0
Prefer: example=empty
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count == {{ list_count }}
jsonpath "$[?(@.id == {{ fleet_id }})]" count == 0


#   --------
#   Scenario: View recently deleted fleet
#     Given a fleet has been deleted
#     And the fleet's ID was stored as <fleet_id>
#     When a GET request is sent to "/fleets/<fleet_id>"
#     Then the response status should be 404

GET {{ host }}/fleets/{{ fleet_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: fleetsCRUD
x-fake-step: fleetsGetFleet2
Prefer: code=404
HTTP 404
