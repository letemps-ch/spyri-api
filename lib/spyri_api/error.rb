# frozen_string_literal: true

module SpyriApi
  class Error < StandardError

    attr_reader :status, :code, :details

    def initialize(status, body)
      @status = status
      if @status == 404
        @code = 'not_found'
      else
        data = JSON.parse(body)
        @code = data['code']
        @details = data['details']
      end
      super @code
    end

    def inspect
      "<#{self.class}: #{instance_variables.map { |v| "#{v}=#{instance_variable_get(v)}"}.join(', ')}>"
    end
  end
end