module Finicity
  class GenericError < ::StandardError
    attr_reader :error_message, :http_status, :finicity_code

    def initialize(error_message = nil, http_status = nil, finicity_code = nil)
      @error_message = error_message
      @http_status = http_status
      @finicity_code = finicity_code
    end

    def to_s
      status = http_status.nil? ? "" : "[Status #{http_status}] "
      code = finicity_code.nil? ? "" : "[Finicity Code #{finicity_code}] "
      "#{status}#{code}#{error_message}"
    end
  end

  class AuthenticationError < ::Finicity::GenericError
  end

  class DuplicateCustomerError < ::StandardError
    attr_reader :username

    def initialize(username)
      @username = username
    end

    def to_s
      "Multiple customers found with username: #{username}"
    end
  end

  class FinicityAggregationError < ::StandardError
    ERROR_CODE_MAP = {
      '0' => 'Success.',
      '102' => 'Retry error. Website is down or there is a connectivity issue.',
      '103' => 'Invalid Credentials. Credentials must be updated.',
      '106' => 'Account Name/Number/Type mismatch.',
      '108' => 'End user action required at the third party site.',
      '109' => 'Password change required at the third party site.',
      '185' => 'MFA answer(s) missing.',
      '187' => 'Incorrect answer to MFA challenge question.'
    }

    attr_reader :aggregation_status_code

    def initialize(aggregation_status_code)
      @aggregation_status_code = aggregation_status_code
    end

    def error_message
      ERROR_CODE_MAP[aggregation_status_code.to_s] || 'Unknown Error'
    end

    def to_s
      "[Aggregation Status Code #{aggregation_status_code}] #{error_message}"
    end
  end

  class InvalidCredentialsError < ::Finicity::FinicityAggregationError
  end
end
