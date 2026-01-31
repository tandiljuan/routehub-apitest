# Feature: CRUD operations for Delivery Lots API
#
#   ----------
#   Background:
#     Given the API is available in a given host
#     And the user is authenticated
#     And the vehicle #1 is created with the following data:
#       | field | value    |
#       |-------+----------|
#       | name  | "pickup" |
#     And the fleet #1 is created with the following data:
#       | field    | value                               |
#       |----------+-------------------------------------|
#       | name     | "fleet"                             |
#       | vehicles | [{"id":"{{vehicle01_id}}","qty":4}] |
#     And the milestone #1 is created with the following data:
#       | field    | value                    |
#       |----------+--------------------------|
#       | name     | "Main Depot"             |
#       | location | "-34.621392,-58.389410/" |
#     And a bulk of deliveries is created with the following data:
#       | field        | value                    |
#       |--------------+--------------------------|
#       | ------[[ Route 01  Delivery 01 ]]------ |
#       | milestone_id | "{{ milestone01_id }}"   |
#       | destination  | "-34.601388,-58.403577/" |
#       | ------[[ Route 01  Delivery 02 ]]------ |
#       | milestone_id | "{{ milestone01_id }}"   |
#       | destination  | "-34.600900,-58.402955/" |
#       | ------[[ Route 01  Delivery 03 ]]------ |
#       | milestone_id | "{{ milestone01_id }}"   |
#       | destination  | "-34.601049,-58.401732/" |
#       | ------[[ Route 02  Delivery 04 ]]------ |
#       | milestone_id | "{{ milestone01_id }}"   |
#       | destination  | "-34.637377,-58.398374/" |
#       | ------[[ Route 02  Delivery 05 ]]------ |
#       | milestone_id | "{{ milestone01_id }}"   |
#       | destination  | "-34.638803,-58.397779/" |
#       | ------[[ Route 02  Delivery 06 ]]------ |
#       | milestone_id | "{{ milestone01_id }}"   |
#       | destination  | "-34.639175,-58.396853/" |
#       | ------[[ Route 03  Delivery 07 ]]------ |
#       | milestone_id | "{{ milestone01_id }}"   |
#       | destination  | "-34.627426,-58.420572/" |
#       | ------[[ Route 03  Delivery 08 ]]------ |
#       | milestone_id | "{{ milestone01_id }}"   |
#       | destination  | "-34.626838,-58.421366/" |
#       | ------[[ Route 03  Delivery 09 ]]------ |
#       | milestone_id | "{{ milestone01_id }}"   |
#       | destination  | "-34.625510,-58.421699/" |
#       | ------[[ Route 04  Delivery 10 ]]------ |
#       | milestone_id | "{{ milestone01_id }}"   |
#       | destination  | "-34.618431,-58.370903/" |
#       | ------[[ Route 04  Delivery 11 ]]------ |
#       | milestone_id | "{{ milestone01_id }}"   |
#       | destination  | "-34.618927,-58.370149/" |
#       | ------[[ Route 04  Delivery 12 ]]------ |
#       | milestone_id | "{{ milestone01_id }}"   |
#       | destination  | "-34.619441,-58.370828/" |
#     And the lot #1 is created with the following data:
#       | field                    | value                    |
#       |--------------------------+--------------------------|
#       | milestone_id             | "{{ milestone01_id }}"   |
#       | deliveries               | [                        |
#       |                          |   "{{ delivery01_id }}", |
#       |                          |   "{{ delivery02_id }}", |
#       |                          |   "{{ delivery03_id }}", |
#       |                          |   "{{ delivery04_id }}", |
#       |                          |   "{{ delivery05_id }}", |
#       |                          |   "{{ delivery06_id }}", |
#       |                          |   "{{ delivery07_id }}", |
#       |                          |   "{{ delivery08_id }}", |
#       |                          |   "{{ delivery09_id }}", |
#       |                          |   "{{ delivery10_id }}", |
#       |                          |   "{{ delivery11_id }}", |
#       |                          |   "{{ delivery12_id }}"  |
#       |                          | ]                        |
#       | fleet_id                 | "{{ fleet01_id }}"       |
#       | route_limits.stops_min   | 2                        |
#       | route_limits.stops_max   | 4                        |
#       | route_limits.length_min  | 1                        |
#       | route_limits.length_max  | 100                      |
#       | route_limits.length_unit | "KILOMETER"              |

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
  "vehicles": [{"id":"{{vehicle01_id}}","qty":4}]
}
HTTP 201
[Captures]
fleet01_id: jsonpath "$.id"

