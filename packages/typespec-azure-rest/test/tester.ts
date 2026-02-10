import { resolvePath } from "@typespec/compiler";
import { createTester } from "@typespec/compiler/testing";

export const Tester = createTester(resolvePath(import.meta.dirname, ".."), {
  libraries: ["@azure-tools/typespec-azure-rest", "@typespec/rest", "@typespec/http"],
})
  .importLibraries()
  .using("Azure.Rest", "Rest");
