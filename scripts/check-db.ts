import "dotenv/config";
import { db } from "../lib/db";

async function main() {
  const status = await db.healthCheck();
  if (!status) throw new Error("Database tidak mengembalikan status koneksi.");

  console.log("Koneksi database berhasil.");
  console.log(`Database : ${String(status.databaseName ?? "-")}`);
  console.log(`Server   : ${String(status.version ?? "-")}`);
}

main()
  .catch((error) => {
    console.error("Koneksi database gagal.");
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await db.close();
  });
