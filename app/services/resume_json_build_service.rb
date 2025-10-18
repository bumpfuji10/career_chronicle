class ResumeJsonBuildService
  def initialize(resume:)
    @resume = resume
  end

  def execute 
    @resume.as_json(include: {companies: { include: { positions: { include: { tasks: { include: :achievements }}}}}})
  end
end