# Code Runner Production Plan

## 1. Local runner scope

The Local runner is for demo and internal development only. It runs user code as child processes on the API server, so it must not be exposed to untrusted public traffic.

Local demo config:

```json
"CodeRunner": {
  "Provider": "Local",
  "DefaultTimeLimitMs": 5000,
  "MaxOutputBytes": 262144
}
```

## 2. Recommended production path: Judge0

Judge0 is the recommended production provider for DevLearningHub because it moves execution outside the API server and gives a standard HTTP judge interface.

Set:

```json
"CodeRunner": {
  "Provider": "Judge0",
  "Judge0": {
    "BaseUrl": "http://localhost:2358",
    "TimeoutSeconds": 20
  }
}
```

If Judge0 is unavailable, the API returns a clear error and the operator can switch `CodeRunner:Provider` back to `Local` for demo rollback.

The current provider includes a basic Judge0 HTTP flow: language-id mapping, submit, poll, and mapping stdout/stderr/compile output/status back to the existing code-run response contract.

## 3. Advanced path: Kubernetes sandbox

Kubernetes jobs or isolated worker pods can be added later for stricter per-submission isolation, queue-based execution, and language-specific images.

## 4. Risks of direct API-server execution

- User code can consume CPU and memory.
- User code can attempt filesystem access.
- User code can attempt network access.
- Compiler/runtime processes can leave child processes if not killed correctly.
- Runtime dependencies on the API host make production drift harder to manage.
- A vulnerability in a compiler/runtime can affect the API host.

## 5. Production checklist

- Isolate container.
- Set memory limit.
- Set CPU limit.
- Disable network by default.
- Use readonly filesystem.
- Enforce timeout.
- Enforce output limit.
- Run through queue worker.
- Write audit log for submissions and verdicts.
