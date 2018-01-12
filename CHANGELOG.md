# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v2.2.1](https://github.com/voxpupuli/puppet-rsyslog/tree/v2.2.1) (2018-01-12)

[Full Changelog](https://github.com/voxpupuli/puppet-rsyslog/compare/v2.2.0...v2.2.1)

**Closed issues:**

- Dependency circle with action class [\#47](https://github.com/voxpupuli/puppet-rsyslog/issues/47)
- Document ordering / sort algorithm [\#45](https://github.com/voxpupuli/puppet-rsyslog/issues/45)

**Merged pull requests:**

- Release 2.2.1 [\#52](https://github.com/voxpupuli/puppet-rsyslog/pull/52) ([dhollinger](https://github.com/dhollinger))
- Set concat order numeric [\#51](https://github.com/voxpupuli/puppet-rsyslog/pull/51) ([dhollinger](https://github.com/dhollinger))
- Updated docs to correctly reflect the priority functionality [\#50](https://github.com/voxpupuli/puppet-rsyslog/pull/50) ([dhollinger](https://github.com/dhollinger))
- release 2.2.0 [\#49](https://github.com/voxpupuli/puppet-rsyslog/pull/49) ([bastelfreak](https://github.com/bastelfreak))

## [v2.2.0](https://github.com/voxpupuli/puppet-rsyslog/tree/v2.2.0) (2018-01-04)

[Full Changelog](https://github.com/voxpupuli/puppet-rsyslog/compare/v2.1.0...v2.2.0)

**Implemented enhancements:**

- Refactor rulesets [\#40](https://github.com/voxpupuli/puppet-rsyslog/pull/40) ([dhollinger](https://github.com/dhollinger))
- Add filters [\#39](https://github.com/voxpupuli/puppet-rsyslog/pull/39) ([dhollinger](https://github.com/dhollinger))

**Closed issues:**

- Add acceptance tests [\#43](https://github.com/voxpupuli/puppet-rsyslog/issues/43)
- Add OS Compatibility matrix  [\#42](https://github.com/voxpupuli/puppet-rsyslog/issues/42)
- Add acceptance test config and helpers [\#41](https://github.com/voxpupuli/puppet-rsyslog/issues/41)
- Refactor Rulesets and Filters [\#32](https://github.com/voxpupuli/puppet-rsyslog/issues/32)

**Merged pull requests:**

- bump lowest puppet version 4.4.0-\>4.10.9 [\#48](https://github.com/voxpupuli/puppet-rsyslog/pull/48) ([bastelfreak](https://github.com/bastelfreak))
- Add unit and acceptance tests [\#44](https://github.com/voxpupuli/puppet-rsyslog/pull/44) ([dhollinger](https://github.com/dhollinger))
- Release 2.1.0 [\#38](https://github.com/voxpupuli/puppet-rsyslog/pull/38) ([dhollinger](https://github.com/dhollinger))

## [v2.1.0](https://github.com/voxpupuli/puppet-rsyslog/tree/v2.1.0) (2017-12-06)

[Full Changelog](https://github.com/voxpupuli/puppet-rsyslog/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

- Add basic support for rsyslog filters in rulesets [\#31](https://github.com/voxpupuli/puppet-rsyslog/pull/31) ([dhollinger](https://github.com/dhollinger))

**Closed issues:**

- Support Filters [\#30](https://github.com/voxpupuli/puppet-rsyslog/issues/30)

**Merged pull requests:**

- Fix up README markdown and LICENSE file [\#37](https://github.com/voxpupuli/puppet-rsyslog/pull/37) ([alexjfisher](https://github.com/alexjfisher))

## [v2.0.0](https://github.com/voxpupuli/puppet-rsyslog/tree/v2.0.0) (2017-12-06)

[Full Changelog](https://github.com/voxpupuli/puppet-rsyslog/compare/1.1.0...v2.0.0)

**Merged pull requests:**

- Release 2.0.0 [\#36](https://github.com/voxpupuli/puppet-rsyslog/pull/36) ([dhollinger](https://github.com/dhollinger))
- Add additional README.md shields [\#35](https://github.com/voxpupuli/puppet-rsyslog/pull/35) ([dhollinger](https://github.com/dhollinger))
- modulesync 1.5.0 [\#34](https://github.com/voxpupuli/puppet-rsyslog/pull/34) ([dhollinger](https://github.com/dhollinger))

## 1.1.0 (2017-10-17)

* Feature: Added an `external_service` boolean parameter for allowing puppet-rsyslog to manage configs/logs shared with other processes that may be managed by other modules. (https://github.com/crayfishx/puppet-rsyslog/pull/28)

# 1.0.0

This release contains many new enhancements and features, and brings the module to a 1.0.0 release.  Many thanks to @dhollinger for the many contributions to this release.

* Enhancement: [Added flag to enable/disable service management](https://github.com/crayfishx/puppet-rsyslog/issues/17)
* Enhancement: [Add custom config dirs and target files](https://github.com/crayfishx/puppet-rsyslog/issues/19)
* Feature: [Rsyslog 8.x lookup table support](s://github.com/crayfishx/puppet-rsyslog/issues/15)
* Feature: [Support for the rsyslog parser() function](https://github.com/crayfishx/puppet-rsyslog/issues/21)
* Feature: [Support for multi ruleset generation](https://github.com/crayfishx/puppet-rsyslog/issues/22)
* Feature: [Support for ruleset stops](https://github.com/crayfishx/puppet-rsyslog/pull/26)
* Bugfix: [Solve the lack of errors when a component concat::fragment doesn't generate content due to a missing parent concat resource](https://github.com/crayfishx/puppet-rsyslog/issues/19)


### 0.2.0

* [Fixed variable scoping styling and rake validation fixes](https://github.com/crayfishx/puppet-rsyslog/pull/2)
* [Support for legacy options](https://github.com/crayfishx/puppet-rsyslog/pull/4)
* [README fixes](https://github.com/crayfishx/puppet-rsyslog/pull/5)
* [Option support for modules](https://github.com/crayfishx/puppet-rsyslog/pull/6)
* [Updated the action component to support logger facility](9)
* [Added more tests for the legacy_config / main_queue class](https://github.com/crayfishx/puppet-rsyslog/pull/10)
* [Documentation Updates](https://github.com/crayfishx/puppet-rsyslog/pull/12)
* [Fixed the global params config styling](https://github.com/crayfishx/puppet-rsyslog/pull/13)


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*