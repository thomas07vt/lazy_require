require "lazy_require/version"

module LazyRequire

  def self.load(files)
    files = toArray(files)
    failed_files = try_to_require(files)

    if failed_files.length == files.length
      raise "Could not load files: \n#{failed_files.join("\n")}\n"
    elsif failed_files.length != 0
      self.load(failed_files)
    end

    true
  end

  def self.load_all(glob)
    files = Dir[glob]
    self.load(files)
  end

  private

  def self.toArray(files)
    if files.is_a?(Array)
      files
    else
      [files]
    end
  end

  def self.try_to_require(files)
    failed = []
    files.each do |file|
      begin
        require "#{file}"
      rescue NameError => e
        failed << file
      end
    end
    failed
  end


end

