## [0.2.0] - 2026-10-27

- Sign requests with HMAC-SHA256 when `access_uuid` and `secret` are configured (bearer `access_token` still supported)
- Build the query string in the client instead of Excon, so that the signed path is the one sent

## [0.1.6] - 2025-07-08

- Add modules & definitions endpoints

## [0.1.4] - 2025-07-04

- Add articles endpoint

## [0.1.2] - 2024-12-04

- Add update and terminate methods to subscriptions

## [0.1.1] - 2024-11-06

- Remove rails dependency

## [0.1.0] - 2024-11-06

- Initial release

