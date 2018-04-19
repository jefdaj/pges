PGES Site
=========

This is the code for [pges.berkeley.edu](https://pges.berkeley.edu), the
website of the Plant Genome Editing Symposium at UC Berkeley. It's made with
[Hakyll](https://jaspervdj.be/hakyll/index.html), a
[Haskell](http://haskell.org) web framework for generating static sites.

Build, Test, Deploy
-------------------

There are four steps to updating the site:

1. Compile the Haskell code into a `pges` binary
2. Use that binary to generate HTML in `src/_site`
3. Copy the HTML to the test server and make sure it looks OK
4. Copy it to the main server

[build.sh](build.sh) does steps #1-2 on a Debian or Fedora system,
[test.sh](test.sh) does #3, and [deploy.sh](deploy.sh) does #4. If you use a
different OS or host the HTML somewhere else you'll need to adjust them. Ask
Jeff for the ssh keys. Note that even though not much human work is required
to build the site, your computer might take a while compiling lots of Haskell
packages the first time.

Develop
-------

[build.sh](build.sh) builds the site, then also serves it at <http://localhost:8000>.
Changes to HTML, CSS, and other source files will be reloaded immediately.

Haskell code is the exception: if you change it you need to kill and re-run the
build script to recompile. If it works it'll go back to serving the site, and
f not you'll be dropped into the REPL to fix the type errors.

License
-------

I got permission to make a site "heavily inspired" by [the Hakyll author's
blog](https://jaspervdj.be/), on the condition that it will be
available as an example on Github under the same license he uses:

> This website falls under regular copyright laws. This means the code is
> available _as a reference_. You shouldn't use it as a starting point for your
> own site, the examples on the [Hakyll site](http://jaspervdj.be/hakyll) are
> much cleaner.
