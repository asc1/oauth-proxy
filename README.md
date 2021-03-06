# Basic OAuth2 Proxy 
Using Apache 2.4 & [mod_auth_openidc](https://github.com/zmartzone/mod_auth_openidc) in a CentOS7 Docker container, that will perform both OpenID Connect and OAuth2 for everything behind it. It also provides a user info endpoint at `/auth?info=json`.

## Building 
    docker build --rm -t local/oauth-proxy .

## Running
Apache requires several environment variables to configure the OAuth settings -
* `CLIENTID` - OAuth2 Client Id
* `CLIENTSECRET` - OAuth2 Client Secret
* `CRYPTOPHRASE` - Pass Phrase
* `REDIRECTURI` - Redirect URI
* `METADATA` - Provider Metadata URL
* `INTROSPECTION` -Introspection Endpoint

Sample with Google endpoints 
    
    CLIENTID=******************
    CLIENTSECRET=****************
    CRYPTOPHRASE=tooManySecrets
    REDIRECTURI=https://localhost/auth
    METADATA=https://accounts.google.com/.well-known/openid-configuration
    INTROSPECTION=https://www.googleapis.com/oauth2/v1/tokeninfo

Place the environment variables in a file called `env`, and then the proxy can be run locally - 

    docker run -it --rm -p 80:80 -p 443:443 --env-file ./env local/oauth-proxy

## Sessions
Currently sessions are stored on the filesystem in /tmp. This could be moved to Redis/Memcache or moved to a shared filesystem to allow multiple proxies to share sessions. Use of the client-cookie based sessions is not recommended. For more details see https://github.com/zmartzone/mod_auth_openidc/wiki/Caching.

## TODO
Make proxy rules configurable outside of the `proxy.conf` file, to allow them to be passed in to the container at runtime.
