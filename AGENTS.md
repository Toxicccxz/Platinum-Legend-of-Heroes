# Coding Agent Guidelines

This is a Godot 4.x game project.

## General Behavior

- Think before coding.
- State assumptions when the task is ambiguous.
- Prefer the simplest implementation that solves the current request.
- Do not add speculative features.
- Make surgical changes only.
- Do not refactor unrelated code.
- Every changed line should be related to the user request.

## Godot Rules

- Prefer editing `.gd` scripts.
- Do not edit `.tscn`, `.tres`, `.import`, or asset files unless explicitly asked.
- Use typed GDScript where practical.
- Use `@export` for tunable gameplay values.
- Keep gameplay logic out of UI scripts unless the task is specifically UI-related.
- Keep reusable logic in components, not giant scene scripts.
- Do not create global singletons unless explicitly requested.

## Verification

When possible:
- Run Godot script checks.
- Run existing tests.
- Explain what still needs manual testing in the Godot Editor.

## Project Structure

- scenes/ contains Godot scene files.
- scripts/ contains GDScript logic.
- resources/ contains reusable Resource data.
- assets/ contains imported art/audio/fonts.