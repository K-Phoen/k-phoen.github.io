* log everything
  * not just errors, also user actions and "happy paths"
* categorize logs (debug, notice, info, warn, …)
* human readable, machine understandable
  * Order {orderRef} failed with error {errorMessage} -- {"orderRef": "ORDER-42", "errorMessage": "Some error", "errorBacktrace": "[…]"}
  * easy to aggregate by event
  * easy to find specific details
* avoid multi-line logs
* timestamp everything
  * should ba in the at the beginning of the line.
  * standard format (ISO 8601 is fine), with timezone
* include contextual data: customer ID? Server name?
* correlate logs: generate a request ID (the earlier, the better) and include it
  in each log line
* log locally, to a file or a local syslog server
* rotate and compress logs
* avoid logging sensitive data (password, secrets, …)
* identify subsystems in the logs by adding a "tag" in the beginning:
    ```
    [2017-02-05 11:25:50] **security.**DEBUG: Stored the security token in the session. {"key":"_security_main"} []
    ```
