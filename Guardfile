clearing :on

guard :rspec, cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_files)
  watch(%r{^spec/(.+)_helper\.rb$}) { "spec" }
  watch(%r{^spec/support/(.+)$}) { "spec" }

  # Library files
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end
