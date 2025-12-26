# Feature: CRUD operations for Drivers API
#
#   ----------
#   Background:
#     Given the API is available in a given host
#     And the user is authenticated
#     And the vehicle #1 is created with the following data:
#       | field            | value              |
#       | name             | "truck"            |
#       | category_type    | "TRUCK"            |
#       | engine_type      | "DIESEL"           |
#     And the vehicle #2 is created with the following data:
#       | field            | value              |
#       | name             | "van"              |
#       | category_type    | "VAN"              |
#       | engine_type      | "DIESEL"           |

POST {{ host }}/vehicles
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: vehiclesCRUD
x-fake-step: vehiclesCreate0
Prefer: example=vehicle-2.0
{
  "name": "truck",
  "category_type": "TRUCK",
  "engine_type": "DIESEL"
}
HTTP 201
[Captures]
vehicle01_id: jsonpath "$.id"


#   --------
#   Scenario: List all drivers (first time)
#     When a GET request is send to "/drivers"
#     Then the response status should be 200
#     And the response should be a list equal of greater than zero

GET {{ host }}/drivers
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: driversCRUD
x-fake-step: driversGetList0
Prefer: example=empty
HTTP 200
[Captures]
list_count: jsonpath "$" count
[Asserts]
header "sl-violations" not exists
variable "list_count" >= 0


#   --------
#   Scenario: Create a new Driver
#     When a POST request is send to "/drivers" with the following data:
#       | field          | value                                                             |
#       | first_name     | "John"                                                            |
#       | last_name      | "Doe"                                                             |
#       | work_schedules | ["DTSTART:20250101T120000Z\nDURATION:PT8H\nRRULE:FREQ=DAILY"]     |
#       | start_point    | "37.7749,-122.4194"                                               |
#       | work_areas     | [["37.7749,-122.4194", "37.7749,-122.4195", "37.7750,-122.4194"]] |
#       | vehicles       | [{"id":"{{ vehicle01_id }}","qty":2}]                             |
#     Then the response status should be 200
#     And the response should contain an object that contains:
#       | field          | value                                                             |
#       | id             | <driver_id>                                                       |
#       | first_name     | "John"                                                            |
#       | last_name      | "Doe"                                                             |
#       | work_schedules | ["DTSTART:20250101T120000Z\nDURATION:PT8H\nRRULE:FREQ=DAILY"]     |
#       | start_point    | "37.7749,-122.4194"                                               |
#       | work_areas     | [["37.7749,-122.4194", "37.7749,-122.4195", "37.7750,-122.4194"]] |
#       | vehicles       | [{"id":"{{ vehicle01_id }}","qty":2}]                             |

POST {{ host }}/drivers
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: driversCRUD
x-fake-step: driversCreate0
Prefer: example=driver-1.0
{
  "first_name": "John",
  "last_name": "Doe",
  "work_schedules": ["DTSTART:20250101T120000Z\nDURATION:PT8H\nRRULE:FREQ=DAILY"],
  "start_point": "37.7749,-122.4194",
  "work_areas": [["37.7749,-122.4194", "37.7749,-122.4195", "37.7750,-122.4194"]],
  "vehicles": [{"id":"{{ vehicle01_id }}","qty":2}]
}
HTTP 201
[Captures]
driver_id: jsonpath "$.id"
[Asserts]
header "sl-violations" not exists
header "location" exists
jsonpath "$.id" isString
jsonpath "$.first_name" == "John"
jsonpath "$.last_name" == "Doe"
jsonpath "$.work_schedules" count == 1
jsonpath "$.work_schedules[0]" == "DTSTART:20250101T120000Z\nDURATION:PT8H\nRRULE:FREQ=DAILY"
jsonpath "$.start_point" == "37.7749,-122.4194"
jsonpath "$.work_areas" count == 1
jsonpath "$.work_areas[0]" count == 3
jsonpath "$.work_areas[0][0]" == "37.7749,-122.4194"
jsonpath "$.work_areas[0][1]" == "37.7749,-122.4195"
jsonpath "$.work_areas[0][2]" == "37.7750,-122.4194"
jsonpath "$.vehicles" count == 1
jsonpath "$.vehicles[0].id" == "{{ vehicle01_id }}"
jsonpath "$.vehicles[0].qty" == 2


