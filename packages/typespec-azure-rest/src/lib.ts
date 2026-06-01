import { createTypeSpecLibrary } from "@typespec/compiler";

export const $lib = createTypeSpecLibrary({
  name: "@azure-tools/typespec-azure-rest",
  diagnostics: {},
  state: {},
} as const);

export const { reportDiagnostic, createDiagnostic } = $lib;
