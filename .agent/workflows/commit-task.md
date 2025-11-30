---
description: Commit changes after completing a task
---

# Commit Task Workflow

This workflow should be executed after completing each task from TASKS.md.

## Steps:

1. **Review the changes made**
   - Verify that all changes related to the task are complete
   - Ensure no unrelated changes are included

// turbo
2. **Stage all changes**
   ```
   git add .
   ```

// turbo
3. **Commit with descriptive message**
   ```
   git commit -m "[Task X.Y] Brief description of completed task"
   ```
   
   **Commit Message Format:**
   - Use `[Phase X.Y]` or `[Task X.Y]` prefix to reference the task section
   - Include a brief, clear description of what was accomplished
   - Examples:
     - `[Phase 0.1] Rename app to Wasslni Plus and update all configurations`
     - `[Phase 0.2] Remove Hebrew support and verify Arabic/English localization`
     - `[Phase 1.3] Implement branch management dashboard`
     - `[Phase 2.1] Set up Firebase project and configure FlutterFire`

4. **Optional: Push changes to remote**
   ```
   git push origin main
   ```
   (Only if you want to immediately sync with remote repository)

## Notes:

- Always commit logically related changes together (one task = one commit)
- Write clear, descriptive commit messages that reference the task number
- If a task is large, consider breaking it into smaller sub-commits
- Review the staged changes before committing to ensure accuracy
