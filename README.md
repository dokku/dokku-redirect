# dokku-redirect

dokku-redirect is a plugin for [dokku][dokku] that gives the ability to set simple redirects for an application.

This plugin only redirects one domain to another and does not handle complete URLs. If source domain is managed by dokku and is TLS enabled, then nginx configuration for https redirects will be handled automatically.

## Installation

```sh
# dokku 0.11+
$ sudo dokku plugin:install https://github.com/dokku/dokku-redirect.git
```

## Commands

```
$ dokku help
    redirect <app>                           Display the redirects set on app
    redirect:set <app> <src> <dest> [<code>] Set a redirect from <src> domain to <dest> domain
    redirect:unset <app> <src>               Unset a redirect from <source>
```

## Redirect Codes

| Code | Name               | Behavior                                           |
| ---- | ------------------ | -------------------------------------------------- |
| 301  | Moved Permanently  | __(Default)__ Permanent, preserves method          |
| 302  | Found              | Temporary, may change method to GET                |
| 303  | See Other          | (HTTP/1.1) Temporary, changes method to GET        |
| 307  | Temporary Redirect | (HTTP/1.1) Temporary, preserves method             |

## Usage

Check redirects on my-app
```shell
$ dokku redirect my-app

SOURCE       DESTINATION      CODE
ma.dokku.me  my-app.dokku.me  301
```

Set a new redirect on my-app
```shell
$ dokku redirect:set my-app ma.dokku.me my-app.dokku.me

-----> Setting redirect for my-app...
       done
```

Redirects will include all app-specific nginx include files.

Unset an existing redirect
```shell
$ dokku redirect:unset my-app ma.dokku.me

-----> Unsetting redirect for my-app...
       done
```

## License

This plugin is released under the MIT license. See the file [LICENSE](LICENSE).

[dokku]: https://github.com/progrium/dokku
