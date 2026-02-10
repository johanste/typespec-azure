import { createTestLibrary, findTestPackageRoot } from "@typespec/compiler/testing";

export const AzureRestTestLibrary = createTestLibrary({
  name: "@azure-tools/typespec-azure-rest",
  packageRoot: await findTestPackageRoot(import.meta.url),
});
