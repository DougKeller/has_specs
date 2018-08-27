module HasSpecs
  class Base
    def self.verify(config)
      missing = []

      included_directories = config.include
      included_directories.each do |directory|
        ruby_file_matcher = '*[(' + config.extension.join(')(') + ')]'
        lookat = File.join(directory, ruby_file_matcher)

        files = Dir.glob(lookat)
        files.each do |filename|
          next if File.directory? filename

          full_spec_file_path = config.path_builder.full_spec_file_path_for(filename)

          file_is_ignored = config.ignore.include?(File.basename filename) || config.ignore.include?(full_spec_file_path)
          unless file_is_ignored || File.exist?(full_spec_file_path)
            missing << full_spec_file_path
          end
        end
      end

      missing
    end
  end
end
