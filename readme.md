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

[build.sh](build.sh) does steps #1-2 on a Debian system, [test.sh](test.sh)
does #3, and [deploy.sh](deploy.sh) does #4. If you use a different OS or host
the HTML somewhere else you'll need to adjust them. Ask Jeff for the ssh keys.
Note that even though not much human work is required to build the site, your
computer might take a while compiling lots of Haskell packages the first time.

License
-------

I got permission to make a site "heavily inspired" by [the Hakyll author's
blog](https://jaspervdj.be/), on the condition that it will be
available as an example on Github under the same license he uses:

This website falls under regular copyright laws. This means the code is
available _as a reference_. You shouldn't use it as a starting point for your
own site, the examples on the [Hakyll site](http://jaspervdj.be/hakyll) are
much cleaner.

TODO
----

2018 updates:

* Add previous pamphlet(s)
* Logo
* Homepage: date, eventbrite, different sponsors?
* Speakers
* Schedule (TBD)
* Previous: add 2017 pics, and shedule/pamphlet?
* About: new people! new pics?
* Github: rename to remove 2017
* Instead of a mailto link, have an HTML form for it?
