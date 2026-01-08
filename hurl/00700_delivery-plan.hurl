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
#     And the milestone #1 is created with the following data:
#       | field    | value               |
#       | name     | "Main Depot"        |
#       | location | "37.7749,-122.4194" |
#     And a bulk of deliveries is created with the following data:
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
#     And the lot #1 is created with the following data:
#       | field        | value                   |
#       | milestone_id | "{{ milestone01_id }}"  |
#       | deliveries   | ["{{ delivery01_id }}"] |
#       | fleet_id     | "{{ fleet01_id }}"      |

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

POST {{ host }}/lots
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsCreate0
Prefer: example=delivery-lot-1.0
{
  "milestone_id": "{{ milestone01_id }}",
  "deliveries": ["{{ delivery01_id }}"],
  "fleet_id": "{{ fleet01_id }}"
}
HTTP 201
[Captures]
lot01_id: jsonpath "$.id"


#   --------
#   Scenario: Generate/Update delivery plan for existing delivery lot
#     Given a delivery-lots exists
#     And the delivery-lots's ID is stored as <delivery_lot_id>
#     When a POST request is sent to "/lots/<delivery_lot_id>/plan"
#     Then the response status should be 200

POST {{ host }}/lots/{{ lot01_id }}/plan
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: deliveryLotsCRUD
x-fake-step: deliveryLotsUpdatePlan0
HTTP 202

##   --------
##   Scenario: Get delivery plan for existing delivery lot
##     Given a delivery-lots exists
##     And the delivery-lots's ID is stored as <delivery_lot_id>
##     When a GET request is sent to "/lots/<delivery_lot_id>/plan"
##     Then the response status should be 200
##     And the response should contain the delivery plan
#
#GET {{ host }}/lots/{{ lot01_id }}/plan
#authorization: Bearer {{ auth }}
#Accept: application/json
#x-fake-api: deliveryLotsCRUD
#x-fake-step: deliveryLotsGetPlan0
#Prefer: example=delivery-plan-1.0
#HTTP 200
#[Asserts]
#header "sl-violations" not exists
#jsonpath "$.delivery_lot_id" == {{ lot01_id }}
#jsonpath "$.delivery_paths" count == 1
#jsonpath "$.delivery_paths[0].milestone_id" == 1
#jsonpath "$.delivery_paths[0].vehicle_id" == 1
#jsonpath "$.delivery_paths[0].driver_id" == 1
#jsonpath "$.delivery_paths[0].delivery_units" count == 2
#jsonpath "$.delivery_paths[0].delivery_units[0]" == 1
#jsonpath "$.delivery_paths[0].delivery_units[1]" == 2


##   --------
##   Delete Vehicles #1
##   And Fleet #1
##   And Milestone #1
##   And Delivery #1
##   And Delivery #2
##   And Delivery #3
##   And Delivery Lot #1
#
#DELETE {{ host }}/vehicles/{{ vehicle01_id }}
#authorization: Bearer {{ auth }}
#Accept: application/json
#HTTP 200
#
#DELETE {{ host }}/fleets/{{ fleet01_id }}
#authorization: Bearer {{ auth }}
#Accept: application/json
#HTTP 200
#
#DELETE {{ host }}/milestones/{{ milestone01_id }}
#authorization: Bearer {{ auth }}
#Accept: application/json
#HTTP 200
#
#DELETE {{ host }}/deliveries/{{ delivery01_id }}
#authorization: Bearer {{ auth }}
#Accept: application/json
#HTTP 200
#
#DELETE {{ host }}/deliveries/{{ delivery02_id }}
#authorization: Bearer {{ auth }}
#Accept: application/json
#HTTP 200
#
#DELETE {{ host }}/deliveries/{{ delivery03_id }}
#authorization: Bearer {{ auth }}
#Accept: application/json
#HTTP 200
#
#DELETE {{ host }}/lots/{{ lot01_id }}
#authorization: Bearer {{ auth }}
#Accept: application/json
#HTTP 200
