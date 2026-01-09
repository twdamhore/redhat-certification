# RHCSA Objective 1 - Project Context

> **For Claude:** Read this file at the start of each session to understand project state.

## Project Overview

Practice environment for RHCSA exam prep on RHEL 10 / AlmaLinux 10.1. Tasks are **20% harder** than standard RHCSA requirements. Scoring verifies **results only** (not methods) - like the real exam.

## Environment

| Item | Details |
|------|---------|
| VM OS | AlmaLinux 10.1 |
| Disk | 20 GiB (some unallocated space) |
| VMs | Single VM for Objective 1 |
| Production? | No - safe to experiment |

## File Structure

```
rhcsa/2026/objective-01/
├── prepare.sh      # Sets up /exam/objective1/ (idempotent - rerun to reset)
├── score.sh        # Shows tasks + PASS/NOT COMPLETE (no validation hints)
├── prompts.txt     # All Claude Code prompts
└── CONTEXT.md      # This file
```

## Objective 1: Understand and Use Essential Tools

**45 Tasks Total** (variable per sub-objective)

| Sub-Obj | Topic | Tasks | Points |
|---------|-------|-------|--------|
| 1 | Shell Commands | 4 | 10 |
| 2 | I/O Redirection | 5 | 11 |
| 3 | grep/Regex | 6 | 13 |
| 4 | SSH | 3 | 9 |
| 5 | Users | 4 | 10 |
| 6 | Archive | 5 | 11 |
| 7 | Text Files | 4 | 9 |
| 8 | File Operations | 5 | 11 |
| 9 | Links | 4 | 9 |
| 10 | Permissions | 5 | 11 |
| 11 | Documentation | 4 | 9 |

## Users/Groups

- Users: `examuser` (exam123), `testuser` (test123), `admin` (admin123)
- Groups: `examgroup`, `developers`, `operators`
- examuser has full sudo access

## Scoring Behavior

- Shows task question (what to do)
- Shows PASS or NOT COMPLETE
- **No hints** about validation logic
- Pass: 70/100 points

## Current Status

- [x] Objective 1 complete (v3 - 45 tasks)
- [ ] Objectives 2-10 (not started)

## RHCSA RHEL 10 Objectives

1. **Understand and use essential tools** ← DONE
2. Manage software (RPM, Flatpak)
3. Create simple shell scripts
4. Operate running systems
5. Configure local storage
6. Create and configure file systems
7. Deploy, configure, and maintain systems
8. Manage basic networking
9. Manage users and groups
10. Manage security

## Notes

- Scoring checks RESULTS only, not methods (like real RHCSA)
- Task descriptions guide practice but aren't enforced
- Containers (Podman) removed from RHCSA 10
- 20 GiB disk has unallocated space for storage objectives

## Usage

```bash
git clone https://github.com/twdamhore/redhat-certification.git
cd redhat-certification/rhcsa/2026/objective-01
sudo ./prepare.sh    # Setup (rerun to reset)
cat /exam/objective1/TASKS.txt
sudo ./score.sh      # Check progress
```

---
*Last updated: 2026-01-09*