POST {{ host }}/milestones
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: milestonesCRUD
x-fake-step: milestonesCreate0
Prefer: example=milestone-1.0
{
  "name": "Main Depot",
  "location": "-34.621392,-58.389410/"
}
HTTP 201
[Captures]
milestone01_id: jsonpath "$.id"

POST {{ host }}/deliveries/bulk
authorization: Bearer {{ auth }}
Accept: application/json
[
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "-34.601388,-58.403577/"
  },
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "-34.600900,-58.402955/"
  },
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "-34.601049,-58.401732/"
  },
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "-34.637377,-58.398374/"
  },
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "-34.638803,-58.397779/"
  },
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "-34.639175,-58.396853/"
  },
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "-34.627426,-58.420572/"
  },
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "-34.626838,-58.421366/"
  },
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "-34.625510,-58.421699/"
  },
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "-34.618431,-58.370903/"
  },
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "-34.618927,-58.370149/"
  },
  {
    "milestone_id": "{{ milestone01_id }}",
    "destination": "-34.619441,-58.370828/"
  }
]
HTTP 200
[Captures]
delivery01_id: jsonpath "$[0]"
delivery02_id: jsonpath "$[1]"
delivery03_id: jsonpath "$[2]"
delivery04_id: jsonpath "$[3]"
delivery05_id: jsonpath "$[4]"
delivery06_id: jsonpath "$[5]"
delivery07_id: jsonpath "$[6]"
delivery08_id: jsonpath "$[7]"
delivery09_id: jsonpath "$[8]"
delivery10_id: jsonpath "$[9]"
delivery11_id: jsonpath "$[10]"
delivery12_id: jsonpath "$[11]"

POST {{ host }}/lots
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsCreate0
Prefer: example=delivery-lot-1.0
{
  "milestone_id": "{{ milestone01_id }}",
  "deliveries": [
    "{{ delivery01_id }}",
    "{{ delivery02_id }}",
    "{{ delivery03_id }}",
    "{{ delivery04_id }}",
    "{{ delivery05_id }}",
    "{{ delivery06_id }}",
    "{{ delivery07_id }}",
    "{{ delivery08_id }}",
    "{{ delivery09_id }}",
    "{{ delivery10_id }}",
    "{{ delivery11_id }}",
    "{{ delivery12_id }}"
  ],
  "fleet_id": "{{ fleet01_id }}",
  "route_limits": {
    "stops_min": 2,
    "stops_max": 4,
    "length_min": 1,
    "length_max": 100,
    "length_unit": "KILOMETER"
  }
}
HTTP 201
[Captures]
lot01_id: jsonpath "$.id"

#   -----------------------------------

#   --------
#   Scenario: Get delivery plan for existing delivery lot
#     Given a delivery-lots exists
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a GET request is sent to "/lots/<delivery_lot_id>/plan"
#     Then the response status should be 404

GET {{ host }}/lots/{{ lot01_id }}/plan
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsGetPlan0
Prefer: example=delivery-plan-1.0
HTTP 404
[Asserts]
header "sl-violations" not exists

#   --------
#   Scenario: Generate/Update delivery plan for existing delivery lot
#     Given a delivery-lots exists
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a POST request is sent to "/lots/<delivery_lot_id>/plan"
#     Then the response status should be 202

POST {{ host }}/lots/{{ lot01_id }}/plan
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsUpdatePlan0
HTTP 202

#   --------
#   Scenario: Get delivery plan for existing delivery lot
#     Given a delivery-lots exists
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a GET request is sent to "/lots/<delivery_lot_id>/plan"
#     Then the response status should be 200
#     And the response should contain the delivery plan

