# Sequencescape Client API

This is the Ruby client library for the Sequencescape API.
Documentation can be found [on the wiki](https://github.com/sanger/sequencescape-client-api/wiki).

## Version Guides

- 0.2.x Supports older versions of Rails.
- 0.3.x Supports Rails 3.2.x to 5.1.x
- 0.4.x Supports Rails 5.0 and up
- 0.5.x Supports Rails 5.0 and up, drops yajl in favour of multi-json
- 0.6.x Removes usage of WTSISignOn cookie. Replaces with user specific api key,
  can be provided to Sequencescape::Api.new as user_api_key: or via
  `api_connection_options` in the controller.
- 1.0.x Enables HTTPS
- 2.0.x Drops support for versions less than Ruby 2.7

- master currently corresponds to 2.x

Rails 6 appears to be supported judging by Specs, but haven't used it in anger
yet.

## Making a release

1. Update the version number in `lib/sequencescape-api/version.rb`
2. For pre-releases the version number should be in the format:
   major.minor.point-rcx (increment x to prevent burning though version numbers when testing release candidates)
3. For release version the version number should be in the format:
   major.minor.point
4. Ensure everything is committed, and for non-pre-releases, make sure you are
   merged to master.

```
  rake release
``
```
