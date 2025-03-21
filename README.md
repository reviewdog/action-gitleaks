# action-gitleaks

[![Test](https://github.com/reviewdog/action-gitleaks/workflows/Test/badge.svg)](https://github.com/reviewdog/action-gitleaks/actions?query=workflow%3ATest)
[![reviewdog](https://github.com/reviewdog/action-gitleaks/workflows/reviewdog/badge.svg)](https://github.com/reviewdog/action-gitleaks/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/reviewdog/action-gitleaks/workflows/depup/badge.svg)](https://github.com/reviewdog/action-gitleaks/actions?query=workflow%3Adepup)
[![release](https://github.com/reviewdog/action-gitleaks/workflows/release/badge.svg)](https://github.com/reviewdog/action-gitleaks/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/reviewdog/action-gitleaks?logo=github&sort=semver)](https://github.com/reviewdog/action-gitleaks/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

<!--![github-pr-review demo](https://user-images.githubusercontent.com/3797062/73162963-4b8e2b00-4132-11ea-9a3f-f9c6f624c79f.png)-->
<!--![github-pr-check demo](https://user-images.githubusercontent.com/3797062/73163032-70829e00-4132-11ea-8481-f213a37db354.png)-->

This action runs [gitleaks](https://github.com/gitleaks/gitleaks) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve code review experience.

## Input

```yaml
inputs:
  github_token:
    description: 'GITHUB_TOKEN'
    default: '${{ github.token }}'
  workdir:
    description: 'Working directory relative to the root directory.'
    default: '.'
  ### Flags for reviewdog ###
  level:
    description: 'Report level for reviewdog [info,warning,error]'
    default: 'error'
  reporter:
    description: 'Reporter of reviewdog command [github-pr-check,github-pr-review].'
    default: 'github-pr-check'
  filter_mode:
    description: |
      Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
      Default is added.
    default: 'added'
  fail_level:
    description: |
      If set to `none`, always use exit code 0 for reviewdog.
      Otherwise, exit code 1 for reviewdog if it finds at least 1 issue with severity greater than or equal to the given level.
      Possible values: [none,any,info,warning,error]
      Default is `none`.
    default: 'none'
  fail_on_error:
    description: |
      Deprecated, use `fail_level` instead.
      Exit code for reviewdog when errors are found [true,false]
      Default is `false`.
    deprecationMessage: Deprecated, use `fail_level` instead.
    default: 'false'
  reviewdog_flags:
    description: 'Additional reviewdog flags'
    default: ''
  ### Flags for gitleaks ###
  gitleaks_flags:
    description: "flags and args of gitleaks command. Default: ''"
    default: ''
```

## Usage

```yaml
name: reviewdog
on: [pull_request]
jobs:
  gitleaks:
    name: runner / gitleaks
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@ee0669bd1cc54295c223e0bb666b733df41de1c5 # v2.7.0
      - uses: reviewdog/action-gitleaks@1458857b76107d28d5ebab788230c0d0e23f76ad # v1.7.2
        with:
          github_token: ${{ secrets.github_token }}
          # Change reviewdog reporter if you need [github-pr-check,github-check,github-pr-review].
          reporter: github-pr-review
          # Change reporter level if you need.
          # GitHub Status Check won't become failure with warning.
          level: warning
```

## Development

### Release

#### [haya14busa/action-bumpr](https://github.com/haya14busa/action-bumpr)
You can bump version on merging Pull Requests with specific labels (bump:major,bump:minor,bump:patch).
Pushing tag manually by yourself also work.

#### [haya14busa/action-update-semver](https://github.com/haya14busa/action-update-semver)

This action updates major/minor release tags on a tag push. e.g. Update v1 and v1.2 tag when released v1.2.3.
ref: https://help.github.com/en/articles/about-actions#versioning-your-action

### Lint - reviewdog integration

This reviewdog action itself is integrated with reviewdog to run lints
which is useful for Docker container based actions.

![reviewdog integration](https://user-images.githubusercontent.com/3797062/72735107-7fbb9600-3bde-11ea-8087-12af76e7ee6f.png)

Supported linters:

- [reviewdog/action-shellcheck](https://github.com/reviewdog/action-shellcheck)
- [reviewdog/action-hadolint](https://github.com/reviewdog/action-hadolint)
- [reviewdog/action-misspell](https://github.com/reviewdog/action-misspell)
- [reviewdog/action-alex](https://github.com/reviewdog/action-alex)

### Dependencies Update Automation
This repository uses [reviewdog/action-depup](https://github.com/reviewdog/action-depup) to update
reviewdog version.

[![reviewdog depup demo](https://user-images.githubusercontent.com/3797062/73154254-170e7500-411a-11ea-8211-912e9de7c936.png)](https://github.com/reviewdog/action-gitleaks/pull/6)
