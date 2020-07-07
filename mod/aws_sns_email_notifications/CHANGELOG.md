# Changelog

## [1.0.0] (https://stash.customappsteam.co.uk/projects/TER/repos/aws_sns_email_notifications/browse?at=refs%2Ftags%2F1.0.0)

### Added

- AWS Provider locking to 2.63
- Template Provider locking to 2.1
- Jenkinsfile
- .gitignore
- outputs.tf
- CHANGELOG.md
- test directory

### Changed

- Migrating to HCL2 (Terraform 0.12)
    - Forked from [0.5] (https://stash.customappsteam.co.uk/projects/TER/repos/aws_sns_email_notifications/browse?at=refs%2Ftags%2Fv0.5
)
- Renamed interfaces.tf to variables.tf
- Added variable types and descriptions to variables.tf
- Moved outputs from variables.tf to outputs.tf
- Added terraform doc to Readme.md
- Re-named project_name variable to service_name