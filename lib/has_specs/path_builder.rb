module HasSpecs
  class PathBuilder
    def initialize(config)
      @config = config
    end

    def full_spec_file_path_for(filename)
      expected_directory = expected_spec_directory_for(filename)

      suffix_required = true
      @config.ignored_suffix_directories.each do |directory|
        suffix_required = false if expected_directory.include?(directory)
      end
      expected_filename = expected_spec_filename_for(filename, suffix_required: suffix_required)

      File.join(expected_directory, expected_filename)
    end

    private

    def application_name(path)
      regex = /\/applications\/([^\/]*)\/app\//
      regex.match(path).try(:[], 1)
    end

    def expected_spec_directory_for(path)
      app_name = application_name(path)

      relative_path = path
      @config.application_roots.each do |app_root|
        relative_path = relative_path.gsub(app_root, '')
      end
      relative_path = relative_path.gsub(app_name + '/', '') if app_name != nil

      parts = [@config.spec_root]
      parts << app_name if app_name != nil
      parts << relative_path
      File.dirname(File.join(*parts))
    end

    def expected_spec_filename_for(filename, suffix_required: true)
      if File.extname(filename) != '.rb'
        extension = '.rb'
        basename = File.basename(filename)
      else
        extension = File.extname(filename)
        basename = File.basename(filename, extension)
      end

      parts = []
      parts << basename
      parts << @config.suffix if suffix_required
      parts << extension
      parts.join('')
    end
  end
end