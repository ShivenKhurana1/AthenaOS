# Recipe format

Recipes describe how to build and install packages in the LFS pipeline.

## Structure

Each recipe is a shell script that defines metadata and optional functions.
The runner sources scripts/lib/recipe-helpers.sh before each recipe.
The recipe runner exports:

- LFS_ROOT: destination root filesystem
- RECIPE_WORK_DIR: build directory for the recipe
- SOURCES_DIR, PATCHES_DIR: shared sources and patches

## Example fields

- name: package name
- version: package version
- source_url: upstream source URL
- source_sha256: expected sha256 checksum
- recipe_build(): optional build steps
- recipe_install(): required install steps
- recipe_post(): optional post-install steps

## Notes

- Recipes should be deterministic and use sources pinned in manifests/versions.lock.
- Athena-specific assets (theme, shell extension, defaults) should be packaged as recipes.
