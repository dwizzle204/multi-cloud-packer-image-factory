# Promotion model

## Why promotion exists
Promotion separates:
- "built successfully" (`candidate`)
- "approved for production use" (`prod`)

Promotion is a metadata change (tags/labels), **not a rebuild**.

## Channels
- `candidate`: default state after build
- `prod`: promoted state after approval

## Rollback
Rollback is “promote an older prod-ready version” by changing tags/labels, not rebuilding.

## Retention
A simple retention strategy:
- Keep last N prod versions
- Keep last M candidate versions
- Expire older candidates automatically

Retention automation is optional and can be added later.
