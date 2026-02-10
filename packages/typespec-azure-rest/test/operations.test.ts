import { type TesterInstance } from "@typespec/compiler/testing";
import { beforeEach, describe, it } from "vitest";
import { Tester } from "./tester.js";

let runner: TesterInstance;

beforeEach(async () => {
  runner = await Tester.createInstance();
});

describe("Azure.Rest operations", () => {
  it("compiles a simple resource with ResourceRead", async () => {
    const diagnostics = await runner.diagnose(`
      @resource("widgets")
      model Widget {
        @key name: string;
        color: string;
      }

      interface Widgets {
        read is ResourceRead<Widget>;
      }
    `);
    diagnostics.forEach((d) => {
      if (d.severity === "error") throw new Error(d.message);
    });
  });

  it("compiles ResourceCreateOrReplace", async () => {
    const diagnostics = await runner.diagnose(`
      @resource("widgets")
      model Widget {
        @key name: string;
        color: string;
      }

      interface Widgets {
        create is ResourceCreateOrReplace<Widget>;
      }
    `);
    diagnostics.forEach((d) => {
      if (d.severity === "error") throw new Error(d.message);
    });
  });

  it("compiles ResourceCreateOrUpdate", async () => {
    const diagnostics = await runner.diagnose(`
      @resource("widgets")
      model Widget {
        @key name: string;
        color: string;
      }

      interface Widgets {
        update is ResourceCreateOrUpdate<Widget>;
      }
    `);
    diagnostics.forEach((d) => {
      if (d.severity === "error") throw new Error(d.message);
    });
  });

  it("compiles ResourceDelete", async () => {
    const diagnostics = await runner.diagnose(`
      @resource("widgets")
      model Widget {
        @key name: string;
        color: string;
      }

      interface Widgets {
        remove is ResourceDelete<Widget>;
      }
    `);
    diagnostics.forEach((d) => {
      if (d.severity === "error") throw new Error(d.message);
    });
  });

  it("compiles ResourceList", async () => {
    const diagnostics = await runner.diagnose(`
      @resource("widgets")
      model Widget {
        @key name: string;
        color: string;
      }

      interface Widgets {
        list is ResourceList<Widget>;
      }
    `);
    diagnostics.forEach((d) => {
      if (d.severity === "error") throw new Error(d.message);
    });
  });

  it("compiles all operations together", async () => {
    const diagnostics = await runner.diagnose(`
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
        remove is ResourceDelete<Widget>;
        list is ResourceList<Widget>;
      }
    `);
    diagnostics.forEach((d) => {
      if (d.severity === "error") throw new Error(d.message);
    });
  });

  it("compiles nested resources", async () => {
    const diagnostics = await runner.diagnose(`
      @resource("stores")
      model Store {
        @key name: string;
        location: string;
      }

      @resource("products")
      @parentResource(Store)
      model Product {
        @key id: string;
        title: string;
        price: float32;
      }

      interface Products {
        read is ResourceRead<Product>;
        create is ResourceCreateOrReplace<Product>;
        list is ResourceList<Product>;
      }
    `);
    diagnostics.forEach((d) => {
      if (d.severity === "error") throw new Error(d.message);
    });
  });
});
