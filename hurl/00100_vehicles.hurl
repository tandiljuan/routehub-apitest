# Feature: CRUD operations for Vehicles API
#
#   ----------
#   Background:
#     Given the API is available in a given host
#     And the user is authenticated


#   --------
#   Scenario: List all vehicles (first time)
#     When a GET request is send to "/vehicles"
#     Then the response status should be 200
#     And the response should be a list equal of greater than zero

GET {{ host }}/vehicles
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: vehiclesCRUD
x-fake-step: vehiclesGetList0
Prefer: example=empty
HTTP 200
[Captures]
list_count: jsonpath "$" count
[Asserts]
header "sl-violations" not exists
variable "list_count" >= 0


#   --------
#   Scenario: Create a new Vehicle
#     When a POST request is send to "/vehicles" with the following data:
#       | field            | value              |
#       | name             | "pickup"           |
#       | volume           | 1230000            |
#       | volume_unit      | "CUBIC_CENTIMETER" |
#       | consumption      | 12                 |
#       | consumption_unit | "LITERS_PER_100KM" |
#       | category_type    | "PICKUP"           |
#       | engine_type      | "DIESEL"           |
#     Then the response status should be 200
#     And the response should contain an object that contains:
#       | field            | value              |
#       | id               | <vehicle_id>       |
#       | name             | "pickup"           |
#       | volume           | 1230000            |
#       | volume_unit      | "CUBIC_CENTIMETER" |
#       | consumption      | 12                 |
#       | consumption_unit | "LITERS_PER_100KM" |
#       | category_type    | "PICKUP"           |
#       | engine_type      | "DIESEL"           |

POST {{ host }}/vehicles
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: vehiclesCRUD
x-fake-step: vehiclesCreate0
Prefer: example=vehicle-1.0
{
  "name": "pickup",
  "volume": 1230000,
  "volume_unit": "CUBIC_CENTIMETER",
  "consumption": 12,
  "consumption_unit": "LITERS_PER_100KM",
  "category_type": "PICKUP",
  "engine_type": "DIESEL"
}
HTTP 200
[Captures]
vehicle_id: jsonpath "$.id"
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" isInteger
jsonpath "$.name" == "pickup"
jsonpath "$.volume" == 1230000
jsonpath "$.volume_unit" == "CUBIC_CENTIMETER"
jsonpath "$.consumption" == 12
jsonpath "$.consumption_unit" == "LITERS_PER_100KM"
jsonpath "$.category_type" == "PICKUP"
jsonpath "$.engine_type" == "DIESEL"


#   --------
#   Scenario: List all vehicles (second time)
#     When a GET request is send to "/vehicles"
#     Then the response status should be 200
#     And the response should have one more item
#     And the response should contain an object that contains:
#       | field            | value              |
#       | id               | <vehicle_id>       |
#       | name             | "pickup"           |
#       | volume           | 1230000            |
#       | volume_unit      | "CUBIC_CENTIMETER" |
#       | consumption      | 12                 |
#       | consumption_unit | "LITERS_PER_100KM" |
#       | category_type    | "PICKUP"           |
#       | engine_type      | "DIESEL"           |

GET {{ host }}/vehicles
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: vehiclesCRUD
x-fake-step: vehiclesGetList1
Prefer: example=list-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count > {{ list_count }}
jsonpath "$[?(@.id == {{ vehicle_id }})]" count == 1
jsonpath "$[?(@.id == {{ vehicle_id }})].name" nth 0 == "pickup"
jsonpath "$[?(@.id == {{ vehicle_id }})].volume" nth 0 == 1230000
jsonpath "$[?(@.id == {{ vehicle_id }})].volume_unit" nth 0 == "CUBIC_CENTIMETER"
jsonpath "$[?(@.id == {{ vehicle_id }})].consumption" nth 0 == 12
jsonpath "$[?(@.id == {{ vehicle_id }})].consumption_unit" nth 0 == "LITERS_PER_100KM"
jsonpath "$[?(@.id == {{ vehicle_id }})].category_type" nth 0 == "PICKUP"
jsonpath "$[?(@.id == {{ vehicle_id }})].engine_type" nth 0 == "DIESEL"


#   --------
#   Scenario: View recently created vehicle
#     Given a vehicle has been created
#     And the vehicle's ID is stored as <vehicle_id>
#     When a GET request is sent to "/vehicles/<vehicle_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field            | value              |
#       | id               | <vehicle_id>       |
#       | name             | "pickup"           |
#       | volume           | 1230000            |
#       | volume_unit      | "CUBIC_CENTIMETER" |
#       | consumption      | 12                 |
#       | consumption_unit | "LITERS_PER_100KM" |
#       | category_type    | "PICKUP"           |
#       | engine_type      | "DIESEL"           |

