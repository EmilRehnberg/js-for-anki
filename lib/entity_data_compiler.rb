require 'pathname'

class EntityDataCompiler
  BUILD_NAME_MODULE_SCRIPT_PATH = "data/concat-name-data.R"

  def self.run
    puts "compiling name data"
    %x(./#{BUILD_NAME_MODULE_SCRIPT_PATH})
  end
end
