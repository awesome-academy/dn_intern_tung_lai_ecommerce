require "jwt"

module Services
  class Authentication
    ALGORITHM = "HS256".freeze

    class << self
      def sign payload
        JWT.encode(payload, Settings.token_secret, ALGORITHM)
      end

      def verify payload
        JWT.decode(payload, Settings.token_secret, true, algorithm: ALGORITHM)
           .first
      end
    end
  end
end
