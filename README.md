# CSVale Free Tools

Free downloadable utilities from CSVale for everyday Windows and productivity workflows.

## Available tools

### Windows Hosts Manager
- Name: Windows Hosts Manager
- Version: 1.0.0
- Platform: Windows
- Description: PowerShell script to view and manage the Windows hosts file quickly and safely.
- Download: See `tools.json`

## Repository structure

```text
csvale-tools/
├── README.md
├── tools.json
├── add-host-windows.ps1
├── .gitignore
└── releases/
```

## How tool metadata works

This repository exposes a `tools.json` file, which is read by the landing page at `https://csvale.com/tools`.

Example entry:

```json
[
  {
    "slug": "add-host-windows",
    "name": "Windows Hosts Manager",
    "description": "PowerShell script to easily manage Windows hosts file entries.",
    "version": "1.0.0",
    "platform": "Windows",
    "downloadUrl": "https://github.com/csvale-ops/csvale-tools/releases/download/v1.0.0/add-host-windows.ps1"
  }
]
```

## How to add a new tool

1. Create or prepare the tool file (for example `.ps1`, `.exe`, or a zip archive).
2. Upload the file to a GitHub Release tagged with a version, such as `v1.0.0`.
3. Add the metadata to `tools.json`.
4. Make sure the `downloadUrl` points to the release asset.
5. The landing page will automatically display the tool.

## Notes

- Keep the `slug` unique and URL-friendly.
- Use semantic, readable names for end users.
- Prefer GitHub Releases for binary downloads to keep file distribution reliable.
