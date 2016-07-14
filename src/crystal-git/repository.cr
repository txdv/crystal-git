class Git::Repository
  def self.init(path = ".", bare = false)
    if LibGit2.repository_init(out repository, path, bare ? 0 : 1) == 0
      new(repository)
    else
      # TODO: check giterr_last
      raise "Couldn't init repository at #{path}"
    end
  end

  def self.open(path = ".")
    if LibGit2.repository_open(out repository, path) == 0
      new(repository)
    else
      raise "Couldn't open repository at #{path}"
    end
  end

  def self.discover(start_path, accross_fs = false, ceiling_dirs = nil)
    buf = Buf.new
    r = LibGit2.repository_discover(buf, start_path, accross_fs ? 1 : 0, ceiling_dirs)
    if r == LibGit2::ErrorCode::NotFound
      nil
    elsif r != 0
      raise LibGit2.err_last.value.message.to_s
    end
    buf.to_s
  end

  def initialize(@repo : LibGit2::X_Repository)
  end

  def head
    r = LibGit2.repository_head(out ref, @repo)
    if r != 0
      raise LibGit2.err_last.value.message.to_s
    end

    Reference.new(ref)
  end

  def finalize
    LibGit2.repository_free(@repo)
  end

  def to_unsafe
    @repo
  end
end
