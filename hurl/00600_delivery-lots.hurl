# Feature: CRUD operations for Delivery Lots API
#
#   ----------
#   Background:
#     Given the API is available in a given host
#     And the user is authenticated
#     And the vehicle #1 is created with the following data:
#       | field | value    |
#       | name  | "pickup" |
#     And the fleet #1 is created with the following data:
#       | field    | value                               |
#       | name     | "fleet"                             |
#       | vehicles | [{"id":"{{vehicle01_id}}","qty":5}] |
#     And the driver #1 is created with the following data:
#       | field      | value  |
#       | first_name | "John" |
#     And the milestone #1 is created with the following data:
#       | field    | value               |
#       | name     | "Main Depot"        |
#       | location | "37.7749,-122.4194" |
#     And the delivery #1 is created with the following data:
#       | field           | value                        |
#       | milestone_id    | "{{ milestone01_id }}"       |
#       | destination     | "37.7749,-122.4194"          |
#     And the delivery #2 is created with the following data:
#       | field           | value                        |
#       | milestone_id    | "{{ milestone01_id }}"       |
#       | destination     | "37.7749,-122.4194"          |

POST {{ host }}/vehicles
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: vehiclesCRUD
x-fake-step: vehiclesCreate0
Prefer: example=vehicle-1.0
{
  "name": "pickup"
}
HTTP 201
[Captures]
vehicle01_id: jsonpath "$.id"

POST {{ host }}/fleets
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: fleetsCRUD
x-fake-step: fleetsCreate0
Prefer: example=fleet-1.0
{
  "name": "fleet",
  "vehicles": [{"id":"{{vehicle01_id}}","qty":2}]
}
HTTP 201
[Captures]
fleet01_id: jsonpath "$.id"

POST {{ host }}/drivers
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: driversCRUD
x-fake-step: driversCreate0
Prefer: example=driver-1.0
{
  "first_name": "John"
}
HTTP 201
[Captures]
driver01_id: jsonpath "$.id"

POST {{ host }}/milestones
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: milestonesCRUD
x-fake-step: milestonesCreate0
Prefer: example=milestone-1.0
{
  "name": "Main Depot",
  "location": "37.7749,-122.4194"
}
HTTP 201
[Captures]
milestone01_id: jsonpath "$.id"

POST {{ host }}/deliveries
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesCreate0
Prefer: example=delivery-1.0
{
  "milestone_id": "{{ milestone01_id }}",
  "destination": "37.7749,-122.4194"
}
HTTP 201
[Captures]
delivery01_id: jsonpath "$.id"

POST {{ host }}/deliveries
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveriesCRUD
x-fake-step: deliveriesCreate0
Prefer: example=delivery-1.0
{
  "milestone_id": "{{ milestone01_id }}",
  "destination": "37.7749,-122.4194"
}
HTTP 201
[Captures]
delivery02_id: jsonpath "$.id"


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
#       | field                       | value                   |
#       | milestone_id                | "{{ milestone01_id }}"  |
#       | deliveries                  | ["{{ delivery01_id }}"] |
#       | fleet_id                    | "{{ fleet01_id }}"      |
#       | drivers                     | ["{{ driver01_id }}"]   |
#       | vehicle_limits.volume_min   | 70                      |
#       | vehicle_limits.volume_max   | 90                      |
#       | vehicle_limits.capacity_min | 10                      |
#       | vehicle_limits.capacity_max | 100                     |
#       | route_limits.stops_min      | 1                       |
#       | route_limits.stops_max      | 20                      |
#       | route_limits.length_min     | 1                       |
#       | route_limits.length_max     | 100                     |
#       | route_limits.length_unit    | "KILOMETER"             |
#       | route_limits.time_min       | 1                       |
#       | route_limits.time_max       | 8                       |
#       | route_limits.time_unit      | "HOUR"                  |
#     Then the response status should be 200
#     And the response should contain an object that contains:
#       | field                       | value                          |
#       | id                          | <delivery_lot_id>              |
#       | milestone.id                | "{{ milestone01_id }}"         |
#       | deliveries                  | [{"id":"{{ delivery01_id }}"}] |
#       | fleet.id                    | "{{ fleet01_id }}"             |
#       | drivers                     | [{"id":"{{ driver01_id }}"}]   |
#       | vehicle_limits.volume_min   | 70                             |
#       | vehicle_limits.volume_max   | 90                             |
#       | vehicle_limits.capacity_min | 10                             |
#       | vehicle_limits.capacity_max | 100                            |
#       | route_limits.stops_min      | 1                              |
#       | route_limits.stops_max      | 20                             |
#       | route_limits.length_min     | 1                              |
#       | route_limits.length_max     | 100                            |
#       | route_limits.length_unit    | "KILOMETER"                    |
#       | route_limits.time_min       | 1                              |
#       | route_limits.time_max       | 8                              |
#       | route_limits.time_unit      | "HOUR"                         |
#       | state                       | "UNPROCESSED"                  |

