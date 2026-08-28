# Project-local skills

Keep local skills directly at `.agents/skills/<name>/SKILL.md`.

The six seed routes are:

- [spec-project](spec-project/SKILL.md)
- [choose-technology](choose-technology/SKILL.md)
- [build-project](build-project/SKILL.md)
- [review-project](review-project/SKILL.md)
- [ship-project](ship-project/SKILL.md)
- [audit-project](audit-project/SKILL.md)

After `create-project`, the new Project owns this index and the copied skills.
The source seed neither owns nor auto-updates them after transfer. Add a local
skill only for Project- or domain-specific repeatable methods and evals that
belong to this repository.

For a concrete specialist gap, first inventory existing Project-local,
harness-native, installed, and Global capabilities. Reuse a sufficient
capability. If the gap remains, use an installed optional manager or the
harness's current official method with explicit authority. Install and update
Cross-Project and Global Skills through the chosen harness or plugin,
outside the Project payload; do not copy a generic management skill into the
Project.
