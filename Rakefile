require 'bundler'
require 'rake/testtask'

task :default => :spec

Rake::TestTask.new(:spec) do |t|
  t.test_files = FileList['spec/**/*_spec.rb']
end

task :kicker do
  exec 'kicker --no-notification -r ruby -e "clear && bundle exec rake" spec lib'
end
