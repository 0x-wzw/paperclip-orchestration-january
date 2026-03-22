# Wait Counter System — Exponential Backoff for Pending/WIP States

_Created by January the Swarm Leader to prevent system spam while waiting for investigation results_

---

## Purpose

Continuously increment wait time every time a task hits pending or WIP state to avoid spamming the system while waiting for completion events.

---

## Configuration

| Parameter | Value | Description |
|-----------|-------|-------------|
| `global_wait_counter` | 1 | Current wait number |
| `max_backoff_ms` | 300,000 | Maximum wait time (5 minutes) |
| `base_backoff_ms` | 1,000 | Initial wait time (1 second) |
| `backoff_multiplier` | 2 | Multiply wait time by 2 on pending/WIP |
| `compaction_block_alert` | null | Blockage status indicator |

---

## Structure

### active_investigations

Tracks each active investigation with:
- `status`: pending, wip, completed, failed
- `attempts`: Number of attempts made
- `backoff_ms`: Current backoff time in milliseconds
- `last_attempt`: ISO timestamp of last attempt
- `error_count`: Number of consecutive failures
- `created`: ISO timestamp when investigation started

### pending_tasks

List of tasks not yet started but queued.

### wip_tasks

List of tasks currently in progress.

---

## Backoff Algorithm

```
WHEN task state changes to PENDING or WIP:
  1. Increment global_wait_counter
  2. Calculate new backoff_ms = min(
       base_backoff_ms * pow(2, (global_wait_counter - 1)),
       max_backoff_ms
     )
  3. Update task.backoff_ms = new backoff_ms
  4. Record current timestamp in task.last_attempt
  5. Increment task.attempts by 1
  6. Wait for task.backoff_ms milliseconds
  7. Attempt task again
```

---

## Example Execution

```json
{
  "global_wait_counter": 1,
  "active_investigations": {
    "openviking": {
      "status": "pending",
      "attempts": 0,
      "backoff_ms": 1000,
      "last_attempt": null,
      "error_count": 0,
      "created": "2026-03-21T09:51:00Z"
    }
  }
}
```

After first pending/WIP:
```json
{
  "global_wait_counter": 2,
  "active_investigations": {
    "openviking": {
      "status": "pending",
      "attempts": 1,
      "backoff_ms": 2000,
      "last_attempt": "2026-03-21T09:57:01Z",
      "error_count": 0,
      "created": "2026-03-21T09:51:00Z"
    }
  }
}
```

---

## Integration with January's Swarm

The wait counter system will be:
1. Spawned as a monitoring subagent
2. Tracks all pending/WIP states
3. Automatically applies exponential backoff
4. Notifies when attempts successful or fail
5. Disables when all tasks complete or compaction clears

---

*Version: 1.0.0*
*Created: 2026-03-21T09:57:00Z*
*Author: January the Swarm Leader*
*File: .backoff-system/wait-counter.json*