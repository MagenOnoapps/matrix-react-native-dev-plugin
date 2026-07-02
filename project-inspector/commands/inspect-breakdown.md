---
description: Expand one Pending Breakdown topic from AUDIT.md into a detailed Draft audit (audit-breakdown skill)
argument-hint: "[topic name]"
---

Invoke the `audit-breakdown` skill from the project-inspector plugin.

If the developer provided arguments, treat them as the selected topic: $ARGUMENTS

Follow the skill's workflow exactly: ask the Step 1 questions (skipping topic selection if a topic argument was given), show the confirmation summary, process exactly one topic, and stop.
