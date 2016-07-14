class Git::Walker
  # TODO: check for the return value EVERYWHERE

  def initialize(@revwalk : LibGit2::X_Revwalk)
  end

  def initialize(repo : Repository)
    LibGit2.revwalk_new(out @revwalk, repo.to_unsafe)
  end

  def finalize
    LibGit2.revwalk_free(@revwalk)
  end

  def sorting(sorting : Sorting)
    LibGit2.revwalk_sorting(@revwalk, sorting)
  end

  def push(oid : Oid)
    LibGit2.revwalk_push(@revwalk, oid.to_unsafe)
  end

  def reset
    LibGit2.revwalk_reset(@revwalk)
  end

  def next_oid
    r = LibGit2.revwalk_next(out oid, @revwalk)
    if r == -31
      return nil
    end
    Oid.new(oid)
  end

  def each_oid
    while (oid = self.next_oid) != nil
      yield oid
    end
  end
end

