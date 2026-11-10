# Preview only the individually reviewed files in sync-files.txt.
# Review the source and destination diff before applying any changes manually.
# Mixed/private config, tool binaries and submodule revisions stay explicit.
sync:
    @rsync --archive --checksum --dry-run --itemize-changes --files-from=sync-files.txt -- "$HOME/" ./