POST {{ host }}/lots
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsCreate0
Prefer: example=delivery-lot-1.0
{
  "milestone_id": "{{ milestone01_id }}",
  "deliveries": ["{{ delivery01_id }}"],
  "fleet_id": "{{ fleet01_id }}",
  "drivers": ["{{ driver01_id }}"],
  "vehicle_limits": {
    "volume_min": 70,
    "volume_max": 90,
    "capacity_min": 10,
    "capacity_max": 100
  },
  "route_limits": {
    "stops_min": 1,
    "stops_max": 20,
    "length_min": 1,
    "length_max": 100,
    "length_unit": "KILOMETER",
    "time_min": 1,
    "time_max": 8,
    "time_unit": "HOUR"
  }
}
HTTP 201
[Captures]
delivery_lot_id: jsonpath "$.id"
[Asserts]
header "sl-violations" not exists
header "location" exists
jsonpath "$.id" isString
jsonpath "$.milestone.id" == "{{ milestone01_id }}"
jsonpath "$.deliveries" count == 1
jsonpath "$.deliveries[0].id" == "{{ delivery01_id }}"
jsonpath "$.fleet.id" == "{{ fleet01_id }}"
jsonpath "$.drivers" count == 1
jsonpath "$.drivers[0].id" == "{{ driver01_id }}"
jsonpath "$.vehicle_limits.volume_min" == 70
jsonpath "$.vehicle_limits.volume_max" == 90
jsonpath "$.vehicle_limits.capacity_min" == 10
jsonpath "$.vehicle_limits.capacity_max" == 100
jsonpath "$.route_limits.stops_min" == 1
jsonpath "$.route_limits.stops_max" == 20
jsonpath "$.route_limits.length_min" == 1
jsonpath "$.route_limits.length_max" == 100
jsonpath "$.route_limits.length_unit" == "KILOMETER"
jsonpath "$.route_limits.time_min" == 1
jsonpath "$.route_limits.time_max" == 8
jsonpath "$.route_limits.time_unit" == "HOUR"
jsonpath "$.state" == "UNPROCESSED"


