# Noah cookbook
================
This cookbook has **NOT** been tested. I'm just getting it up on Github as I go along.
Eventually, it will support both Redhat and Debian flavored distros.

Right now, only the debian-related stuff is really stubbed out. Init script templates for redhat need to be written.

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
