RouteHub REST API Testing
=========================

This repository provides HTTP tests designed for end-to-end (E2E) testing of the RouteHub REST API, ensuring complete API flow coverage.  The tests are based on the specifications outlined in the [RouteHub's OpenAPI Description](https://github.com/tandiljuan/routehub-openapi).

Hurl
----

The `hurl` directory contains a test suite designed for use with [Hurl](https://github.com/Orange-OpenSource/hurl). These tests are structured as individual files that can be executed to validate the functionality of a RouteHub REST API service.

The following command demonstrates how to run the entire test suite sequentially against a mock service defined in the `env.mock` file:

```bash
hurl --jobs 1 --test --variables-file env.mock *.hurl
```
