class Git::Reference
  def initialize(@ref : LibGit2::X_Reference)
    @type = LibGit2.reference_type(@ref)
    #puts LibGit2.reference_symbolic_target(@ref)
  end

  def finalize
    LibGit2.reference_free(@ref)
  end

  def name
    String.new(LibGit2.reference_name(@ref))
  end

  def symbolic_target
    r = LibGit2.reference_symbolic_target(@ref)
    if r.null?
      nil
    else
      String.new(r)
    end
  end

  def target_oid
    Oid.new(LibGit2.reference_target(@ref).value)
  end

  def owner
    Repository.new(LibGit2.reference_owner(@ref))
  end

  def to_unsafe
    @repo
  end
end
