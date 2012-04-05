Gem::Specification.new do |s|
  s.name        = 'ruboozie'
  s.version     = '0.1.0'
  s.date        = '2012-04-04'
  s.summary     = "A pure-ruby API for Apache oozie"
  s.description = "Apache Oozie [http://incubator.apache.org/oozie/] is a workflow engine for Apache MapReduce jobs. This wrapper lets you submit jobs and stuff from any ruby project"
  s.authors     = ["dguttman", "Matthew Rathbone"]
  s.email       = 'matthew@foursquare.com'
  s.files       = ["lib/ruboozie.rb", "lib/oozie_admin.rb", "lib/oozie_api.rb", "lib/oozie_jobs.rb", "lib/oozie_objects.rb"]
  s.homepage    =  'http://github.com/rathboma/ruboozie'
  s.add_dependency 'httparty'
  s.add_dependency 'builder'
end