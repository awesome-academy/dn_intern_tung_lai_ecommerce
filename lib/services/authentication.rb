require "jwt"

module Services
  class Authentication
    ALGORITHM = "HS256".freeze

    class << self
      def sign payload
        JWT.encode(payload, ENV["TOKEN_SECRET"], ALGORITHM)
      end

      def verify payload
        JWT.decode(payload, ENV["TOKEN_SECRET"], true, algorithm: ALGORITHM)
           .first
      end
    end
  end
end