#   --------
#   Scenario: List all delivery-lots (second time)
#     When a GET request is send to "/lots"
#     Then the response status should be 200
#     And the response should have one more item
#     And the response should contain an object that contains:
#       | field                       | value                          |
#       | id                          | <delivery_lot_id>              |
#       | milestone.id                | "{{ milestone01_id }}"         |
#       | deliveries                  | [{"id":"{{ delivery01_id }}"}] |
#       | fleet.id                    | "{{ fleet01_id }}"             |
#       | drivers                     | [{"id":"{{ driver01_id }}"}]   |
#       | vehicle_limits.volume_min   | 70                             |
#       | vehicle_limits.volume_max   | 90                             |
#       | vehicle_limits.capacity_min | 10                             |
#       | vehicle_limits.capacity_max | 100                            |
#       | route_limits.stops_min      | 1                              |
#       | route_limits.stops_max      | 20                             |
#       | route_limits.length_min     | 1                              |
#       | route_limits.length_max     | 100                            |
#       | route_limits.length_unit    | "KILOMETER"                    |
#       | route_limits.time_min       | 1                              |
#       | route_limits.time_max       | 8                              |
#       | route_limits.time_unit      | "HOUR"                         |
#       | state                       | "UNPROCESSED"                  |

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
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')]" count == 1
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].milestone.id" nth 0 == "{{ milestone01_id }}"
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].deliveries" nth 0 count == 1
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].deliveries[0].id" nth 0 == "{{ delivery01_id }}"
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].fleet.id" nth 0 == "{{ fleet01_id }}"
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].drivers" nth 0 count == 1
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].drivers[0].id" nth 0 == "{{ driver01_id }}"
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].vehicle_limits.volume_min" nth 0 == 70
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].vehicle_limits.volume_max" nth 0 == 90
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].vehicle_limits.capacity_min" nth 0 == 10
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].vehicle_limits.capacity_max" nth 0 == 100
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.stops_min" nth 0 == 1
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.stops_max" nth 0 == 20
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.length_min" nth 0 == 1
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.length_max" nth 0 == 100
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.length_unit" nth 0 == "KILOMETER"
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.time_min" nth 0 == 1
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.time_max" nth 0 == 8
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.time_unit" nth 0 == "HOUR"
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].state" nth 0 == "UNPROCESSED"


#   --------
#   Scenario: View recently created delivery-lots
#     Given a delivery-lots has been created
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a GET request is sent to "/lots/<delivery_lot_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field                       | value                          |
#       | id                          | <delivery_lot_id>              |
#       | milestone.id                | "{{ milestone01_id }}"         |
#       | deliveries                  | [{"id":"{{ delivery01_id }}"}] |
#       | fleet.id                    | "{{ fleet01_id }}"             |
#       | drivers                     | [{"id":"{{ driver01_id }}"}]   |
#       | vehicle_limits.volume_min   | 70                             |
#       | vehicle_limits.volume_max   | 90                             |
#       | vehicle_limits.capacity_min | 10                             |
#       | vehicle_limits.capacity_max | 100                            |
#       | route_limits.stops_min      | 1                              |
#       | route_limits.stops_max      | 20                             |
#       | route_limits.length_min     | 1                              |
#       | route_limits.length_max     | 100                            |
#       | route_limits.length_unit    | "KILOMETER"                    |
#       | route_limits.time_min       | 1                              |
#       | route_limits.time_max       | 8                              |
#       | route_limits.time_unit      | "HOUR"                         |
#       | state                       | "UNPROCESSED"                  |

