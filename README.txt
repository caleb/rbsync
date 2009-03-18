rbsync
    by Caleb Land
    http://www.github.com/caleb/rbsync

== DESCRIPTION:

RBSync is a thin Ruby wrapper around rsync. It removes the string building
from calling rsync from ruby.

== FEATURES/PROBLEMS:

* RBSync is a thin wrapper, so as to expose as much of rsync's power
as possible
* RBSync does, however, require that rsync be installed

== SYNOPSIS:

RBSync has a convenience class which makes it easy to sync with rsync's
archive (-a) flag:

  import 'rubygems'
  import 'rbsync'

  # Builds a usable rsync command using the -a (archive) flag to rsync
  rsync = RBSync::RBSync.new '/mysite/', 'me@myhost.com:/var/www/mysite'
  rsync.archive!
  rsync.sync

If you want more control, you could specify each flag separately. This command
is equivalent to the one above:

  rsync = RBSync::RBsync.new '/mysite/', 'me@myhost.com:/var/www/mysite'
  # turns on rsync's delete flag (--delete)
  rsync.delete!
  rsync.recursive!
  rsync.links!
  rsync.perms!
  rsync.times!
  rsync.group!
  rsync.owner!
  rsync.devices!
  rsync.specials!
  rsync.sync

You can even use the archive flag and turn off those flags which you don't want:
  rsync = RBSync::RBsync.new '/mysite/', 'me@myhost.com:/var/www/mysite'
  rsync.archive!

  # turn off the times (--times) flag
  ~ rsync.times!

  # turn off the devices (--devices) flag
  rsync.devices = false

  rsync.sync

== REQUIREMENTS:

* Ruby >= 1.8.7

== INSTALL:

* sudo gem install rbsync

== LICENSE:

(The MIT License)

Copyright (c) 2009

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
