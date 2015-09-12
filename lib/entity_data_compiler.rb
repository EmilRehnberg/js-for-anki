require 'pathname'

class EntityDataCompiler
  BASE_SCRIPT = "names-merger.js"
  DATA_DIR = Pathname.new("data")
  OUTPUT_FILE_NAME = "_entity-data.js"
  JS_FILE_REGEX = Regexp.new(/[\w-]+\.js/)

  def self.run
    # return if nothing_new?
    remove_destination
    File.open(OUTPUT_FILE_NAME, 'a'){ |handle|
      name_sets.each { |set|
        handle.puts File.read(DATA_DIR + set)
      }
      handle.puts File.read(DATA_DIR + BASE_SCRIPT)
    }
  end

  def self.name_sets
    js_file_names - Array(BASE_SCRIPT)
  end

  def self.js_file_names
    Dir.entries(DATA_DIR).select{ |file_name|
      file_name[JS_FILE_REGEX]
    }
  end

  def self.remove_destination
    File.delete(OUTPUT_FILE_NAME) if File.exist?(OUTPUT_FILE_NAME)
  end
end