GET {{ host }}/lots/{{ delivery_lot_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsGetDeliveryLot0
Prefer: example=delivery-lot-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == "{{ delivery_lot_id }}"
jsonpath "$.milestone.id" == "{{ milestone01_id }}"
jsonpath "$.deliveries" count == 1
jsonpath "$.deliveries[0].id" == "{{ delivery01_id }}"
jsonpath "$.fleet.id" == "{{ fleet01_id }}"
jsonpath "$.drivers" count == 1
jsonpath "$.drivers[0].id" == "{{ driver01_id }}"
jsonpath "$.vehicle_limits.volume_min" == 70
jsonpath "$.vehicle_limits.volume_max" == 90
jsonpath "$.vehicle_limits.capacity_min" == 10
jsonpath "$.vehicle_limits.capacity_max" == 100
jsonpath "$.route_limits.stops_min" == 1
jsonpath "$.route_limits.stops_max" == 20
jsonpath "$.route_limits.length_min" == 1
jsonpath "$.route_limits.length_max" == 100
jsonpath "$.route_limits.length_unit" == "KILOMETER"
jsonpath "$.route_limits.time_min" == 1
jsonpath "$.route_limits.time_max" == 8
jsonpath "$.route_limits.time_unit" == "HOUR"
jsonpath "$.state" == "UNPROCESSED"


#   --------
#   Scenario: Update an existing delivery-lots
#     Given a delivery-lots exist
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a PATCH request is sent to "/lots/<delivery_lot_id>" with the following data:
#       | field      | value                   |
#       | deliveries | ["{{ delivery02_id }}"] |
#     Then the response status should be 200
#     And the response should contain:
#       | field                       | value                          |
#       | id                          | <delivery_lot_id>              |
#       | milestone.id                | "{{ milestone01_id }}"         |
#       | deliveries                  | [{"id":"{{ delivery02_id }}"}] |
#       | fleet.id                    | "{{ fleet01_id }}"             |
#       | drivers                     | [{"id":"{{ driver01_id }}"}]   |
#       | vehicle_limits.volume_min   | 70                             |
#       | vehicle_limits.volume_max   | 90                             |
#       | vehicle_limits.capacity_min | 10                             |
#       | vehicle_limits.capacity_max | 100                            |
#       | route_limits.stops_min      | 1                              |
#       | route_limits.stops_max      | 20                             |
#       | route_limits.length_min     | 1                              |
#       | route_limits.length_max     | 100                            |
#       | route_limits.length_unit    | "KILOMETER"                    |
#       | route_limits.time_min       | 1                              |
#       | route_limits.time_max       | 8                              |
#       | route_limits.time_unit      | "HOUR"                         |
#       | state                       | "UNPROCESSED"                  |

PATCH {{ host }}/lots/{{ delivery_lot_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsUpdateDeliveryLot0
Prefer: example=delivery-lot-1.1
{
  "deliveries": ["{{ delivery02_id }}"]
}
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == "{{ delivery_lot_id }}"
jsonpath "$.milestone.id" == "{{ milestone01_id }}"
jsonpath "$.deliveries" count == 1
jsonpath "$.deliveries[0].id" == "{{ delivery02_id }}"
jsonpath "$.fleet.id" == "{{ fleet01_id }}"
jsonpath "$.drivers" count == 1
jsonpath "$.drivers[0].id" == "{{ driver01_id }}"
jsonpath "$.vehicle_limits.volume_min" == 70
jsonpath "$.vehicle_limits.volume_max" == 90
jsonpath "$.vehicle_limits.capacity_min" == 10
jsonpath "$.vehicle_limits.capacity_max" == 100
jsonpath "$.route_limits.stops_min" == 1
jsonpath "$.route_limits.stops_max" == 20
jsonpath "$.route_limits.length_min" == 1
jsonpath "$.route_limits.length_max" == 100
jsonpath "$.route_limits.length_unit" == "KILOMETER"
jsonpath "$.route_limits.time_min" == 1
jsonpath "$.route_limits.time_max" == 8
jsonpath "$.route_limits.time_unit" == "HOUR"
jsonpath "$.state" == "UNPROCESSED"


#   --------
#   Scenario: List all delivery-lots (third time)
#     When a GET request is send to "/lots"
#     Then the response status should be 200
#     And the response should contain an object that contains:
#       | field                       | value                          |
#       | id                          | <delivery_lot_id>              |
#       | milestone.id                | "{{ milestone01_id }}"         |
#       | deliveries                  | [{"id":"{{ delivery02_id }}"}] |
#       | fleet.id                    | "{{ fleet01_id }}"             |
#       | drivers                     | [{"id":"{{ driver01_id }}"}]   |
#       | vehicle_limits.volume_min   | 70                             |
#       | vehicle_limits.volume_max   | 90                             |
#       | vehicle_limits.capacity_min | 10                             |
#       | vehicle_limits.capacity_max | 100                            |
#       | route_limits.stops_min      | 1                              |
#       | route_limits.stops_max      | 20                             |
#       | route_limits.length_min     | 1                              |
#       | route_limits.length_max     | 100                            |
#       | route_limits.length_unit    | "KILOMETER"                    |
#       | route_limits.time_min       | 1                              |
#       | route_limits.time_max       | 8                              |
#       | route_limits.time_unit      | "HOUR"                         |
#       | state                       | "UNPROCESSED"                  |

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
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')]" count == 1
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].milestone.id" nth 0 == "{{ milestone01_id }}"
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].deliveries" nth 0 count == 1
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].deliveries[0].id" nth 0 == "{{ delivery02_id }}"
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].fleet.id" nth 0 == "{{ fleet01_id }}"
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].drivers" nth 0 count == 1
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].drivers[0].id" nth 0 == "{{ driver01_id }}"
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].vehicle_limits.volume_min" nth 0 == 70
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].vehicle_limits.volume_max" nth 0 == 90
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].vehicle_limits.capacity_min" nth 0 == 10
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].vehicle_limits.capacity_max" nth 0 == 100
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.stops_min" nth 0 == 1
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.stops_max" nth 0 == 20
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.length_min" nth 0 == 1
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.length_max" nth 0 == 100
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.length_unit" nth 0 == "KILOMETER"
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.time_min" nth 0 == 1
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.time_max" nth 0 == 8
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].route_limits.time_unit" nth 0 == "HOUR"
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')].state" nth 0 == "UNPROCESSED"


