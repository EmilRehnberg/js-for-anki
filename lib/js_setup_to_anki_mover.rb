require 'pathname'
require 'fileutils'

class JsSetUptoAnkiMover
  OUTPUT_DIR = Pathname.new("~/Documents/Anki/e/collection.media/.").expand_path
  JS_FILE_REGEX = Regexp.new(/\_[\w-]+\.js/)
  REQUIRE_JS_FILE_NAME = "_require.js"

  def self.run
    puts "copying JavaScript to Anki"
    copy_js_setup
  end

  private

  def self.copy_js_setup
    puts "  copying following scripts to anki: #{updated_scripts}"
    FileUtils.cp_r(updated_scripts, OUTPUT_DIR, remove_destination: true)
  end

  def self.updated_scripts
    js_file_names.select { |file_name|
      @anki_file_name_path = anki_file_name_path(file_name)
      file_new_or_updated?(file_name)
    }
  end

  def self.js_file_names
    Dir.entries(".").select{ |file_name|
      file_name[JS_FILE_REGEX]
    }
  end

  def self.file_new_or_updated?(file_name)
    return file_name unless anki_version_exists?
    file_name if anki_version_is_old?(file_name)
  end

  def self.anki_version_exists?
    File.exist?(@anki_file_name_path)
  end

  def self.anki_file_name_path(file_name)
    OUTPUT_DIR + file_name
  end

  def self.anki_version_is_old?(file_name)
    File.mtime(file_name) > File.mtime(@anki_file_name_path)
  end
end
