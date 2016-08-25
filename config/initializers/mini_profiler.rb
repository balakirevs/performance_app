# config/initializers/mini_profiler.rb
Rack::MiniProfiler.config.pre_authorize_cb = ->(env) { false }