GET {{ host }}/vehicles/{{ vehicle_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: vehiclesCRUD
x-fake-step: vehiclesGetVehicle0
Prefer: example=vehicle-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == {{ vehicle_id }}
jsonpath "$.name" == "pickup"
jsonpath "$.volume" == 1230000
jsonpath "$.volume_unit" == "CUBIC_CENTIMETER"
jsonpath "$.consumption" == 12
jsonpath "$.consumption_unit" == "LITERS_PER_100KM"
jsonpath "$.category_type" == "PICKUP"
jsonpath "$.engine_type" == "DIESEL"


#   --------
#   Scenario: Update an existing vehicle
#     Given a vehicle exist
#     And the vehicle's ID is stored as <vehicle_id>
#     When a PATCH request is sent to "/vehicles/<vehicle_id>" with the following data:
#       | field            | value              |
#       | name             | "pickup-update"    |
#       | consumption      | 10                 |
#     Then the response status should be 200
#     And the response should contain:
#       | field            | value              |
#       | id               | <vehicle_id>       |
#       | name             | "pickup-update"    |
#       | volume           | 1230000            |
#       | volume_unit      | "CUBIC_CENTIMETER" |
#       | consumption      | 10                 |
#       | consumption_unit | "LITERS_PER_100KM" |
#       | category_type    | "PICKUP"           |
#       | engine_type      | "DIESEL"           |

PATCH {{ host }}/vehicles/{{ vehicle_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: vehiclesCRUD
x-fake-step: vehiclesUpdateVehicle0
Prefer: example=vehicle-1.1
{
  "name": "pickup-update",
  "consumption": 10
}
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == {{ vehicle_id }}
jsonpath "$.name" == "pickup-update"
jsonpath "$.volume" == 1230000
jsonpath "$.volume_unit" == "CUBIC_CENTIMETER"
jsonpath "$.consumption" == 10
jsonpath "$.consumption_unit" == "LITERS_PER_100KM"
jsonpath "$.category_type" == "PICKUP"
jsonpath "$.engine_type" == "DIESEL"


#   --------
#   Scenario: List all vehicles (third time)
#     When a GET request is send to "/vehicles"
#     Then the response status should be 200
#     And the response should contain an object that contains:
#       | field            | value              |
#       | id               | <vehicle_id>       |
#       | name             | "pickup-update"    |
#       | volume           | 1230000            |
#       | volume_unit      | "CUBIC_CENTIMETER" |
#       | consumption      | 10                 |
#       | consumption_unit | "LITERS_PER_100KM" |
#       | category_type    | "PICKUP"           |
#       | engine_type      | "DIESEL"           |

GET {{ host }}/vehicles
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: vehiclesCRUD
x-fake-step: vehiclesGetList2
Prefer: example=list-1.1
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count > {{ list_count }}
jsonpath "$[?(@.id == {{ vehicle_id }})]" count == 1
jsonpath "$[?(@.id == {{ vehicle_id }})].name" nth 0 == "pickup-update"
jsonpath "$[?(@.id == {{ vehicle_id }})].volume" nth 0 == 1230000
jsonpath "$[?(@.id == {{ vehicle_id }})].volume_unit" nth 0 == "CUBIC_CENTIMETER"
jsonpath "$[?(@.id == {{ vehicle_id }})].consumption" nth 0 == 10
jsonpath "$[?(@.id == {{ vehicle_id }})].consumption_unit" nth 0 == "LITERS_PER_100KM"
jsonpath "$[?(@.id == {{ vehicle_id }})].category_type" nth 0 == "PICKUP"
jsonpath "$[?(@.id == {{ vehicle_id }})].engine_type" nth 0 == "DIESEL"


#   --------
#   Scenario: View recently updated vehicle
#     Given a vehicle has been updated
#     And the vehicle's ID is stored as <vehicle_id>
#     When a GET request is sent to "/vehicles/<vehicle_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field            | value              |
#       | id               | <vehicle_id>       |
#       | name             | "pickup-update"    |
#       | volume           | 1230000            |
#       | volume_unit      | "CUBIC_CENTIMETER" |
#       | consumption      | 10                 |
#       | consumption_unit | "LITERS_PER_100KM" |
#       | category_type    | "PICKUP"           |
#       | engine_type      | "DIESEL"           |

GET {{ host }}/vehicles/{{ vehicle_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: vehiclesCRUD
x-fake-step: vehiclesGetVehicle1
Prefer: example=vehicle-1.1
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == {{ vehicle_id }}
jsonpath "$.name" == "pickup-update"
jsonpath "$.volume" == 1230000
jsonpath "$.volume_unit" == "CUBIC_CENTIMETER"
jsonpath "$.consumption" == 10
jsonpath "$.consumption_unit" == "LITERS_PER_100KM"
jsonpath "$.category_type" == "PICKUP"
jsonpath "$.engine_type" == "DIESEL"


#   --------
#   Scenario: Delete a Vehicle
#     Given a vehicle exist
#     And the vehicle's ID is stored as <vehicle_id>
#     When a DELETE request is sent to "/vehicles/<vehicle_id>"
#     Then the response status should be 200

DELETE {{ host }}/vehicles/{{ vehicle_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: vehiclesCRUD
x-fake-step: vehiclesDeleteVehicle0
HTTP 200


#   --------
#   Scenario: List all vehicles (fourth time)
#     Given a vehicle has been deleted
#     And the vehicle's ID was stored as <vehicle_id>
#     When a GET request is send to "/vehicles"
#     Then the response status should be 200
#     And the response should have one less item
#     And the vehicle with ID <vehicle_id> does not appear in the response

GET {{ host }}/vehicles
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: vehiclesCRUD
x-fake-step: vehiclesGetList0
Prefer: example=empty
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count == {{ list_count }}
jsonpath "$[?(@.id == {{ vehicle_id }})]" count == 0


#   --------
#   Scenario: View recently deleted vehicle
#     Given a vehicle has been deleted
#     And the vehicle's ID was stored as <vehicle_id>
#     When a GET request is sent to "/vehicles/<vehicle_id>"
#     Then the response status should be 404

GET {{ host }}/vehicles/{{ vehicle_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: vehiclesCRUD
x-fake-step: vehiclesGetVehicle2
Prefer: code=404
HTTP 404
