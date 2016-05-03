require "lazy_require/version"

module LazyRequire

  class << self
    alias_method :kernal_require, :require

    def require(files)
      files = toArray(files)
      failed_files = try_to_require(files)

      if failed_files.length == files.length
        kernal_require "#{files.first}"
      elsif failed_files.length != 0
        self.require(failed_files)
      end

      true
    end

    def require_all(glob)
      files = Dir[glob]
      self.require(files)
    end

    private

    def toArray(files)
      if files.is_a?(Array)
        files
      else
        [files]
      end
    end

    def try_to_require(files)
      failed = []
      files.each do |file|
        begin
          kernal_require "#{file}"
        rescue NameError
          failed << file
        end
      end
      failed
    end

  end


end

