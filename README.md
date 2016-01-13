# A Heka buildpack for Cloud Foundry

This buildpack installs Heka (http://hekad.readthedocs.org) into a Cloud
Foundry droplet.

If invoked as the only buildpack (or the final buildpack in a multi-buildpack
environment), it starts a Heka process. By default, the configuration shipped
with this buildpack sets up one input and one output:

- it opens an HTTP Listen Input on $PORT
- it outputs any logged requests to STDOUT

Both of these can be overriden and/or disabled.

## Using This Buildpack

This buildpack must be explicitly specified. It's *strongly* suggested you
reference a specific version of this buildpack, e.g.:

- In a `manifest.yml`:
  - `buildpack: https://github.com/jpluscplusm/heka-buildpack#v0.0.1`
- In a `cf push` invocation:
  - `cf push <APP> -b https://github.com/jpluscplusm/heka-buildpack#v0.0.1`

## Implications Of Installing Heka

When activated this buildpack creates the directory `heka` in your
application's root directory. You can create any hierarchy under this directory
that you need, but it is suggested that you *avoid* populating the following
directories to avoid collisions:

- `heka/bin`
- `heka/share`
- `heka/lib`

## Configuring Heka

Any `.toml` files that Heka finds in the directory `heka/conf/` in your pushed
application will, in the default setup created by this buildpack, be loaded in
alphabetical order.

This buildpack's idea of a reasonable, minimal default configuration is copied
into `heka/conf/` during app staging. This configuration consists of the files
found in the `conf` directory of
`https://github.com/jpluscplusm/heka-buildpack`. If any of these files already
exist in your app under `heka/conf/` then they are *not* copied. This mechanism
is provided to allow for configuration to be overriden by your app.

Alternatively, you may provide your own additional configuration files in
`heka/conf/`. It's suggested you use a numeric prefix starting at `100-`. This
is because the Heka documentation states
(http://hekad.readthedocs.org/en/v0.10.0/config/index.html) that "merging will
happen in alphabetical order, settings specified later in the merge sequence
will win conflicts", and `000-` to `099-` is intended for buildpack use.

The relative usefulness of these two different approaches of overriding the
buildpack's defaults work will be updated in this README over time.

## Lua Sandbox

The Lua sandbox, including how you invoke it and include files inside it,
hasn't yet been investigated in the context of this buildpack. PRs, comments
and issues are welcome to address this!
