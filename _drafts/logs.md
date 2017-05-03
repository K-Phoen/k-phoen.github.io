---
layout: post
title: Logging best practices for exploitable logs
description: >
    TODO
---

« **What to log?** » — That's the question I often ask myself when I launch new
projects or work on existing applications.

And by « what », I mean which events should be logged? Using which format? Where
should they be sent?

To answer these questions, we need to ask ourselves why do we need logs in the
first place?

## Determine your logging strategy

Logging everything would be counter-productive as we would end up with too much
data to search and the important information would probably be hidden in
non-essential logs.

Therefore, the first step is to determine what your logs will be used for.

Common logging strategies include:

* **performance and resources**: memory consumption, CPU/IO/network usage,
  external API calls and their response times, …
  Helps to monitor, debug and improve the general performance of the system.
* **errors**: exceptions, warnings, unexpected responses, …
  Helps detecting and troubleshooting issues with the system or its environment.
* **user actions**: actions performed by your users.
  Useful to help users when they come across an issue.
* **business metrics**: business-related events.
  Can be used as a _poor man's BI tool_.

That's why the logging strategy employed in these applications is
"user actions"-oriented.

## Log, log, log

Now that your logging strategy is identified, be sure that all the relevant
events are logged.

Most of the time, I need logs to help me debug a running system. Be it an API
that returns unexpected or incorrect responses or an e-commerce platform failing
randomly during the checkout process.

In this case, **error logs are not enough** to know what your users were doing
before the system failed.



* log everything
  * not just errors, also user actions and "happy paths"
* categorize logs (debug, notice, info, warn, …)
* human readable, machine understandable
  * Order {orderRef} failed with error {errorMessage} -- {"orderRef": "ORDER-42", "errorMessage": "Some error", "errorBacktrace": "[…]"}
  * easy to aggregate by event
  * easy to find specific details
* avoid multi-line logs
* timestamp everything
  * should be at the beginning of the line.
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
