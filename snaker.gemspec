# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'snaker'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Maciej Mensfeld']
  s.email       = %w[maciej@mensfeld.pl]
  s.homepage    = 'https://github.com/mensfeld/snaker'
  s.summary     = 'Pure Ruby implementation of the Snake game.'
  s.description = 'You can play on your production servers while pretending to work.'
  s.license     = 'GPL-3.0 License'
  s.files       = %w[lib/snaker.rb lib/snaker/game_logic.rb]
  s.executables = 'snaker'
  s.metadata    = { 'source_code_uri' => 'https://github.com/mensfeld/snaker',
                    'rubygems_mfa_required' => 'true' }
  s.require_paths = %w[lib]
end