GET {{ host }}/lots/{{ lot01_id }}/plan
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsGetPlan0
Prefer: example=delivery-plan-1.0
[Options]
retry: 12
retry-interval: 5000
HTTP 200
[Captures]
route01_id: jsonpath "$.routes[0].id"
route02_id: jsonpath "$.routes[1].id"
[Asserts]
header "sl-violations" not exists
jsonpath "$.state" == "PROCESSED"

#   --------
#   Scenario: Change deliveries order in a delivery plan
#     Given a delivery-lots exists
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a PATCH request is sent to "/lots/<delivery_lot_id>/plan" with the following data:
#       | field             | value                 |
#       |-------------------+-----------------------|
#       | [0].id            | "{{ route01_id }}"    |
#       | [0].deliveries[0] | "{{ delivery08_id }}" |
#       | [0].deliveries[1] | "{{ delivery11_id }}" |
#       | [1].id            | "{{ route02_id }}"    |
#       | [1].deliveries[0] | "{{ delivery01_id }}" |
#       | [1].deliveries[1] | "{{ delivery03_id }}" |
#       | [1].deliveries[2] | "{{ delivery04_id }}" |
#       | [1].deliveries[3] | "{{ delivery06_id }}" |
#     Then the response status should be 202

PATCH {{ host }}/lots/{{ lot01_id }}/plan
authorization: Bearer {{ auth }}
Accept: application/json
[
  {
    "id": "{{ route01_id }}",
    "deliveries": [
      "{{ delivery08_id }}",
      "{{ delivery11_id }}"
    ]
  },
  {
    "id": "{{ route02_id }}",
    "deliveries": [
      "{{ delivery01_id }}",
      "{{ delivery03_id }}",
      "{{ delivery04_id }}",
      "{{ delivery06_id }}"
    ]
  }
]
HTTP 202

#   --------
#   Scenario: Get delivery plan for existing delivery lot
#     Given a delivery-lots exists
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a GET request is sent to "/lots/<delivery_lot_id>/plan"
#     Then the response status should be 200
#     And the response should contain the delivery plan

GET {{ host }}/lots/{{ lot01_id }}/plan
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsGetPlan0
Prefer: example=delivery-plan-1.0
[Options]
retry: 12
retry-interval: 5000
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.state" == "PROCESSED"
jsonpath "$.routes[?(@.id == '{{ route01_id }}')]" count == 1
jsonpath "$.routes[?(@.id == '{{ route01_id }}')].deliveries" nth 0 count == 2
jsonpath "$.routes[?(@.id == '{{ route01_id }}')].deliveries[?(@.id == '{{ delivery08_id }}')]" count == 1
jsonpath "$.routes[?(@.id == '{{ route01_id }}')].deliveries[?(@.id == '{{ delivery11_id }}')]" count == 1
jsonpath "$.routes[?(@.id == '{{ route02_id }}')]" count == 1
jsonpath "$.routes[?(@.id == '{{ route02_id }}')].deliveries" nth 0 count == 4
jsonpath "$.routes[?(@.id == '{{ route02_id }}')].deliveries[?(@.id == '{{ delivery01_id }}')]" count == 1
jsonpath "$.routes[?(@.id == '{{ route02_id }}')].deliveries[?(@.id == '{{ delivery03_id }}')]" count == 1
jsonpath "$.routes[?(@.id == '{{ route02_id }}')].deliveries[?(@.id == '{{ delivery04_id }}')]" count == 1
jsonpath "$.routes[?(@.id == '{{ route02_id }}')].deliveries[?(@.id == '{{ delivery06_id }}')]" count == 1


#   -----------------------------------

#   --------
#   Delete Vehicles #1
#   And Fleet #1
#   And Milestone #1
#   And Deliveries from #1 to #12
#   And Delivery Lot #1

DELETE {{ host }}/vehicles/{{ vehicle01_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/fleets/{{ fleet01_id }}
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

DELETE {{ host }}/deliveries/{{ delivery03_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/deliveries/{{ delivery04_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/deliveries/{{ delivery05_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/deliveries/{{ delivery06_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/deliveries/{{ delivery07_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/deliveries/{{ delivery08_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/deliveries/{{ delivery09_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/deliveries/{{ delivery10_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/deliveries/{{ delivery11_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/deliveries/{{ delivery12_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200

DELETE {{ host }}/lots/{{ lot01_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200
