# Git Finder

Small script that finds all git repositories in a specific location.

## Usage

```bash
git-finder -d /path/to/dir -u <true/false> -r <true/false>
```

## Options:
  
```  
  -d <directory>         Specify the directory to search (mandatory)
  -r <has_remote>        Filter by remote presence: true/false (default: true)
  -u <has_uncommitted>   Filter by uncommitted changes: true/false (default: false)
  -h                     Display this help message
```