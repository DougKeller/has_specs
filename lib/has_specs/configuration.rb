module HasSpecs
  class Configuration
    def root=(desired_root)
      @root = desired_root
    end

    def root
      if defined? Rails
        @root ||= File.join(::Rails.root, 'app/')
      else
       @root ||= Dir.pwd
     end
    end

    def spec_root=(desired_root)
      @spec_root = desired_root
    end

    def spec_root
      @spec_root ||= File.join(::Rails.root, 'spec')
    end

    def exclude
      @exclude ||= ['spec', 'assets']
    end

    def exclude=(exclude_dirs)
      @exclude = exclude_dirs
    end

    def ignore=(ignore_files)
      @ignore = ignore_files
    end

    def ignore
      @ignore ||= []
    end

    def suffix=(suffix)
      @suffix = suffix
    end

    def suffix
      @suffix ||= '_spec'
    end

    def ignored_suffix_directories=(directories)
      @ignored_suffix_directories = directories
    end

    def ignored_suffix_directories
      @ignored_suffix_directories ||= []
    end

    def extension
      [".rb", ".erb", ".jbuilder"]
    end

    def application_roots
      if defined? Rails
        [root] + Dir.glob(File.join(::Rails.root, 'applications', '*', 'app/'))
      else
        [root]
      end
    end

    def include
      directories = []
      application_roots.each do |app_root|
        directories = directories + Dir.glob(File.join(app_root, '**/*/'))
      end
      directories.delete_if { |directory| exclude_directory? directory }
    end

    def path_builder
      @path_builder ||= PathBuilder.new(self)
    end

    private

    def exclude_directory?(directory)
      matches = self.exclude.find do |excluded|
        regex = Regexp.new(Regexp.escape(File.join(excluded, '/')))
        directory =~ regex
      end
      !!matches
    end
  end
end