#   --------
#   Scenario: List all drivers (second time)
#     When a GET request is send to "/drivers"
#     Then the response status should be 200
#     And the response should have one more item
#     And the response should contain an object that contains:
#       | field          | value                                                             |
#       | id             | <driver_id>                                                       |
#       | first_name     | "John"                                                            |
#       | last_name      | "Doe"                                                             |
#       | work_schedules | ["DTSTART:20250101T120000Z\nDURATION:PT8H\nRRULE:FREQ=DAILY"]     |
#       | start_point    | "37.7749,-122.4194"                                               |
#       | work_areas     | [["37.7749,-122.4194", "37.7749,-122.4195", "37.7750,-122.4194"]] |
#       | vehicles       | [{"id":"{{ vehicle01_id }}","qty":2}]                             |

GET {{ host }}/drivers
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: driversCRUD
x-fake-step: driversGetList1
Prefer: example=list-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count > {{ list_count }}
jsonpath "$[?(@.id == '{{ driver_id }}')]" count == 1
jsonpath "$[?(@.id == '{{ driver_id }}')].first_name" nth 0 == "John"
jsonpath "$[?(@.id == '{{ driver_id }}')].last_name" nth 0 == "Doe"
jsonpath "$[?(@.id == '{{ driver_id }}')].work_schedules"  nth 0 count == 1
jsonpath "$[?(@.id == '{{ driver_id }}')].work_schedules[0]" nth 0 == "DTSTART:20250101T120000Z\nDURATION:PT8H\nRRULE:FREQ=DAILY"
jsonpath "$[?(@.id == '{{ driver_id }}')].start_point" nth 0 == "37.7749,-122.4194"
jsonpath "$[?(@.id == '{{ driver_id }}')].work_areas" nth 0 count == 1
jsonpath "$[?(@.id == '{{ driver_id }}')].work_areas[0]" nth 0 count == 3
jsonpath "$[?(@.id == '{{ driver_id }}')].work_areas[0][0]" nth 0 == "37.7749,-122.4194"
jsonpath "$[?(@.id == '{{ driver_id }}')].work_areas[0][1]" nth 0 == "37.7749,-122.4195"
jsonpath "$[?(@.id == '{{ driver_id }}')].work_areas[0][2]" nth 0 == "37.7750,-122.4194"
jsonpath "$[?(@.id == '{{ driver_id }}')].vehicles" nth 0 count == 1
jsonpath "$[?(@.id == '{{ driver_id }}')].vehicles[0].id" nth 0 == "{{ vehicle01_id }}"
jsonpath "$[?(@.id == '{{ driver_id }}')].vehicles[0].qty" nth 0 == 2


#   --------
#   Scenario: View recently created driver
#     Given a driver has been created
#     And the driver's ID is stored as <driver_id>
#     When a GET request is sent to "/drivers/<driver_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field          | value                                                             |
#       | id             | <driver_id>                                                       |
#       | first_name     | "John"                                                            |
#       | last_name      | "Doe"                                                             |
#       | work_schedules | ["DTSTART:20250101T120000Z\nDURATION:PT8H\nRRULE:FREQ=DAILY"]     |
#       | start_point    | "37.7749,-122.4194"                                               |
#       | work_areas     | [["37.7749,-122.4194", "37.7749,-122.4195", "37.7750,-122.4194"]] |
#       | vehicles       | [{"id":"{{ vehicle01_id }}","qty":2}]                             |

