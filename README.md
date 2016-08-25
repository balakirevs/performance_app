README
======

### Performance techniques used in application:
##### Database Performance
  - Fewer queries, faster queries
  - Analysis Tools:
    - X-Runtime
    - Browser's network debug panel
    - Rails log
    - SQL EXPLAIN and [ lol_dba gem ](https://github.com/plentz/lol_dba) Lol_dba:find missing indexes
    - [ Bullet gem ](https://github.com/flyerhzm/bullet): find N+1 queries & unused eager loading
    - Rack mini profiler
    - New Relic
    - Rails Panel for Chrome
  - Techniques:
    - Pagination (Gems: Kaminari, will_paginate)
    - Add indexes
    - Counter cache
    - Select only columns which are used 
    - Pluck columns which are used (User.pluck(:id) faster than User.select(:id).to_a or User.all.map(&:name))
    - Order by :id, not by :created_at
    - if making multiple writes - use transaction
    - if iterating over tons of rows - use find_each
      ```bash
      ➜  performance_app rails c
      Loading development environment (Rails 4.2.7.1)
      2.3.1 :001 > Enrollment
      => Enrollment (call 'Enrollment.connection' to establish a connection)
      2.3.1 :001 > Benchmark.realtime { Enrollment.all.each {} }
      Enrollment Load (1235.4ms)  SELECT "enrollments".* FROM "enrollments"
       => 9.763525928006857
      2.3.1 :002 > exit
      ➜  performance_app ps -o pid,rss,command 
      PID   RSS COMMAND
      20599  7412 -zsh
      27440   908 ps -o pid,rss,command  
      ```
      
      ```bash
      ➜  performance_app rails c
      Loading development environment (Rails 4.2.7.1)
      2.3.1 :001 > Enrollment
      => Enrollment (call 'Enrollment.connection' to establish a connection)
      2.3.1 :001 > Benchmark.realtime { Enrollment.find_each {} }
      => 10.758293303995742
      2.3.1 :004 >   exit
      ➜  performance_app ps -o pid,rss,command                       
      PID   RSS COMMAND
      20599  7412 -zsh
      28205   904 ps -o pid,rss,command       
      ```
      find_each is barely slower though much less memory used than with all.each.
##### Browser Cashing
   - HTTP Haders:
     - Last-Modified / If-Modified-Since
     - ETag / If-None-Match
     - Cache-Control: public, private, max-age
   - Rack ETag
   - Usage stale? or fresh_when
   - Propagade updated_at to owning objects with touch:true
   - Include session data into ETag
   - Declarative ETags
   - Reset ETags on deploy for HTML and CSS changes
   - usage of expires_in  
##### Fragment Cashing
   - Memcached
   - gem Dalli
   - Fragment caching
   - Cache key includes digest of view contents
   - Cache expiration strategies
##### Russian Doll Cashing
   - Hiding links
   - Time Zones
   - Increasing cache hits
   - Helping Rails know what partial was used
##### Turbolinks & Pjax
   - Turbolinks: single-page app performance for multi page apps
   - Permalinks and working back button
   - pushState
   - Degrades gracefully
   - Data-Turbolinks-Track: detect asset changes
   - JQuery Turbolinks
   - Plugin compatibility site
   - Alternative: pjax
   
Setup
-----

This app uses PostgreSQL by default. Configuration settings for SQLite
and MySQL are available in config/database.yml, commented out.
To use SQLite or MySQL, edit config/database.yml and use the settings
you prefer.

Then:

    rake db:setup   # Create and migrate the database
    rake data:fake  # Set up fake data. Takes a few minutes.
    ruby -Itest test/integration/turbolinks_performance_test.rb

Additional tools:
- apache2-utils (Benchmarking)