# Code Runner Languages

The demo runner executes code on the local machine in a per-run temp directory under the OS temp path. Production should move execution to Docker, Judge0, or a dedicated sandbox.

| Code | Display name | Extension | Compile | Run | Required runtime | Active |
| --- | --- | --- | --- | --- | --- | --- |
| `python` | Python | `.py` | - | `python main.py` (`py main.py` fallback on Windows) | Python 3 | Yes |
| `javascript` | JavaScript | `.js` | - | `node main.js` | Node.js | Yes |
| `typescript` | TypeScript | `.ts` | `npx tsc main.ts --target ES2020 --module commonjs --outDir out` | `node out/main.js` | Node.js and TypeScript compiler | Yes |
| `java` | Java | `.java` | `javac Main.java` | `java Main` | JDK | Yes |
| `c` | C | `.c` | `gcc main.c -O2 -o main.exe` | `main.exe` | GCC | Yes |
| `cpp` | C++17 | `.cpp` | `g++ main.cpp -std=c++17 -O2 -o main.exe` | `main.exe` | G++ | Yes |
| `csharp` | C# | `.cs` | `dotnet build Main.csproj --nologo -v quiet` | `dotnet bin/Debug/net9.0/Main.dll` | .NET SDK | Yes |
| `go` | Go | `.go` | - | `go run main.go` | Go | Yes |

If a runtime is missing, the API returns `CompilationError` or `RuntimeError` with a readable message instead of crashing.

## Hello World Templates

Use `GET /api/v1/code/languages` for the current templates and runtime metadata. The frontend playground consumes `defaultTemplate`, `fileExtension`, `compileCommand`, and `runCommand` from that API.

## Local Runtime Fixes

- Python: install Python 3 and make sure `python` or `py` is on `PATH`.
- JavaScript/TypeScript: install Node.js. Install TypeScript globally or make `npx tsc` available.
- Java: install a JDK and make sure `javac` and `java` are on `PATH`.
- C/C++: install GCC/G++ such as MinGW on Windows.
- C#: install the .NET SDK matching the backend target (`net9.0` in this repo).
- Go: install Go and make sure `go` is on `PATH`.
