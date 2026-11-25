import { pbkdf2Sync, randomBytes } from "node:crypto";
import { stdin, stdout } from "node:process";

if (!stdin.isTTY || !stdout.isTTY) {
  process.stderr.write("Run this script in an interactive terminal.\n");
  process.exit(1);
}

stdout.write("New admin password: ");
stdin.setRawMode(true);
stdin.resume();
let password = "";
const onData = chunk => {
  const key = chunk.toString("utf8");
  if (key === "\u0003") process.exit(130);
  if (key === "\r" || key === "\n") {
    stdin.setRawMode(false);
    stdin.pause();
    stdin.removeListener("data", onData);
    stdout.write("\n");
    if (password.length < 12 || password.length > 256) {
      process.stderr.write("Use a password between 12 and 256 characters.\n");
      process.exit(1);
    }
    const salt = randomBytes(16);
    const hash = pbkdf2Sync(password, salt, 310000, 32, "sha256");
    const b64 = value => value.toString("base64url");
    password = "";
    stdout.write("ADMIN_PASSWORD_HASH=pbkdf2$310000$" + b64(salt) + "$" + b64(hash) + "\n");
    return;
  }
  if (key === "\u007f" || key === "\b") password = password.slice(0, -1);
  else if (key.length === 1 && key >= " ") password += key;
};
stdin.on("data", onData);
