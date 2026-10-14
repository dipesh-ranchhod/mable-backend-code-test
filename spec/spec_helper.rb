require "bigdecimal"
require "stringio"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "mable_transfers"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
end

