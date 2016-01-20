# Using Heka as your process supervisor

This example uses Heka:

- to start up the main CF process
- to capture and process the app's stdout/stderr logs

## Why you might do this

In this example, nothing meaningful is done with the logs other than the
buildpack default of emiting them to stdout, where they would be picked up and
routed by the CF loggregator. This simple setup is, of course, pointless - you
would only choose this process supervisor method if you needed to do something
**different** and not just pass them straight through. For example, you might
want to:

- submit the logs to a non-loggregator-compatible log drain (e.g. Logentries)
  via a Heka Output
- quiesce and/or summarise frequently observed logs via a Heka Filter
- generate additional stats or logs from the app logs and route them either
  into the loggregator or to an alternative log drain
- work around a (hopefully temporarily!) malfunctioning loggregator and submit
  logs directly from "the app", but without having to modify the actual
  app's codebase to implement this

**You** need to work out how to achieve this extra functionality inside Heka.
Other examples in this buildpack may give you ideas, but this specific example
does nothing special - it's simply an example of wrapping up the app's
stdout/stderr.

## How to use this example

This example can be adapted for use as follows:

- copy the `.toml` files from this directory into your app in `heka/conf/`
- move from your app's buildpack to the multi-buildpack
  - `https://github.com/ddollar/heroku-buildpack-multi`
- place your previous buildpack **first** in the file `.buildpacks`, as per the
  multi-buildpack docs
- place this buildpack **last** in `.buildpacks`
  - e.g. `https://github.com/jpluscplusm/heka-buildpack#v0.0.3`
- modify your app's `heka/conf/100-process-supervisor.toml` so that the correct
  process is started by Heka
  - this is *probably* trivially adaptable from your current `Procfile`
    contents
- add one or more config fragments in `heka/conf/` (starting at prefix `150` or
  so) that implement your custom filter/decoder/output/etc logic
- if you need to **stop** the app logs from being submitted to the loggregator
  for some reason (perhaps you're submitting them directly to your log drain
  from Heka **and** from the loggregator, and don't want to receive the app logs
  twice but **do** want to receive the CF infra logs):
  - disable the buildpack's default stdout output by creating an empty file
    `heka/conf/009-stdout.toml` in your app
- `cf push` to your live, production app immediately
  - alternatively, run a test first; it's your choice

