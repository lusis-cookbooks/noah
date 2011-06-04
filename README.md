# Noah cookbook
================
This cookbook has been tested on the following platforms:

* Natty 32-bit Rubygems install
* Natty 64-bit Rubygems install

Right now, only the ubuntu-related stuff is really stubbed out. Init script templates for redhat and non-upstart debian need to be written.

If you want to test it, the recipe you want is `noah::server`.

This will install Noah from rubygems, compile redis from source into a self-contained directory and then create two startup scripts - noah-redis and noah.

# Attributes you probably care about
==================================
You can see the exposed attributes but the key ones are:

- redis\_version
- redis\_port
- noah\_port

If you're okay with it, the default install dir for everything is /var/lib/noah.

Like I said none of this has been tested yet. Don't blame me if your favorite dog leaves you. Pull requests welcome!