#   --------
#   Scenario: View recently updated delivery-lots
#     Given a delivery-lots has been updated
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a GET request is sent to "/lots/<delivery_lot_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field                       | value                          |
#       | id                          | <delivery_lot_id>              |
#       | milestone.id                | "{{ milestone01_id }}"         |
#       | deliveries                  | [{"id":"{{ delivery02_id }}"}] |
#       | fleet.id                    | "{{ fleet01_id }}"             |
#       | drivers                     | [{"id":"{{ driver01_id }}"}]   |
#       | vehicle_limits.volume_min   | 70                             |
#       | vehicle_limits.volume_max   | 90                             |
#       | vehicle_limits.capacity_min | 10                             |
#       | vehicle_limits.capacity_max | 100                            |
#       | route_limits.stops_min      | 1                              |
#       | route_limits.stops_max      | 20                             |
#       | route_limits.length_min     | 1                              |
#       | route_limits.length_max     | 100                            |
#       | route_limits.length_unit    | "KILOMETER"                    |
#       | route_limits.time_min       | 1                              |
#       | route_limits.time_max       | 8                              |
#       | route_limits.time_unit      | "HOUR"                         |
#       | state                       | "UNPROCESSED"                  |

GET {{ host }}/lots/{{ delivery_lot_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsGetDeliveryLot1
Prefer: example=delivery-lot-1.1
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == "{{ delivery_lot_id }}"
jsonpath "$.milestone.id" == "{{ milestone01_id }}"
jsonpath "$.deliveries" count == 1
jsonpath "$.deliveries[0].id" == "{{ delivery02_id }}"
jsonpath "$.fleet.id" == "{{ fleet01_id }}"
jsonpath "$.drivers" count == 1
jsonpath "$.drivers[0].id" == "{{ driver01_id }}"
jsonpath "$.vehicle_limits.volume_min" == 70
jsonpath "$.vehicle_limits.volume_max" == 90
jsonpath "$.vehicle_limits.capacity_min" == 10
jsonpath "$.vehicle_limits.capacity_max" == 100
jsonpath "$.route_limits.stops_min" == 1
jsonpath "$.route_limits.stops_max" == 20
jsonpath "$.route_limits.length_min" == 1
jsonpath "$.route_limits.length_max" == 100
jsonpath "$.route_limits.length_unit" == "KILOMETER"
jsonpath "$.route_limits.time_min" == 1
jsonpath "$.route_limits.time_max" == 8
jsonpath "$.route_limits.time_unit" == "HOUR"
jsonpath "$.state" == "UNPROCESSED"


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
jsonpath "$[?(@.id == '{{ delivery_lot_id }}')]" count == 0


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


#   --------
#   Delete Vehicles #1
#   And Fleet #1
#   And Driver #1
#   And Milestone #1
#   And Delivery #1
#   And Delivery #2

DELETE {{ host }}/vehicles/{{ vehicle01_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/fleets/{{ fleet01_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/drivers/{{ driver01_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/milestones/{{ milestone01_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/deliveries/{{ delivery01_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/deliveries/{{ delivery02_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200
