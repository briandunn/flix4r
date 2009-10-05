# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{flix4r}
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Dunn"]
  s.date = %q{2009-10-05}
  s.email = %q{brianpatrickdunn@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "flix4r.gemspec",
     "init.rb",
     "lib/flix4r.rb",
     "lib/net_flix.rb",
     "lib/net_flix/authenticator.rb",
     "lib/net_flix/builders/actor_builder.rb",
     "lib/net_flix/builders/format_builder.rb",
     "lib/net_flix/credentials.rb",
     "lib/net_flix/movie.rb",
     "lib/net_flix/request.rb",
     "lib/net_flix/television.rb",
     "lib/net_flix/title.rb",
     "lib/valuable.rb",
     "test/actor_builder_test.rb",
     "test/authenticator_test.rb",
     "test/credentials_test.rb",
     "test/fixtures/autocomplete.xml",
     "test/fixtures/cast.xml",
     "test/fixtures/directors.xml",
     "test/fixtures/movies.xml",
     "test/fixtures/synopsis.xml",
     "test/fixtures/titles.xml",
     "test/format_builder_test.rb",
     "test/movie_test.rb",
     "test/request_test.rb",
     "test/test_helper.rb",
     "test/title_test.rb"
  ]
  s.homepage = %q{http://github.com/briandunn/flix4r}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{a port of the google code project: http://code.google.com/p/flix4r/}
  s.test_files = [
    "test/actor_builder_test.rb",
     "test/authenticator_test.rb",
     "test/credentials_test.rb",
     "test/format_builder_test.rb",
     "test/movie_test.rb",
     "test/request_test.rb",
     "test/test_helper.rb",
     "test/title_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
