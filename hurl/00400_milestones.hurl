# Feature: CRUD operations for Milestones API
#
#   ----------
#   Background:
#     Given the API is available in a given host
#     And the user is authenticated


#   --------
#   Scenario: List all milestones (first time)
#     When a GET request is send to "/milestones"
#     Then the response status should be 200
#     And the response should be a list equal of greater than zero

GET {{ host }}/milestones
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: milestonesCRUD
x-fake-step: milestonesGetList0
Prefer: example=empty
HTTP 200
[Captures]
list_count: jsonpath "$" count
[Asserts]
header "sl-violations" not exists
variable "list_count" >= 0


#   --------
#   Scenario: Create a new Milestone
#     When a POST request is send to "/milestones" with the following data:
#       | field    | value               |
#       | name     | "Main Depot"        |
#       | location | "37.7749,-122.4194" |
#       | category | "DEPOT"             |
#     Then the response status should be 200
#     And the response should contain an object that contains:
#       | field    | value               |
#       | id       | <milestone_id>      |
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
milestone_id: jsonpath "$.id"
[Asserts]
header "sl-violations" not exists
header "location" exists
jsonpath "$.id" isString
jsonpath "$.name" == "Main Depot"
jsonpath "$.location" == "37.7749,-122.4194"
jsonpath "$.category" == "DEPOT"


#   --------
#   Scenario: List all milestones (second time)
#     When a GET request is send to "/milestones"
#     Then the response status should be 200
#     And the response should have one more item
#     And the response should contain an object that contains:
#       | field    | value               |
#       | id       | <milestone_id>      |
#       | name     | "Main Depot"        |
#       | location | "37.7749,-122.4194" |
#       | category | "DEPOT"             |

GET {{ host }}/milestones
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: milestonesCRUD
x-fake-step: milestonesGetList1
Prefer: example=list-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count > {{ list_count }}
jsonpath "$[?(@.id == '{{ milestone_id }}')]" count == 1
jsonpath "$[?(@.id == '{{ milestone_id }}')].name" nth 0 == "Main Depot"
jsonpath "$[?(@.id == '{{ milestone_id }}')].location" nth 0 == "37.7749,-122.4194"
jsonpath "$[?(@.id == '{{ milestone_id }}')].category" nth 0 == "DEPOT"


#   --------
#   Scenario: View recently created milestone
#     Given a milestone has been created
#     And the milestone's ID is stored as <milestone_id>
#     When a GET request is sent to "/milestones/<milestone_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field    | value               |
#       | id       | <milestone_id>      |
#       | name     | "Main Depot"        |
#       | location | "37.7749,-122.4194" |
#       | category | "DEPOT"             |

GET {{ host }}/milestones/{{ milestone_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: milestonesCRUD
x-fake-step: milestonesGetMilestone0
Prefer: example=milestone-1.0
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == "{{ milestone_id }}"
jsonpath "$.name" == "Main Depot"
jsonpath "$.location" == "37.7749,-122.4194"
jsonpath "$.category" == "DEPOT"


#   --------
#   Scenario: Update an existing milestone
#     Given a milestone exist
#     And the milestone's ID is stored as <milestone_id>
#     When a PATCH request is sent to "/milestones/<milestone_id>" with the following data:
#       | field    | value                     |
#       | name     | "Main Distribution Point" |
#       | category | "DISTRIBUTION_CENTER"     |
#     Then the response status should be 200
#     And the response should contain:
#       | field    | value                     |
#       | id       | <milestone_id>            |
#       | name     | "Main Distribution Point" |
#       | location | "37.7749,-122.4194"       |
#       | category | "DISTRIBUTION_CENTER"     |

PATCH {{ host }}/milestones/{{ milestone_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: milestonesCRUD
x-fake-step: milestonesUpdateMilestone0
Prefer: example=milestone-1.1
{
  "name": "Main Distribution Point",
  "category": "DISTRIBUTION_CENTER"
}
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == "{{ milestone_id }}"
jsonpath "$.name" == "Main Distribution Point"
jsonpath "$.location" == "37.7749,-122.4194"
jsonpath "$.category" == "DISTRIBUTION_CENTER"


#   --------
#   Scenario: List all milestones (third time)
#     When a GET request is send to "/milestones"
#     Then the response status should be 200
#     And the response should contain an object that contains:
#       | field    | value                     |
#       | id       | <milestone_id>            |
#       | name     | "Main Distribution Point" |
#       | location | "37.7749,-122.4194"       |
#       | category | "DISTRIBUTION_CENTER"     |

GET {{ host }}/milestones
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: milestonesCRUD
x-fake-step: milestonesGetList2
Prefer: example=list-1.1
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count > {{ list_count }}
jsonpath "$[?(@.id == '{{ milestone_id }}')]" count == 1
jsonpath "$[?(@.id == '{{ milestone_id }}')].name" nth 0 == "Main Distribution Point"
jsonpath "$[?(@.id == '{{ milestone_id }}')].location" nth 0 == "37.7749,-122.4194"
jsonpath "$[?(@.id == '{{ milestone_id }}')].category" nth 0 == "DISTRIBUTION_CENTER"


#   --------
#   Scenario: View recently updated milestone
#     Given a milestone has been updated
#     And the milestone's ID is stored as <milestone_id>
#     When a GET request is sent to "/milestones/<milestone_id>"
#     Then the response status should be 200
#     And the response should contain:
#       | field    | value                     |
#       | id       | <milestone_id>            |
#       | name     | "Main Distribution Point" |
#       | location | "37.7749,-122.4194"       |
#       | category | "DISTRIBUTION_CENTER"     |

GET {{ host }}/milestones/{{ milestone_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: milestonesCRUD
x-fake-step: milestonesGetMilestone1
Prefer: example=milestone-1.1
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$.id" == "{{ milestone_id }}"
jsonpath "$.name" == "Main Distribution Point"
jsonpath "$.location" == "37.7749,-122.4194"
jsonpath "$.category" == "DISTRIBUTION_CENTER"


#   --------
#   Scenario: Delete a Milestone
#     Given a milestone exist
#     And the milestone's ID is stored as <milestone_id>
#     When a DELETE request is sent to "/milestones/<milestone_id>"
#     Then the response status should be 200

DELETE {{ host }}/milestones/{{ milestone_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: milestonesCRUD
x-fake-step: milestonesDeleteMilestone0
HTTP 200


#   --------
#   Scenario: List all milestones (fourth time)
#     Given a milestone has been deleted
#     And the milestone's ID was stored as <milestone_id>
#     When a GET request is send to "/milestones"
#     Then the response status should be 200
#     And the response should have one less item
#     And the milestone with ID <milestone_id> does not appear in the response

GET {{ host }}/milestones
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: milestonesCRUD
x-fake-step: milestonesGetList0
Prefer: example=empty
HTTP 200
[Asserts]
header "sl-violations" not exists
jsonpath "$" count == {{ list_count }}
jsonpath "$[?(@.id == '{{ milestone_id }}')]" count == 0


#   --------
#   Scenario: View recently deleted milestone
#     Given a milestone has been deleted
#     And the milestone's ID was stored as <milestone_id>
#     When a GET request is sent to "/milestones/<milestone_id>"
#     Then the response status should be 404

GET {{ host }}/milestones/{{ milestone_id }}
authorization: Bearer {{ auth }}
Accept: application/json
x-fake-api: milestonesCRUD
x-fake-step: milestonesGetMilestone2
Prefer: code=404
HTTP 404
