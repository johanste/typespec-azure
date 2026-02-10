# @azure-tools/typespec-azure-rest

TypeSpec REST library providing simple, resource-oriented operation templates based on REST principles.

## Overview

This library provides straightforward operation templates for building RESTful APIs. It focuses on the core principles of REST:

- **Resources** are the primary abstraction
- **Uniform interface** via standard HTTP methods (GET, PUT, PATCH, DELETE)
- **Representations** sent and received as request/response bodies
- **Pagination** for collection resources

## Operations

| Operation                  | HTTP Method | Description                                  |
| -------------------------- | ----------- | -------------------------------------------- |
| `ResourceRead`             | GET         | Read a resource by its identifier            |
| `ResourceCreateOrReplace`  | PUT         | Create or replace a resource                 |
| `ResourceCreateOrUpdate`   | PATCH       | Create or update with JSON Merge Patch       |
| `ResourceDelete`           | DELETE      | Delete a resource                            |
| `ResourceList`             | GET         | List resources in a collection (paginated)   |

## Usage

```typespec
import "@azure-tools/typespec-azure-rest";

using Azure.Rest;

@resource("widgets")
model Widget {
  @key name: string;
  color: string;
  weight: float32;
}

interface Widgets {
  read is ResourceRead<Widget>;
  create is ResourceCreateOrReplace<Widget>;
  update is ResourceCreateOrUpdate<Widget>;
  delete is ResourceDelete<Widget>;
  list is ResourceList<Widget>;
}
```
