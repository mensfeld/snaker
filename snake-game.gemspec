lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name        = 'snake-game'
  spec.version     = '0.0.0'
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Maciej Mensfeld']
  spec.email       = %w[maciej@mensfeld.pl]
  spec.homepage    = 'https://github.com/mensfeld/snake-game'
  spec.summary     = 'Pure Ruby implementation of the Snake game.'
  spec.description = 'You can play on your production servers while pretending to work.'
  spec.license     = 'GPL-3.0 License'
  spec.files       = %w[snake-game.rb]
  spec.executables = 'snake-game'
  s.metadata       = { source_code_uri: 'https://github.com/mensfeld/snake-game' }
end
