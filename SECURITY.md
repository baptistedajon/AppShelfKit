# Security Policy

AppShelfKit is a lightweight SwiftUI package and does not collect analytics, store credentials, or call App Store scraping APIs.

## Supported Versions

Security fixes are considered for the latest released version.

| Version | Supported |
| --- | --- |
| 0.1.x | Yes |

## Reporting a Vulnerability

Please do not open a public issue for a security vulnerability.

Until a dedicated security contact is published, report privately through the repository owner's preferred GitHub security advisory flow. Include:

- a clear description of the issue
- affected versions or commits
- reproduction steps
- expected impact
- any suggested fix, if available

You should receive an acknowledgment once the maintainer has reviewed the report. If the issue is accepted, the fix will be prepared privately and released with appropriate notes.

## Scope

Relevant reports include:

- unsafe URL handling
- unexpected network behavior
- sensitive data exposure
- test or example code that encourages insecure integration
- documentation that recommends unsafe practices

Out of scope:

- requests for automatic App Store scraping
- issues caused only by a developer's hosted JSON endpoint
- vulnerabilities in Apple platform frameworks outside AppShelfKit's control
