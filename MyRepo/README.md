# YuShuo Cydia Repo

This folder is ready for GitHub Pages.

## Update package metadata

1. Put your compiled package here:

   debs/com.yourname.iapstorage_0.0.1.deb

2. Regenerate metadata on Windows PowerShell:

   ./Generate-CydiaRepo.ps1

The script writes:

- Packages
- Packages.bz2
- Release

Then upload the contents of this `MyRepo` folder to a public GitHub repository and enable GitHub Pages from the `main` branch.
