require 'pathname'

class DataCompiler
  BUILD_NAME_MODULE_SCRIPT_PATH = "data/names/concat-name-data.R"
  BUILD_WORDS_MODULE_SCRIPT_PATH = "data/compile-words-from-db.R"

  def self.run
    puts "compiling name data"
    %x(./#{BUILD_NAME_MODULE_SCRIPT_PATH})
    puts "compiling words data"
    %x(./#{BUILD_WORDS_MODULE_SCRIPT_PATH})
  end
end
