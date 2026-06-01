import "@typespec/http";
import "@typespec/rest";

using TypeSpec.Http;
using TypeSpec.Rest;

namespace Azure.Rest;

/**
 * Standard error object for REST API responses.
 */
@error
model Error {
  /** One of a server-defined set of error codes. */
  code: string;

  /** A human-readable representation of the error. */
  message: string;
}

/**
 * Standard error response for REST API operations.
 */
@error
model ErrorResponse {
  /** The error object. */
  @body error: Error;
}

/**
 * Wraps the resource instance as a request body.
 * @template Resource The type of the resource.
 */
model ResourceBody<Resource> {
  @body resource: Resource;
}

/**
 * A page of resources returned from a list operation.
 * @template Resource The type of the resource.
 */
@friendlyName("Paged{name}", Resource)
model Page<Resource extends TypeSpec.Reflection.Model> {
  /** The items on this page. */
  @pageItems
  value: Resource[];

  /** The link to the next page of items. */
  @nextLink
  nextLink?: ResourceLocation<Resource>;
}

/**
 * The base operation shape for REST operations. All operations include
 * the resource key parameters and return an error response on failure.
 * @template Parameters Object describing the request parameters.
 * @template Response Object describing the response.
 */
op Operation<Parameters extends TypeSpec.Reflection.Model, Response>(
  ...Parameters,
): Response | ErrorResponse;

/**
 * An operation on a single resource, identified by its key parameters.
 * @template Resource The type of the resource.
 * @template Parameters Additional request parameters.
 * @template Response The response type.
 */
@autoRoute
op ResourceOperation<
  Resource extends TypeSpec.Reflection.Model,
  Parameters extends TypeSpec.Reflection.Model,
  Response,
> is Operation<ItemKeysOf<Resource> & Parameters, Response>;

/**
 * An operation on a collection of resources.
 * @template Resource The type of the resource.
 * @template Parameters Additional request parameters.
 * @template Response The response type.
 */
@autoRoute
op ResourceCollectionOperation<
  Resource extends TypeSpec.Reflection.Model,
  Parameters extends TypeSpec.Reflection.Model,
  Response extends TypeSpec.Reflection.Model,
> is Operation<CollectionKeysOf<Resource> & Parameters, Response>;

/**
 * The key parameters for a specific resource instance.
 * @template Resource The type of the resource.
 */
@copyResourceKeyParameters
model ItemKeysOf<Resource> {}

/**
 * The key parameters for the parent of a resource (used for collection operations).
 * @template Resource The type of the resource.
 */
@copyResourceKeyParameters("parent")
model CollectionKeysOf<Resource> {}

// ---------- Standard Resource Operations ----------

/**
 * Read a resource by its identifier.
 *
 * Uses GET and returns the resource representation.
 * @template Resource The type of the resource.
 */
@readsResource(Resource)
op ResourceRead<Resource extends TypeSpec.Reflection.Model> is ResourceOperation<
  Resource,
  {},
  Resource
>;

/**
 * Create or replace a resource using PUT semantics.
 *
 * Returns 200 if the resource was replaced, or 201 if it was created.
 * @template Resource The type of the resource.
 */
@createsOrReplacesResource(Resource)
op ResourceCreateOrReplace<Resource extends TypeSpec.Reflection.Model> is ResourceOperation<
  Resource,
  ResourceBody<Resource>,
  (Response<200> & Resource) | (Response<201> & Resource)
>;

/**
 * Create or update a resource using PATCH with JSON Merge Patch semantics.
 *
 * Returns 200 if the resource was updated, or 201 if it was created.
 * @template Resource The type of the resource.
 */
@createsOrUpdatesResource(Resource)
@parameterVisibility(Lifecycle.Create, Lifecycle.Update)
@patch(#{ implicitOptionality: true })
op ResourceCreateOrUpdate<Resource extends TypeSpec.Reflection.Model> is ResourceOperation<
  Resource,
  {
    @header("Content-Type") contentType: "application/merge-patch+json";
    ...ResourceBody<Resource>;
  },
  (Response<200> & Resource) | (Response<201> & Resource)
>;

/**
 * Delete a resource by its identifier.
 *
 * Returns 204 No Content on success.
 * @template Resource The type of the resource.
 */
@deletesResource(Resource)
op ResourceDelete<Resource extends TypeSpec.Reflection.Model> is ResourceOperation<
  Resource,
  {},
  NoContentResponse
>;

/**
 * List resources in a collection with pagination.
 *
 * Uses GET and returns a page of resources.
 * @template Resource The type of the resource.
 */
@listsResource(Resource)
@list
op ResourceList<Resource extends TypeSpec.Reflection.Model> is ResourceCollectionOperation<
  Resource,
  {},
  Page<Resource>
>;