GET {{ host }}/drivers/{{ driver_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: driversCRUD
x-fake-step: driversGetDriver0
Prefer: example=driver-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == "{{ driver_id }}"
jsonpath "$.first_name" == "John"
jsonpath "$.last_name" == "Doe"
jsonpath "$.work_schedules" count == 1
jsonpath "$.work_schedules[0]" == "DTSTART:20250101T120000Z\nDURATION:PT8H\nRRULE:FREQ=DAILY"
jsonpath "$.start_point" == "37.7749,-122.4194"
jsonpath "$.work_areas" count == 1
jsonpath "$.work_areas[0]" count == 3
jsonpath "$.work_areas[0][0]" == "37.7749,-122.4194"
jsonpath "$.work_areas[0][1]" == "37.7749,-122.4195"
jsonpath "$.work_areas[0][2]" == "37.7750,-122.4194"
jsonpath "$.vehicles" count == 1
jsonpath "$.vehicles[0].id" == "{{ vehicle01_id }}"
jsonpath "$.vehicles[0].qty" == 2


#   --------
#   Scenario: Update an existing driver
#     Given a driver exist
#     And the driver's ID is stored as <driver_id>
#     When a PATCH request is sent to "/drivers/<driver_id>" with the following data:
#       | field      | value   |
#       | first_name | "Jane"  |
#       | last_name  | "Smith" |
#     Then the response status should be 200
#     And the response should contain:
#       | field          | value                                                             |
#       | id             | <driver_id>                                                       |
#       | first_name     | "Jane"                                                            |
#       | last_name      | "Smith"                                                           |
#       | work_schedules | ["DTSTART:20250101T120000Z\nDURATION:PT8H\nRRULE:FREQ=DAILY"]     |
#       | start_point    | "37.7749,-122.4194"                                               |
#       | work_areas     | [["37.7749,-122.4194", "37.7749,-122.4195", "37.7750,-122.4194"]] |
#       | vehicles       | [{"id":"{{ vehicle01_id }}","qty":2}]                             |

PATCH {{ host }}/drivers/{{ driver_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: driversCRUD
x-fake-step: driversUpdateDriver0
Prefer: example=driver-1.1
{
  "first_name": "Jane",
  "last_name": "Smith"
}
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == "{{ driver_id }}"
jsonpath "$.first_name" == "Jane"
jsonpath "$.last_name" == "Smith"
jsonpath "$.work_schedules" count == 1
jsonpath "$.work_schedules[0]" == "DTSTART:20250101T120000Z\nDURATION:PT8H\nRRULE:FREQ=DAILY"
jsonpath "$.start_point" == "37.7749,-122.4194"
jsonpath "$.work_areas" count == 1
jsonpath "$.work_areas[0]" count == 3
jsonpath "$.work_areas[0][0]" == "37.7749,-122.4194"
jsonpath "$.work_areas[0][1]" == "37.7749,-122.4195"
jsonpath "$.work_areas[0][2]" == "37.7750,-122.4194"
jsonpath "$.vehicles" count == 1
jsonpath "$.vehicles[0].id" == "{{ vehicle01_id }}"
jsonpath "$.vehicles[0].qty" == 2


#   --------
#   Scenario: List all drivers (third time)
#     When a GET request is send to "/drivers"
#     Then the response status should be 200
#     And the response should contain an object that contains:
#       | field          | value                                                             |
#       | id             | <driver_id>                                                       |
#       | first_name     | "Jane"                                                            |
#       | last_name      | "Smith"                                                           |
#       | work_schedules | ["DTSTART:20250101T120000Z\nDURATION:PT8H\nRRULE:FREQ=DAILY"]     |
#       | start_point    | "37.7749,-122.4194"                                               |
#       | work_areas     | [["37.7749,-122.4194", "37.7749,-122.4195", "37.7750,-122.4194"]] |
#       | vehicles       | [{"id":"{{ vehicle01_id }}","qty":2}]                             |

GET {{ host }}/drivers
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: driversCRUD
x-fake-step: driversGetList2
Prefer: example=list-1.1
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count > {{ list_count }}
jsonpath "$[?(@.id == '{{ driver_id }}')]" count == 1
jsonpath "$[?(@.id == '{{ driver_id }}')].first_name" nth 0 == "Jane"
jsonpath "$[?(@.id == '{{ driver_id }}')].last_name" nth 0 == "Smith"
jsonpath "$[?(@.id == '{{ driver_id }}')].work_schedules" nth 0 count == 1
jsonpath "$[?(@.id == '{{ driver_id }}')].work_schedules[0]" nth 0 == "DTSTART:20250101T120000Z\nDURATION:PT8H\nRRULE:FREQ=DAILY"
jsonpath "$[?(@.id == '{{ driver_id }}')].start_point" nth 0 == "37.7749,-122.4194"
jsonpath "$[?(@.id == '{{ driver_id }}')].work_areas" nth 0 count == 1
jsonpath "$[?(@.id == '{{ driver_id }}')].work_areas[0]" nth 0 count == 3
jsonpath "$[?(@.id == '{{ driver_id }}')].work_areas[0][0]" nth 0 == "37.7749,-122.4194"
jsonpath "$[?(@.id == '{{ driver_id }}')].work_areas[0][1]" nth 0 == "37.7749,-122.4195"
jsonpath "$[?(@.id == '{{ driver_id }}')].work_areas[0][2]" nth 0 == "37.7750,-122.4194"
jsonpath "$[?(@.id == '{{ driver_id }}')].vehicles" nth 0 count == 1
jsonpath "$[?(@.id == '{{ driver_id }}')].vehicles[0].id" nth 0 == "{{ vehicle01_id }}"
jsonpath "$[?(@.id == '{{ driver_id }}')].vehicles[0].qty" nth 0 == 2


#   --------
#   Scenario: View recently updated driver
#     Given a driver has been updated
#     And the driver's ID is stored as <driver_id>
#     When a GET request is sent to "/drivers/<driver_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field          | value                                                             |
#       | id             | <driver_id>                                                       |
#       | first_name     | "Jane"                                                            |
#       | last_name      | "Smith"                                                           |
#       | work_schedules | ["DTSTART:20250101T120000Z\nDURATION:PT8H\nRRULE:FREQ=DAILY"]     |
#       | start_point    | "37.7749,-122.4194"                                               |
#       | work_areas     | [["37.7749,-122.4194", "37.7749,-122.4195", "37.7750,-122.4194"]] |
#       | vehicles       | [{"id":"{{ vehicle01_id }}","qty":2}]                             |

GET {{ host }}/drivers/{{ driver_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: driversCRUD
x-fake-step: driversGetDriver1
Prefer: example=driver-1.1
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == "{{ driver_id }}"
jsonpath "$.first_name" == "Jane"
jsonpath "$.last_name" == "Smith"
jsonpath "$.work_schedules" count == 1
jsonpath "$.work_schedules[0]" == "DTSTART:20250101T120000Z\nDURATION:PT8H\nRRULE:FREQ=DAILY"
jsonpath "$.start_point" == "37.7749,-122.4194"
jsonpath "$.work_areas" count == 1
jsonpath "$.work_areas[0]" count == 3
jsonpath "$.work_areas[0][0]" == "37.7749,-122.4194"
jsonpath "$.work_areas[0][1]" == "37.7749,-122.4195"
jsonpath "$.work_areas[0][2]" == "37.7750,-122.4194"
jsonpath "$.vehicles" count == 1
jsonpath "$.vehicles[0].id" == "{{ vehicle01_id }}"
jsonpath "$.vehicles[0].qty" == 2


#   --------
#   Scenario: Delete a Driver
#     Given a driver exist
#     And the driver's ID is stored as <driver_id>
#     When a DELETE request is sent to "/drivers/<driver_id>"
#     Then the response status should be 200

DELETE {{ host }}/drivers/{{ driver_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: driversCRUD
x-fake-step: driversDeleteDriver0
HTTP 200


#   --------
#   Scenario: List all drivers (fourth time)
#     Given a driver has been deleted
#     And the driver's ID was stored as <driver_id>
#     When a GET request is send to "/drivers"
#     Then the response status should be 200
#     And the response should have one less item
#     And the driver with ID <driver_id> does not appear in the response

GET {{ host }}/drivers
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: driversCRUD
x-fake-step: driversGetList0
Prefer: example=empty
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count == {{ list_count }}
jsonpath "$[?(@.id == '{{ driver_id }}')]" count == 0


#   --------
#   Scenario: View recently deleted driver
#     Given a driver has been deleted
#     And the driver's ID was stored as <driver_id>
#     When a GET request is sent to "/drivers/<driver_id>"
#     Then the response status should be 404

GET {{ host }}/drivers/{{ driver_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: driversCRUD
x-fake-step: driversGetDriver2
Prefer: code=404
HTTP 404


#   --------
#   Delete Vehicles #1 and #2

DELETE {{ host }}/vehicles/{{ vehicle01_id }}
authorization: Bearer {{ auth }}
Accept: application/json
HTTP 200
