class JsonResponseGenerator
  def initialize(resource = nil, options = {})
    @resource = resource
    @options = options
  end

  def generate
    if @resource&.persisted?
      success
    else
      error('保存に失敗しました', @resource&.errors&.full_messages)
    end
  end

  def success(data = nil)
    {
      status: 'success',
      data: data || serialize_resource
    }.to_json
  end

  def error(message = nil, errors = nil)
    response = {
      status: 'error',
      message: message || 'An error occurred'
    }
    response[:errors] = errors if errors.present?
    response.to_json
  end

  private

  def serialize_resource
    return nil unless @resource

    case @resource
    when Resume
      serialize_resume
    when User, ::Guest, ::Member
      serialize_user(@resource)
    else
      @resource.as_json
    end
  end

  def serialize_resume
    {
      id: @resource.id,
      summary: @resource.summary,
      user: @options[:user] ? serialize_user(@options[:user]) : nil
    }
  end

  def serialize_user(user)
    if user.is_a?(::Guest)
      {
        type: 'guest',
        id: user.id
      }
    else
      {
        type: 'registered',
        id: user.id,
        name: user.name,
        email: user.email
      }
    end
  end
end